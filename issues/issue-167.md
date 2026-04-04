# Issue #167: Deploy Microservices to Cloud

**State:** Open  
**Created:** 2026-04-01T00:23:20Z  
**Updated:** 2026-04-01T00:23:20Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/167

**Labels:** None

---

## Description

Deploy the Notes App microservices to a cloud provider using virtual machines, container services (EKS, GKE, AKS), or dedicated hosting options. The issue covers the full spectrum of cloud deployment options across AWS, GCP, and Azure — from general-purpose VMs to dedicated single-tenant physical hosts for compliance-sensitive workloads.

---

## Cloud VM Options Covered

### Multi-Tenant Virtual Machine Services (Shared Infrastructure)

| Provider | Service | Key Notes |
|----------|---------|-----------|
| **AWS** | Amazon EC2 | On-demand / spot / reserved; instance families: General Purpose, Compute, Memory, Storage, GPU |
| **GCP** | Compute Engine | x86 and ARM architectures; Scale Out, general purpose, ultra-high memory, accelerator-optimized |
| **Azure** | Azure Virtual Machines | Linux/Windows; Burstable, Compute-optimized, Memory-optimized, GPU, HPC series |

### Dedicated / Single-Tenant Hosts (Compliance-Grade Isolation)

| Provider | Service | Key Notes |
|----------|---------|-----------|
| **AWS** | EC2 Dedicated Instances | Hardware dedicated to a single AWS account; may share with other non-Dedicated instances in same account |
| **AWS** | EC2 Dedicated Hosts | Full physical server under your control; license-bring-your-own, compliance workloads |
| **GCP** | Sole-Tenant Nodes | Physical server exclusive to one project; physical isolation from other customers' workloads |
| **Azure** | Azure Dedicated Hosts | Physical servers dedicated to one organization; compliance, workload isolation, capacity reservation |

---

## Deployment Paths for Microservices

This issue introduces three deployment strategies:

1. **VM-based Deployment** — Deploy each microservice as a Docker container on EC2/GCP/Azure VMs, managed by Docker Compose or systemd.

2. **Managed Kubernetes (EKS / GKE / AKS)** — Use cloud-managed Kubernetes clusters (no control-plane management). Recommended path for the Notes App.

3. **Dedicated Hosting** — For regulated industries (finance, healthcare) where physical isolation between tenants is a compliance requirement.

---

## Learning Objectives

- [ ] Understand cloud VM categories (general purpose, compute-optimized, memory-optimized, GPU)
- [ ] Understand the difference between multi-tenant VMs and dedicated/sole-tenant hosts
- [ ] Deploy the Notes App microservices to an EC2 instance using Docker
- [ ] Provision an EKS cluster (or GKE/AKS) and deploy all microservices via Kubernetes
- [ ] Understand when to use dedicated hosting (compliance, licensing, isolation)
- [ ] Compare cost vs isolation trade-offs across cloud providers

---

## Key Concepts

### Why Not Just EC2 VMs?
- A single VM is a single point of failure
- Scaling requires manual provisioning
- No self-healing if a pod crashes
- Prefer **managed Kubernetes** (EKS/GKE/AKS) for production microservices

### When to Use Dedicated Hosts
- HIPAA / PCI-DSS compliance requires physical isolation
- BYOL (Bring Your Own License) for Windows Server / SQL Server
- Hardware affinity for performance-sensitive workloads

---

## Tasks to Create

- `tasks/kubernetes/task-013-deploy-microservices-to-cloud.md`

---

## Notes App Integration

The Notes App microservices (API Gateway, Auth Service, Notes Service, Email Service) will be:
1. Containerized as Docker images pushed to ECR/GCR/ACR
2. Deployed to an EKS cluster (Terraform-provisioned) using the Kubernetes manifests from previous tasks
3. Optionally demonstrated on a bare EC2 VM with Docker Compose for comparison
4. Documented with cloud-provider cost and trade-off analysis
