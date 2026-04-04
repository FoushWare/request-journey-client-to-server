locals {
  name = "${var.project_name}-${var.environment}"
}

data "aws_caller_identity" "current" {}

# ─────────────────────────────────────────────────────────────
# IAM Role for Notes Service (IRSA)
# Permissions: S3 uploads, Secrets Manager
# ─────────────────────────────────────────────────────────────
resource "aws_iam_role" "notes_service" {
  name = "${local.name}-notes-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${var.oidc_provider}:sub" = "system:serviceaccount:notes-app:notes-service"
          "${var.oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "notes_service" {
  name = "${local.name}-notes-service-policy"
  role = aws_iam_role.notes_service.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "${var.s3_uploads_bucket_arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = var.s3_uploads_bucket_arn
      },
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = "arn:aws:secretsmanager:*:${data.aws_caller_identity.current.account_id}:secret:${local.name}/notes/*"
      }
    ]
  })
}

# ─────────────────────────────────────────────────────────────
# IAM Role for Auth Service (IRSA)
# Permissions: Secrets Manager, KMS decrypt
# ─────────────────────────────────────────────────────────────
resource "aws_iam_role" "auth_service" {
  name = "${local.name}-auth-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${var.oidc_provider}:sub" = "system:serviceaccount:notes-app:auth-service"
          "${var.oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "auth_service" {
  name = "${local.name}-auth-service-policy"
  role = aws_iam_role.auth_service.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = "arn:aws:secretsmanager:*:${data.aws_caller_identity.current.account_id}:secret:${local.name}/rds/*"
      },
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = "arn:aws:secretsmanager:*:${data.aws_caller_identity.current.account_id}:secret:${local.name}/auth/*"
      }
    ]
  })
}

# ─────────────────────────────────────────────────────────────
# IAM Role for Backup Job (IRSA)
# Permissions: RDS snapshots, S3 backups
# ─────────────────────────────────────────────────────────────
resource "aws_iam_role" "backup_job" {
  name = "${local.name}-backup-job-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Condition = {
        StringEquals = {
          "${var.oidc_provider}:sub" = "system:serviceaccount:notes-app:backup-job"
          "${var.oidc_provider}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "backup_job" {
  name = "${local.name}-backup-job-policy"
  role = aws_iam_role.backup_job.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject"]
        Resource = "${var.s3_backups_bucket_arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["rds:CreateDBSnapshot", "rds:DescribeDBSnapshots"]
        Resource = "*"
      }
    ]
  })
}
