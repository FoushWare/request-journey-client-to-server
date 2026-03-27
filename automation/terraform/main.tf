provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

# ─────────────────────────────────────────────────────────────
# Module: VPC
# ─────────────────────────────────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  data_subnet_cidrs    = var.data_subnet_cidrs
}

# ─────────────────────────────────────────────────────────────
# Module: EKS
# ─────────────────────────────────────────────────────────────
module "eks" {
  source = "./modules/eks"

  project_name     = var.project_name
  environment      = var.environment
  cluster_name     = "${var.project_name}-${var.environment}-cluster"
  kubernetes_version = var.kubernetes_version

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_app_subnet_ids

  node_groups = {
    general = {
      instance_types = var.eks_node_instance_types
      min_size       = var.eks_node_min_size
      max_size       = var.eks_node_max_size
      desired_size   = var.eks_node_desired_size
      disk_size      = 50
    }
    spot = {
      instance_types  = ["m5.large", "m5a.large", "m4.large"]
      capacity_type   = "SPOT"
      min_size        = 0
      max_size        = 10
      desired_size    = 0
      disk_size       = 50
    }
  }

  depends_on = [module.vpc]
}

# ─────────────────────────────────────────────────────────────
# Module: RDS PostgreSQL (Auth Service)
# ─────────────────────────────────────────────────────────────
module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  identifier         = "${var.project_name}-${var.environment}-postgres"
  engine_version     = var.rds_postgres_version
  instance_class     = var.rds_instance_class
  allocated_storage  = var.rds_allocated_storage
  database_name      = "notes_auth"

  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_data_subnet_ids
  security_group_ids  = [module.security_groups.rds_security_group_id]
  kms_key_id          = module.kms.rds_key_arn

  multi_az               = var.environment == "prod" ? true : false
  backup_retention_days  = var.environment == "prod" ? 30 : 7
  deletion_protection    = var.environment == "prod" ? true : false

  depends_on = [module.vpc, module.kms, module.security_groups]
}

# ─────────────────────────────────────────────────────────────
# Module: ElastiCache Redis (Cache + Sessions)
# ─────────────────────────────────────────────────────────────
module "elasticache" {
  source = "./modules/elasticache"

  project_name  = var.project_name
  environment   = var.environment
  cluster_id    = "${var.project_name}-${var.environment}-redis"
  node_type     = var.redis_node_type
  num_shards    = var.environment == "prod" ? 3 : 1
  replicas_per_shard = var.environment == "prod" ? 1 : 0

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_data_subnet_ids
  security_group_ids = [module.security_groups.redis_security_group_id]
  kms_key_id         = module.kms.elasticache_key_arn

  depends_on = [module.vpc, module.kms, module.security_groups]
}

# ─────────────────────────────────────────────────────────────
# Module: S3 Buckets
# ─────────────────────────────────────────────────────────────
module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
  kms_key_id   = module.kms.s3_key_arn

  buckets = {
    uploads = {
      versioning       = true
      lifecycle_days   = 365
      cors_enabled     = true
    }
    assets = {
      versioning     = false
      public_access  = true
      cloudfront_only = true
    }
    backups = {
      versioning       = true
      lifecycle_days   = 90
      glacier_days     = 30
    }
  }

  depends_on = [module.kms]
}

# ─────────────────────────────────────────────────────────────
# Module: ECR
# ─────────────────────────────────────────────────────────────
module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  kms_key_id   = module.kms.ecr_key_arn

  repositories = [
    "auth-service",
    "notes-service",
    "email-service",
    "search-service",
    "notification-service",
  ]
}

# ─────────────────────────────────────────────────────────────
# Module: IAM Roles (IRSA per service)
# ─────────────────────────────────────────────────────────────
module "iam" {
  source = "./modules/iam"

  project_name     = var.project_name
  environment      = var.environment
  cluster_name     = module.eks.cluster_name
  oidc_provider    = module.eks.oidc_provider
  oidc_provider_arn = module.eks.oidc_provider_arn

  s3_uploads_bucket_arn = module.s3.bucket_arns["uploads"]
  s3_backups_bucket_arn = module.s3.bucket_arns["backups"]

  depends_on = [module.eks, module.s3]
}

# ─────────────────────────────────────────────────────────────
# Module: Security Groups
# ─────────────────────────────────────────────────────────────
module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr

  depends_on = [module.vpc]
}

# ─────────────────────────────────────────────────────────────
# Module: KMS Keys
# ─────────────────────────────────────────────────────────────
module "kms" {
  source = "./modules/kms"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
}

# ─────────────────────────────────────────────────────────────
# Module: ACM (TLS Certificates)
# ─────────────────────────────────────────────────────────────
module "acm" {
  source = "./modules/acm"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  zone_id      = var.route53_zone_id
}
