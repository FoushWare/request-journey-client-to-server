# Task: Cloud Provider Alternatives (Digital Ocean & Azure)

**Related Issue:** #149  
**Category:** AWS  
**Prerequisites:** Basic AWS knowledge  
**Estimated Time:** 3–4 hours  
**Notes App Context:** Optional deployment of Notes App on Digital Ocean or Azure

---

## Learning Objectives

- Compare AWS, Digital Ocean, and Azure
- Set up a Digital Ocean account and deploy a Droplet
- Set up an Azure account and use key services
- Understand cloud portability and multi-cloud concepts

---

## Theory Section

### AWS vs Digital Ocean vs Azure

| Feature | AWS | Digital Ocean | Azure |
|---------|-----|--------------|-------|
| **Market Position** | #1 cloud | Developer-focused | #2 cloud (Microsoft) |
| **Complexity** | High | Low | High |
| **Learning Curve** | Steep | Gentle | Steep |
| **Pricing** | Complex | Simple, predictable | Complex |
| **Free Tier** | 12 months + always-free | $200 credit | $200 credit + 12 months |
| **Managed K8s** | EKS | DOKS | AKS |
| **Best For** | Enterprise, all use cases | Startups, simplicity | Microsoft stack, enterprise |

### Key Services Comparison

| Use Case | AWS | Digital Ocean | Azure |
|---------|-----|--------------|-------|
| Virtual Machine | EC2 | Droplet | Virtual Machine |
| Object Storage | S3 | Spaces | Blob Storage |
| Managed K8s | EKS | DOKS | AKS |
| Serverless | Lambda | Functions | Azure Functions |
| Database | RDS | Managed DB | Azure SQL |
| CDN | CloudFront | CDN | Azure CDN |

---

## Step-by-Step Instructions

### Option A: Digital Ocean (Recommended for Beginners)

#### Step 1: Create Account and Get Free Credits
1. Sign up at https://digitalocean.com (get $200 credit)
2. Explore the dashboard

#### Step 2: Deploy a Droplet

```bash
# Install doctl (Digital Ocean CLI)
brew install doctl

# Authenticate
doctl auth init

# Create a Droplet
doctl compute droplet create notes-app-server \
  --size s-1vcpu-1gb \
  --image ubuntu-22-04-x64 \
  --region nyc3 \
  --ssh-keys <your-key-id>

# SSH into Droplet
ssh root@<droplet-ip>
```

#### Step 3: Deploy Notes App to Droplet

```bash
# On the Droplet
apt update && apt install -y docker.io docker-compose
git clone https://github.com/FoushWare/request-journey-client-to-server
cd request-journey-client-to-server
docker-compose up -d
```

#### Step 4: Try Digital Ocean Kubernetes (DOKS)

```bash
# Create a DOKS cluster (smallest, cheapest)
doctl kubernetes cluster create notes-cluster \
  --region nyc3 \
  --node-pool "name=worker-pool;size=s-2vcpu-4gb;count=2"

# Get credentials
doctl kubernetes cluster kubeconfig save notes-cluster

# Deploy Notes App
kubectl apply -f kubernetes/
```

### Option B: Microsoft Azure

#### Step 1: Create Free Account
1. Sign up at https://azure.microsoft.com/free
2. Get $200 credit for 30 days + 12-month free services

#### Step 2: Use Azure Portal or CLI

```bash
# Install Azure CLI
brew install azure-cli

# Login
az login

# Create resource group
az group create --name notes-app-rg --location eastus

# Create a VM
az vm create \
  --resource-group notes-app-rg \
  --name notes-app-vm \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys
```

#### Step 3: Deploy to Azure Kubernetes Service (AKS)

```bash
# Create AKS cluster
az aks create \
  --resource-group notes-app-rg \
  --name notes-aks-cluster \
  --node-count 2 \
  --node-vm-size Standard_B2s \
  --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group notes-app-rg --name notes-aks-cluster
```

---

## ⚠️ Cost Warning

Always destroy resources when not in use:

```bash
# Digital Ocean: destroy droplet when done
doctl compute droplet delete notes-app-server

# Azure: delete entire resource group
az group delete --name notes-app-rg --yes
```

---

## Task Checklist

- [ ] Compared AWS vs Digital Ocean vs Azure
- [ ] Created Digital Ocean or Azure account
- [ ] Deployed Notes App to a VM (Droplet or Azure VM)
- [ ] Explored managed Kubernetes (DOKS or AKS)
- [ ] Resources cleaned up to avoid charges

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed
