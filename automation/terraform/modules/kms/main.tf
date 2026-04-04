locals {
  name = "${var.project_name}-${var.environment}"
}

# ─────────────────────────────────────────────────────────────
# KMS Keys
# ─────────────────────────────────────────────────────────────
resource "aws_kms_key" "rds" {
  description             = "RDS encryption key for ${local.name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = { Name = "${local.name}-rds-key" }
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${local.name}-rds"
  target_key_id = aws_kms_key.rds.key_id
}

resource "aws_kms_key" "elasticache" {
  description             = "ElastiCache encryption key for ${local.name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = { Name = "${local.name}-elasticache-key" }
}

resource "aws_kms_alias" "elasticache" {
  name          = "alias/${local.name}-elasticache"
  target_key_id = aws_kms_key.elasticache.key_id
}

resource "aws_kms_key" "s3" {
  description             = "S3 encryption key for ${local.name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = { Name = "${local.name}-s3-key" }
}

resource "aws_kms_alias" "s3" {
  name          = "alias/${local.name}-s3"
  target_key_id = aws_kms_key.s3.key_id
}

resource "aws_kms_key" "ecr" {
  description             = "ECR encryption key for ${local.name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = { Name = "${local.name}-ecr-key" }
}

resource "aws_kms_alias" "ecr" {
  name          = "alias/${local.name}-ecr"
  target_key_id = aws_kms_key.ecr.key_id
}
