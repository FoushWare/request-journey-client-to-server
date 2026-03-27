locals {
  name = "${var.project_name}-${var.environment}"
}

# ─────────────────────────────────────────────────────────────
# S3 Buckets
# ─────────────────────────────────────────────────────────────
resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets

  bucket        = "${local.name}-${each.key}"
  force_destroy = false

  tags = { Name = "${local.name}-${each.key}" }
}

# Enable versioning on all configured buckets
resource "aws_s3_bucket_versioning" "buckets" {
  for_each = { for k, v in var.buckets : k => v if lookup(v, "versioning", false) }

  bucket = aws_s3_bucket.buckets[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt all buckets
resource "aws_s3_bucket_server_side_encryption_configuration" "buckets" {
  for_each = var.buckets

  bucket = aws_s3_bucket.buckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_id
    }
    bucket_key_enabled = true
  }
}

# Block all public access by default
resource "aws_s3_bucket_public_access_block" "buckets" {
  for_each = { for k, v in var.buckets : k => v if !lookup(v, "public_access", false) }

  bucket = aws_s3_bucket.buckets[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle rules for uploads bucket
resource "aws_s3_bucket_lifecycle_configuration" "uploads" {
  for_each = { for k, v in var.buckets : k => v if lookup(v, "lifecycle_days", 0) > 0 }

  bucket = aws_s3_bucket.buckets[each.key].id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = lookup(each.value, "lifecycle_days", 365)
    }
  }

  dynamic "rule" {
    for_each = lookup(each.value, "glacier_days", 0) > 0 ? [1] : []

    content {
      id     = "glacier-transition"
      status = "Enabled"

      transition {
        days          = lookup(each.value, "glacier_days", 30)
        storage_class = "GLACIER"
      }
    }
  }
}

# CORS for uploads bucket (frontend file uploads)
resource "aws_s3_bucket_cors_configuration" "uploads" {
  for_each = { for k, v in var.buckets : k => v if lookup(v, "cors_enabled", false) }

  bucket = aws_s3_bucket.buckets[each.key].id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"] # Restrict to your domain in production
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
