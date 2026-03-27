# Notes App — Terraform Infrastructure

Provisions the complete AWS infrastructure for the Notes App on EKS.

## What This Creates

| Resource | Details |
|----------|---------|
| **VPC** | 3 public + 3 private app + 3 private data subnets across 3 AZs |
| **EKS** | Kubernetes cluster with 2 managed node groups |
| **RDS** | PostgreSQL Multi-AZ for the Auth Service |
| **ElastiCache** | Redis cluster for caching and sessions |
| **DocumentDB** | MongoDB-compatible for the Notes Service |
| **S3** | 3 buckets: uploads, assets, backups |
| **ECR** | Container registry for Docker images |
| **IAM** | Roles per service (IRSA) |
| **KMS** | Encryption keys |
| **ACM** | TLS certificates |
| **Security Groups** | Least-privilege network rules |

## Prerequisites

```bash
# Install tools
brew install terraform awscli kubectl helm

# Configure AWS credentials
aws configure
# or use a named profile:
export AWS_PROFILE=notes-app-dev

# Check connectivity
aws sts get-caller-identity
```

## Usage

```bash
# Clone and navigate
cd automation/terraform

# Initialize providers and download modules
terraform init

# Review what will be created
terraform plan -out=tfplan

# Apply (creates all resources)
terraform apply tfplan

# Configure kubectl
aws eks update-kubeconfig --name notes-app-cluster --region us-east-1

# Destroy when done
terraform destroy
```

## State Management

Remote state is stored in S3 with DynamoDB locking. Create these manually first:

```bash
# Create state bucket (one-time setup)
aws s3api create-bucket \
  --bucket notes-app-terraform-state \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket notes-app-terraform-state \
  --versioning-configuration Status=Enabled

# Create DynamoDB lock table
aws dynamodb create-table \
  --table-name notes-app-terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

## Environments

```bash
# Development (LocalStack — free)
terraform workspace new dev
terraform apply -var-file=environments/dev.tfvars

# Staging
terraform workspace new staging
terraform apply -var-file=environments/staging.tfvars

# Production
terraform workspace new prod
terraform apply -var-file=environments/prod.tfvars
```

## Cost Estimate (us-east-1)

| Resource | Dev (LocalStack) | Staging/month | Prod/month |
|---------|-----------------|--------------|-----------|
| EKS cluster | Free | ~$73 | ~$73 |
| EC2 nodes (m5.large × 2) | Free | ~$140 | ~$280 (×4) |
| RDS PostgreSQL (db.t3.medium) | Free | ~$60 | ~$250 |
| ElastiCache Redis | Free | ~$25 | ~$100 |
| S3 | Free | ~$5 | ~$20 |
| **Total** | **Free** | **~$303** | **~$723** |

> 💡 Use the `dev` workspace with LocalStack to develop and test for free.

## Module Structure

```
automation/terraform/
├── main.tf              # Root module, backend config, module calls
├── variables.tf         # Input variables with defaults
├── outputs.tf           # Cluster endpoint, DB connection strings
├── versions.tf          # Provider version constraints
├── vpc.tf               # VPC, subnets, IGW, NAT, route tables
├── eks.tf               # EKS cluster and node groups
├── rds.tf               # PostgreSQL RDS
├── elasticache.tf       # Redis ElastiCache
├── s3.tf                # S3 buckets
├── ecr.tf               # Container registries
├── iam.tf               # IAM roles (IRSA per service)
├── security_groups.tf   # Security group rules
├── kms.tf               # Encryption keys
├── acm.tf               # TLS certificates
└── environments/
    ├── dev.tfvars
    ├── staging.tfvars
    └── prod.tfvars
```
