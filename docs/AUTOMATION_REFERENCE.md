# 🤖 Automation Reference

> **Every task in this project teaches concepts manually/raw.**  
> This document maps every task category to the equivalent production-grade automation in `automation/`.

---

## The Two Layers

```
tasks/          ← You learn here: manual, step-by-step, raw commands
automation/     ← Production equivalent: fully automated IaC
```

Both are required. You learn by doing it manually first, then you understand *why* the automation code is written the way it is.

---

## Task → Automation Matrix

### 🐳 Docker Tasks
| Task | Manual Steps In | Automation Equivalent |
|------|----------------|----------------------|
| Install Docker | `tasks/docker/task-001` | [`automation/ansible/roles/docker/`](../automation/ansible/roles/docker/) |
| Configure Docker daemon | `tasks/docker/task-005` | [`automation/ansible/roles/docker/tasks/main.yml`](../automation/ansible/roles/docker/tasks/main.yml) |
| Docker Compose setup | `tasks/docker/task-003` | Helm charts in [`automation/ansible/roles/notes-app/`](../automation/ansible/roles/notes-app/) |

---

### ☸️ Kubernetes Tasks
| Task | Manual Steps In | Automation Equivalent |
|------|----------------|----------------------|
| EKS cluster setup | `tasks/kubernetes/` | [`automation/terraform/modules/eks/`](../automation/terraform/modules/eks/) |
| Namespaces | `tasks/kubernetes/` | [`automation/ansible/roles/kubernetes/tasks/main.yml`](../automation/ansible/roles/kubernetes/tasks/main.yml) |
| Deploy workloads | `tasks/kubernetes/` | [`automation/ansible/roles/notes-app/`](../automation/ansible/roles/notes-app/) |
| HPA / autoscaling | `tasks/kubernetes/` | Configured in [`automation/ansible/roles/notes-app/tasks/main.yml`](../automation/ansible/roles/notes-app/tasks/main.yml) |

---

### 🏗️ Terraform Tasks
| Task | Manual Steps In | Automation Equivalent |
|------|----------------|----------------------|
| Install Terraform | `tasks/terraform/task-001` | Already used in `automation/terraform/` |
| VPC & Networking | `tasks/terraform/` | [`automation/terraform/modules/vpc/`](../automation/terraform/modules/vpc/) |
| EKS cluster | `tasks/terraform/` | [`automation/terraform/modules/eks/`](../automation/terraform/modules/eks/) |
| RDS / PostgreSQL | `tasks/terraform/` | [`automation/terraform/modules/rds/`](../automation/terraform/modules/rds/) |
| Redis / ElastiCache | `tasks/terraform/` | [`automation/terraform/modules/elasticache/`](../automation/terraform/modules/elasticache/) |
| S3 Buckets | `tasks/terraform/` | [`automation/terraform/modules/s3/`](../automation/terraform/modules/s3/) |
| ECR Registries | `tasks/terraform/` | [`automation/terraform/modules/ecr/`](../automation/terraform/modules/ecr/) |
| IAM / IRSA | `tasks/terraform/` | [`automation/terraform/modules/iam/`](../automation/terraform/modules/iam/) |
| Security Groups | `tasks/terraform/` | [`automation/terraform/modules/security_groups/`](../automation/terraform/modules/security_groups/) |
| KMS encryption | `tasks/terraform/` | [`automation/terraform/modules/kms/`](../automation/terraform/modules/kms/) |
| ACM / TLS certs | `tasks/terraform/` | [`automation/terraform/modules/acm/`](../automation/terraform/modules/acm/) |

---

