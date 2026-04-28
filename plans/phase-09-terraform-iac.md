# Phase 09 — Terraform & Infrastructure as Code

## Overview

Ansible configures software on existing servers. **Terraform** provisions the servers themselves. This phase uses Terraform to declare — and automatically create — the entire AWS cloud infrastructure the Notes App needs: VPC, subnets, EC2 instances, EKS cluster, RDS Postgres, ElastiCache Redis, S3 buckets, ECR container registries, IAM roles, security groups, KMS keys, and ACM TLS certificates.

Everything is version-controlled, peer-reviewed, and reproducible. `terraform apply` creates the full environment; `terraform destroy` tears it down.

## Prerequisites

- **Phase 03 complete** — You understand the Kubernetes resources that will run on the EKS cluster provisioned here
- **Phase 08 complete** — Ansible knowledge (Terraform provisions, Ansible configures)
- An AWS account with sufficient permissions (or a LocalStack environment for local practice)
- Terraform CLI installed (`terraform -version`)

## Learning Objectives

- Understand Terraform concepts: providers, resources, data sources, outputs, variables, state, modules
- Initialise a Terraform project and connect it to the AWS provider
- Create reusable Terraform modules (vpc, eks, rds, elasticache, s3, ecr, iam, security_groups, kms, acm)
- Manage Terraform state remotely in an S3 backend with DynamoDB locking
- Use `terraform plan` to preview changes and `terraform apply` to execute them
- Provision a complete VPC with public and private subnets, Internet Gateway, and NAT Gateway
- Provision an EKS cluster with a managed node group
- Provision an RDS PostgreSQL instance (multi-AZ for production)
- Use `terraform output` to feed values (cluster endpoint, VPC IDs) to Ansible and Kubernetes
- Follow Terraform best practices: modules, remote state, variable validation, sensitive outputs

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/terraform/task-001-install-terraform.md`
   > Install Terraform CLI. Configure the AWS provider with access keys (or assume role). Run `terraform init` in a blank directory.

2. `tasks/terraform/task-002-understand-terraform-basics.md`
   > Write a minimal Terraform config that creates an S3 bucket. Run `plan` → `apply` → `destroy`. Understand HCL syntax, state files, and the dependency graph.

3. `tasks/terraform/task-003-create-aws-infrastructure.md`
   > Scaffold the root `main.tf` that wires together all modules. Define `variables.tf` with environment (dev/staging/prod) and region inputs. Define `outputs.tf`.

4. `tasks/terraform/task-004-provision-ec2-instances.md`
   > Write the `ec2` or `vpc` module to launch an EC2 instance in a public subnet. SSH in to verify. Use `user_data` to install Docker automatically.

5. `tasks/terraform/task-005-provision-rds-database.md`
   > Write the `rds` module. Provision a PostgreSQL `db.t3.micro` instance in a private subnet. Output the endpoint. Connect from the backend with the provisioned credentials.

6. `tasks/terraform/task-006-provision-s3-buckets.md`
   > Write the `s3` module. Create buckets for: Notes App attachments, Terraform state, and MFE static assets (CSR MFEs will be deployed here in Phase 10).

7. `tasks/terraform/task-007-create-vpc-and-networking.md`
   > Write the `vpc` module: VPC CIDR, public subnets, private subnets, Internet Gateway, NAT Gateway, route tables. Verify instances in private subnets can reach the internet via NAT.

8. `tasks/terraform/task-008-provision-eks-cluster.md`
   > Write the `eks` module. Provision an EKS cluster with a managed node group (`t3.medium × 3`). Configure `kubectl` to point to the new cluster. Apply the Notes App K8s manifests from Phase 03.

9. `tasks/terraform/task-009-terraform-state-management.md`
   > Move the Terraform state to an S3 backend with DynamoDB locking. Set up workspace separation (`dev`, `staging`, `prod`). Enable state encryption with KMS.

10. `tasks/terraform/task-010-terraform-modules-and-best-practices.md`
    > Extract all resources into reusable modules. Add input variable validation. Use `sensitive = true` on secret outputs. Add `terraform fmt` and `terraform validate` to the CI/CD pipeline.

## Module Structure

```
automation/terraform/
├── main.tf                  ← Root module wiring all sub-modules
├── variables.tf
├── outputs.tf
├── backend.tf               ← S3 remote state + DynamoDB lock
└── modules/
    ├── vpc/                 ← VPC, subnets, IGW, NAT
    ├── eks/                 ← EKS cluster + node groups
    ├── rds/                 ← Postgres RDS (multi-AZ)
    ├── elasticache/         ← Redis cluster
    ├── s3/                  ← S3 buckets + policies
    ├── ecr/                 ← Container image registries
    ├── iam/                 ← Roles, IRSA policies
    ├── security_groups/     ← Port allowlists per tier
    ├── kms/                 ← Encryption keys for RDS + S3
    └── acm/                 ← TLS certificates (ACM)
```

## Success Criteria

Before moving to Phase 10, verify:

- [ ] `terraform plan` produces a readable plan with no errors
- [ ] `terraform apply` provisions the full AWS infrastructure without manual AWS Console clicks
- [ ] EKS cluster is reachable with `kubectl get nodes` after `aws eks update-kubeconfig`
- [ ] RDS endpoint is resolvable from inside the EKS cluster (private DNS)
- [ ] S3 bucket for MFE static assets exists and has the correct bucket policy
- [ ] Terraform state is stored in S3 — not locally in `terraform.tfstate`
- [ ] `terraform destroy` cleanly removes all provisioned resources (important: avoid ongoing costs)

---

## ➡️ Next Phase

**[Phase 10 — AWS Cloud Deployment](./phase-10-aws-cloud.md)**

With infrastructure provisioned by Terraform, Phase 10 deploys the Notes App to AWS: push Docker images to ECR, deploy Kubernetes manifests to EKS, host MFE static assets on S3 + CloudFront, and wire up Route 53 DNS.
