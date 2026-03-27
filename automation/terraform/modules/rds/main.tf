locals {
  name = "${var.project_name}-${var.environment}"
}

resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()_+-="
}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${local.name}/rds/password"
  description             = "RDS PostgreSQL password for ${local.name}"
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = "notes_admin"
    password = random_password.db_password.result
    host     = aws_db_instance.main.address
    port     = aws_db_instance.main.port
    dbname   = var.database_name
  })
}

resource "aws_db_subnet_group" "main" {
  name        = "${local.name}-db-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for ${local.name} RDS"

  tags = { Name = "${local.name}-db-subnet-group" }
}

resource "aws_db_parameter_group" "postgres" {
  name   = "${local.name}-postgres-params"
  family = "postgres${split(".", var.engine_version)[0]}"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000" # log queries taking > 1s
  }

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }
}

resource "aws_db_instance" "main" {
  identifier     = var.identifier
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 3
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = var.kms_key_id

  db_name  = var.database_name
  username = "notes_admin"
  password = random_password.db_password.result

  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.postgres.name

  multi_az               = var.multi_az
  publicly_accessible    = false
  deletion_protection    = var.deletion_protection
  skip_final_snapshot    = !var.deletion_protection
  final_snapshot_identifier = var.deletion_protection ? "${local.name}-final-snapshot" : null

  backup_retention_period   = var.backup_retention_days
  backup_window             = "03:00-04:00"
  maintenance_window        = "Mon:04:00-Mon:05:00"
  auto_minor_version_upgrade = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  monitoring_interval                   = 60
  monitoring_role_arn                   = aws_iam_role.rds_enhanced_monitoring.arn

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = { Name = var.identifier }
}

# Read Replica
resource "aws_db_instance" "read_replica" {
  count = var.multi_az ? 1 : 0

  identifier     = "${var.identifier}-replica"
  instance_class = var.instance_class

  replicate_source_db = aws_db_instance.main.identifier
  storage_encrypted   = true

  publicly_accessible = false
  skip_final_snapshot = true

  performance_insights_enabled = true
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_enhanced_monitoring.arn

  tags = { Name = "${var.identifier}-replica" }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name = "${local.name}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
