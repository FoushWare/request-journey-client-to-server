# ─────────────────────────────────────────────────────────────
# Cluster
# ─────────────────────────────────────────────────────────────
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

output "kubeconfig_command" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}

# ─────────────────────────────────────────────────────────────
# Networking
# ─────────────────────────────────────────────────────────────
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs (EKS nodes)"
  value       = module.vpc.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Private data subnet IDs (RDS, Redis)"
  value       = module.vpc.private_data_subnet_ids
}

# ─────────────────────────────────────────────────────────────
# Databases
# ─────────────────────────────────────────────────────────────
output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds.endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = module.rds.port
}

output "redis_endpoint" {
  description = "ElastiCache Redis primary endpoint"
  value       = module.elasticache.primary_endpoint
  sensitive   = true
}

output "redis_port" {
  description = "ElastiCache Redis port"
  value       = module.elasticache.port
}

# ─────────────────────────────────────────────────────────────
# Storage
# ─────────────────────────────────────────────────────────────
output "s3_bucket_uploads" {
  description = "S3 bucket name for user uploads"
  value       = module.s3.bucket_names["uploads"]
}

output "s3_bucket_assets" {
  description = "S3 bucket name for static assets"
  value       = module.s3.bucket_names["assets"]
}

output "s3_bucket_backups" {
  description = "S3 bucket name for database backups"
  value       = module.s3.bucket_names["backups"]
}

# ─────────────────────────────────────────────────────────────
# ECR Repositories
# ─────────────────────────────────────────────────────────────
output "ecr_repository_urls" {
  description = "ECR repository URLs per service"
  value       = module.ecr.repository_urls
}

# ─────────────────────────────────────────────────────────────
# IAM (IRSA)
# ─────────────────────────────────────────────────────────────
output "notes_service_role_arn" {
  description = "IAM role ARN for Notes Service (IRSA)"
  value       = module.iam.notes_service_role_arn
}

output "auth_service_role_arn" {
  description = "IAM role ARN for Auth Service (IRSA)"
  value       = module.iam.auth_service_role_arn
}

# ─────────────────────────────────────────────────────────────
# Certificate
# ─────────────────────────────────────────────────────────────
output "acm_certificate_arn" {
  description = "ACM TLS certificate ARN for ALB"
  value       = module.acm.certificate_arn
}
