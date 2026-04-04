locals {
  name = "${var.project_name}-${var.environment}"
}

resource "aws_elasticache_subnet_group" "main" {
  name        = "${local.name}-redis-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "ElastiCache subnet group for ${local.name}"
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = var.cluster_id
  description          = "Redis cluster for ${local.name} — cache and sessions"

  node_type            = var.node_type
  num_node_groups      = var.num_shards
  replicas_per_node_group = var.replicas_per_shard

  engine               = "redis"
  engine_version       = "7.0"
  port                 = 6379
  parameter_group_name = aws_elasticache_parameter_group.redis.name

  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = var.security_group_ids

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  kms_key_id                 = var.kms_key_id
  auth_token                 = random_password.redis_auth_token.result

  automatic_failover_enabled = var.num_shards > 1 ? true : false
  multi_az_enabled           = var.num_shards > 1 ? true : false

  snapshot_retention_limit   = 5
  snapshot_window            = "05:00-06:00"
  maintenance_window         = "Mon:06:00-Mon:07:00"

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }

  tags = { Name = var.cluster_id }
}

resource "random_password" "redis_auth_token" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "redis_auth" {
  name       = "${local.name}/redis/auth-token"
  kms_key_id = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "redis_auth" {
  secret_id     = aws_secretsmanager_secret.redis_auth.id
  secret_string = random_password.redis_auth_token.result
}

resource "aws_elasticache_parameter_group" "redis" {
  name   = "${local.name}-redis-params"
  family = "redis7"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }

  parameter {
    name  = "notify-keyspace-events"
    value = "Ex" # Enable keyspace notifications for expired events
  }
}

resource "aws_cloudwatch_log_group" "redis" {
  name              = "/aws/elasticache/${local.name}-redis"
  retention_in_days = 14
}