### 🔧 Ansible Tasks
| Task | Manual Steps In | Automation Equivalent |
|------|----------------|----------------------|
| Install tools | `tasks/ansible/` | [`automation/ansible/roles/kubernetes/`](../automation/ansible/roles/kubernetes/) |
| Deploy application | `tasks/ansible/` | [`automation/ansible/roles/notes-app/`](../automation/ansible/roles/notes-app/) |
| Setup monitoring | `tasks/ansible/` | [`automation/ansible/roles/monitoring/`](../automation/ansible/roles/monitoring/) |
| Security hardening | `tasks/ansible/` | [`automation/ansible/roles/security/`](../automation/ansible/roles/security/) |

---

### 🔒 Security Tasks
| Task | Manual Steps In | Automation Equivalent |
|------|----------------|----------------------|
| SSH hardening | `tasks/security/` | [`automation/ansible/roles/security/tasks/main.yml`](../automation/ansible/roles/security/tasks/main.yml) |
| Firewall setup | `tasks/security/` | [`automation/ansible/roles/security/tasks/main.yml`](../automation/ansible/roles/security/tasks/main.yml) |
| Secrets management | `tasks/vault/` | Secrets Manager in [`automation/terraform/modules/rds/`](../automation/terraform/modules/rds/) |
| TLS / Certificates | `tasks/security/` | [`automation/terraform/modules/acm/`](../automation/terraform/modules/acm/) |
| IAM least-privilege | `tasks/aws/` | [`automation/terraform/modules/iam/`](../automation/terraform/modules/iam/) |

---

### 📊 Monitoring / Observability Tasks
| Task | Manual Steps In | Automation Equivalent |
|------|----------------|----------------------|
| Prometheus + Grafana | `tasks/` (monitoring) | [`automation/ansible/roles/monitoring/`](../automation/ansible/roles/monitoring/) |
| Alerting rules | `tasks/` (monitoring) | Configured in [`automation/ansible/roles/monitoring/tasks/main.yml`](../automation/ansible/roles/monitoring/tasks/main.yml) |
| Jaeger tracing | `tasks/microservices/task-005` | Deployed in monitoring role |

---

### 🌐 AWS Tasks
| Task | Manual Steps In | Automation Equivalent |
|------|----------------|----------------------|
| VPC + Networking | `tasks/aws/task-007` | [`automation/terraform/modules/vpc/`](../automation/terraform/modules/vpc/) |
| EKS cluster | `tasks/aws/` | [`automation/terraform/modules/eks/`](../automation/terraform/modules/eks/) |
| RDS database | `tasks/aws/` | [`automation/terraform/modules/rds/`](../automation/terraform/modules/rds/) |
| S3 storage | `tasks/aws/` | [`automation/terraform/modules/s3/`](../automation/terraform/modules/s3/) |
| Full AWS infra | `tasks/aws/` | [`automation/terraform/main.tf`](../automation/terraform/main.tf) |

---

### 🔀 Microservices Tasks
| Task | Manual Steps In | Automation Equivalent |
|------|----------------|----------------------|
| Deploy services | `tasks/microservices/` | [`automation/ansible/roles/notes-app/`](../automation/ansible/roles/notes-app/) |
| Nx monorepo setup | `tasks/microservices/task-009` | Workspace config in `implementation/microservices/task-009-nx-monorepo/` |
| Service discovery | `tasks/microservices/task-003` | Kubernetes DNS (configured by EKS module) |

---

## Running the Full Automation

```bash
# Step 1 — Provision all infrastructure
cd automation/terraform
terraform init
terraform apply -var-file=environments/dev.tfvars

# Step 2 — Configure and deploy everything
cd automation/ansible
ansible-playbook site.yml -i inventory/hosts.ini

# Step 3 — Verify
kubectl get pods -A
```

For full documentation: [`automation/README.md`](../automation/README.md)

---

## Philosophy

> **Learn manually → understand automation.**

The reason tasks teach you raw commands is so you understand *what* the automation is doing when you read it. If you only ever run `terraform apply`, you won't know what's happening or how to debug it.

The progression is:
1. Do it manually (task files)
2. Understand what you did
3. Read the automation code (`automation/`)
4. Understand why it's written that way
5. Modify it for your needs
