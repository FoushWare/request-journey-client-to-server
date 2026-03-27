# 🤖 Full Automation — Infrastructure as Code

> This directory contains **complete automation** for the Notes App infrastructure.  
> Everything is code. Nothing is manual.

---

## Directory Structure

```
automation/
├── terraform/          # Infrastructure provisioning (AWS resources)
│   ├── main.tf         # Root module: calls all sub-modules
│   ├── variables.tf    # Input variables with defaults
│   ├── outputs.tf      # Cluster endpoints, connection strings
│   ├── versions.tf     # Provider version pins + S3 backend
│   ├── environments/   # Per-environment variable overrides
│   │   ├── dev.tfvars
│   │   ├── staging.tfvars
│   │   └── prod.tfvars
│   └── modules/        # Reusable Terraform modules
│       ├── vpc/        # VPC, subnets, NAT, routing
│       ├── eks/        # EKS cluster + node groups + OIDC
│       ├── rds/        # PostgreSQL Multi-AZ + read replicas
│       ├── elasticache/ # Redis cluster + sentinel
│       ├── s3/         # Buckets (uploads, assets, backups)
│       ├── ecr/        # Container registries + lifecycle policies
│       ├── iam/        # IRSA roles per microservice
│       ├── security_groups/ # Least-privilege firewall rules
│       ├── kms/        # Encryption keys per service
│       └── acm/        # TLS certificates (Route 53 validation)
│
└── ansible/            # Configuration & deployment automation
    ├── site.yml        # Master playbook (runs all roles)
    ├── ansible.cfg     # Ansible configuration
    ├── requirements.yml # Galaxy collection dependencies
    ├── inventory/      # Host definitions per environment
    └── roles/
        ├── docker/     # Install Docker, configure daemon
        ├── kubernetes/ # kubectl, helm, namespaces
        ├── notes-app/  # Deploy all services via Helm
        ├── monitoring/ # Prometheus + Grafana + Jaeger
        └── security/   # SSH, firewall, fail2ban, audit
```

---

## 🔄 Full Deployment Workflow

```
Developer → git push
    ↓
GitHub Actions CI (test + build + push ECR)
    ↓
Terraform (provision AWS infrastructure)
    ↓
Ansible (configure servers + deploy app)
    ↓
Argo CD (GitOps sync → Kubernetes)
    ↓
Running application ✅
```

---

## Quick Start

### Step 1 — Provision Infrastructure with Terraform

```bash
cd automation/terraform

# One-time: create Terraform state backend
./scripts/setup-backend.sh

# Initialize
terraform init

# Plan for dev environment
terraform workspace new dev
terraform plan -var-file=environments/dev.tfvars

# Apply
terraform apply -var-file=environments/dev.tfvars

# Get kubeconfig
aws eks update-kubeconfig --name notes-app-dev-cluster --region us-east-1
```

### Step 2 — Configure and Deploy with Ansible

```bash
cd automation/ansible

# Install dependencies
pip install ansible
ansible-galaxy collection install -r requirements.yml

# Test connectivity
ansible all -m ping -i inventory/hosts.ini

# Full deployment
ansible-playbook site.yml -i inventory/hosts.ini

# Deploy only the app (skip infra config)
ansible-playbook site.yml -i inventory/hosts.ini --tags app

# Deploy only monitoring
ansible-playbook site.yml -i inventory/hosts.ini --tags monitoring
```

### Step 3 — Verify

```bash
# Check pods
kubectl get pods -A

# Check services
kubectl get svc -n notes-app

# Get app URL
kubectl get ingress -n notes-app

# Check Grafana
kubectl get svc kube-prometheus-stack-grafana -n monitoring
```

---

## LocalStack — Free Local Development

Use [LocalStack](https://localstack.cloud/) to test Terraform locally without AWS costs:

```bash
# Start LocalStack
docker compose -f docker-compose.localstack.yml up -d

# Apply Terraform with LocalStack endpoint
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test

terraform init -backend=false
terraform apply -var-file=environments/dev.tfvars
```

---

## CI/CD Integration

Terraform and Ansible are run automatically in the CI/CD pipeline:

```yaml
# .github/workflows/infra.yml
- name: Terraform Plan (on PR)
  run: terraform plan -var-file=environments/${{ env.ENV }}.tfvars

- name: Terraform Apply (on merge to main)
  run: terraform apply -auto-approve -var-file=environments/staging.tfvars

- name: Ansible Deploy
  run: ansible-playbook site.yml -i inventory/staging.ini --tags app
```

---

## Learning Resources

| Topic | Our Task | System Design Primer |
|-------|---------|---------------------|
| Terraform basics | `tasks/terraform/task-001-install-terraform.md` | N/A |
| AWS VPC | `tasks/aws/task-007-create-vpc-and-networking.md` | [Scaling on AWS](https://github.com/donnemartin/system-design-primer/blob/master/solutions/system_design/scaling_aws/README.md) |
| EKS | `tasks/terraform/task-008-provision-eks-cluster.md` | N/A |
| Ansible basics | `tasks/ansible/task-001.md` | N/A |
| Full automation | `automation/` (this directory) | N/A |
