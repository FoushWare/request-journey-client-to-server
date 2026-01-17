# Task: Infrastructure as Code (IaC) - Terraform
**Issue:** #47 | **Category:** CI/CD | **Priority:** High | **Effort:** 8h

---

## 📋 Objective

Implement Infrastructure as Code using Terraform for reproducible infrastructure provisioning.

---

## 📝 Description

Create Terraform configuration for complete infrastructure:
- Kubernetes cluster setup
- Database infrastructure
- Networking and security groups
- Load balancers
- IAM roles and policies
- State management

---

## ✅ Acceptance Criteria

- [ ] Terraform structure created
- [ ] All infrastructure in code
- [ ] Variables and outputs defined
- [ ] Remote state configured
- [ ] Linting passing
- [ ] Plan review process
- [ ] Dry-run testing working
- [ ] Documentation complete
- [ ] Team trained
- [ ] Deployment automated

---

## 🔧 Sub-Tasks

### 1. Terraform Project Structure
- [ ] Initialize Terraform project
- [ ] Create directory structure
- [ ] Define providers
- [ ] Configure backend (S3)
- [ ] Set up state locking
- [ ] Document structure

### 2. VPC & Networking
- [ ] Create VPC
- [ ] Configure subnets
- [ ] Set up routing
- [ ] Create security groups
- [ ] Configure NAT gateway
- [ ] Document network topology

### 3. Kubernetes Cluster
- [ ] Create EKS cluster
- [ ] Configure worker nodes
- [ ] Set up networking
- [ ] Configure logging
- [ ] Set up monitoring
- [ ] Document cluster setup

### 4. Database Infrastructure
- [ ] Create RDS PostgreSQL
- [ ] Configure backups
- [ ] Set up security groups
- [ ] Configure parameter groups
- [ ] Create read replicas
- [ ] Document database setup

### 5. Load Balancer
- [ ] Create ALB
- [ ] Configure target groups
- [ ] Set up SSL/TLS
- [ ] Configure health checks
- [ ] Set up rules
- [ ] Document ALB setup

### 6. IAM Configuration
- [ ] Create IAM roles
- [ ] Define policies
- [ ] Set service accounts
- [ ] Configure permissions
- [ ] Document RBAC
- [ ] Review security

### 7. Variables & Outputs
- [ ] Define input variables
- [ ] Create terraform.tfvars
- [ ] Define outputs
- [ ] Document variables
- [ ] Create example values
- [ ] Set up validation

### 8. Linting & Validation
- [ ] Configure terraform fmt
- [ ] Run terraform validate
- [ ] Install tflint
- [ ] Configure linting rules
- [ ] Validate security
- [ ] Document standards

### 9. State Management
- [ ] Set up S3 backend
- [ ] Configure state locking
- [ ] Enable versioning
- [ ] Set up encryption
- [ ] Create backup strategy
- [ ] Document state management

### 10. CI/CD Integration
- [ ] Add terraform to pipeline
- [ ] Run plan on PR
- [ ] Auto-apply on merge
- [ ] Monitor deployments
- [ ] Create rollback procedure
- [ ] Document workflow

---

## 📚 Learning Resources

- **Terraform:** https://www.terraform.io/
- **AWS Provider:** https://registry.terraform.io/providers/hashicorp/aws
- **Best Practices:** https://www.terraform.io/language/values/locals
- **State Management:** https://www.terraform.io/language/state
- **Modules:** https://www.terraform.io/language/modules

---

## 💻 Code Example: Terraform Configuration

```hcl
# main.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
  
  backend "s3" {
    bucket         = "terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      CreatedAt   = timestamp()
    }
  }
}

# VPC
module "vpc" {
  source = "./modules/vpc"
  
  name_prefix        = var.project_name
  cidr_block         = var.vpc_cidr
  availability_zones = var.availability_zones
  
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# EKS Cluster
module "eks" {
  source = "./modules/eks"
  
  cluster_name    = "${var.project_name}-cluster"
  cluster_version = var.kubernetes_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  
  node_groups = {
    general = {
      desired_size = 3
      min_size     = 2
      max_size     = 10
      
      instance_types = ["t3.medium"]
      disk_size      = 100
    }
  }
  
  depends_on = [module.vpc]
}

# RDS Database
module "rds" {
  source = "./modules/rds"
  
  identifier       = "${var.project_name}-postgres"
  engine           = "postgres"
  engine_version   = "15.0"
  instance_class   = "db.t3.medium"
  
  allocated_storage = 100
  storage_type     = "gp3"
  storage_encrypted = true
  
  db_name  = "production_db"
  username = "postgres"
  password = random_password.db_password.result
  
  vpc_id           = module.vpc.vpc_id
  security_groups  = [module.vpc.database_security_group_id]
  db_subnet_group  = module.vpc.db_subnet_group_id
  
  backup_retention_period = 30
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"
  
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.project_name}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
}

# Random password for RDS
resource "random_password" "db_password" {
  length  = 32
  special = true
}

# Store password in Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project_name}/rds/password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id      = aws_secretsmanager_secret.db_password.id
  secret_string  = random_password.db_password.result
}

# Outputs
output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "rds_endpoint" {
  value       = module.rds.db_instance_endpoint
  description = "RDS database endpoint"
  sensitive   = true
}
```

---

## 💻 Variables File

```hcl
# variables.tf
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name"
  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 32
    error_message = "Project name must be between 1 and 32 characters."
  }
}

variable "environment" {
  type        = string
  description = "Environment (dev, staging, prod)"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.28"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
```

---

## 🔒 Security Best Practices

```hcl
# Security policies
- Enable encryption at rest for all resources
- Use security groups for network isolation
- Enable VPC Flow Logs
- Use IAM roles with least privilege
- Enable S3 backend encryption
- Use DynamoDB for state locking
- Validate all inputs
- Use remote state only
- Encrypt sensitive variables
- Audit all Terraform changes
```

---

## ✨ Success Metrics

- All infrastructure in Terraform
- 100% code coverage
- All linting checks passing
- Plan validation working
- Zero manual infrastructure changes
- Repeatable deployments

---

## 📖 Related Tasks

- [Ansible Automation](ci-cd-008.md) - Configuration management
- [CI/CD Pipeline](ci-cd-001.md) - Automation integration

---

**Created:** January 17, 2026 | **Last Updated:** January 17, 2026
