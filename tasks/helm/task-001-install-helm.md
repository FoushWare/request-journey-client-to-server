# Task: Helm - Install and Configure Helm

**Related Issue:** #139  
**Prerequisites:** task-001 through task-010 (Kubernetes basics)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Install Helm package manager for Kubernetes and learn how to use it to manage Notes App deployments more efficiently than raw YAML files

---

## Learning Objectives

- Understand what Helm is and why it's useful
- Install Helm CLI
- Learn Helm architecture (Charts, Releases, Repositories)
- Understand values, templates, and manifests
- Create your first Helm chart

---

## Theory Section

### What is Helm?

**Helm** is the package manager for Kubernetes. It helps you:
- Manage Kubernetes applications
- Package applications as charts
- Version and rollback deployments
- Share and reuse configurations

**Key Concepts:**
- **Chart**: Package of Kubernetes resources
- **Release**: Instance of a chart deployed to cluster
- **Repository**: Collection of charts
- **Values**: Configuration parameters
- **Templates**: Kubernetes manifests with variables

**Why Helm for Notes App:**
- Simplify deployment management
- Environment-specific configurations
- Easy rollbacks
- Reusable configurations

---

## Prerequisites Check

- [ ] Kubernetes cluster accessible
- [ ] kubectl configured
- [ ] Notes App deployed (for converting to Helm)

---

## Step-by-Step Instructions

### Step 1: Install Helm CLI

**Objective:** Install Helm command-line tool

**Instructions:**

1. **Install Helm (macOS):**
```bash
brew install helm
```

2. **Install Helm (Linux):**
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

3. **Verify installation:**
```bash
helm version
```

---

### Step 2: Understand Helm Architecture

**Objective:** Learn Helm concepts

**Key Concepts:**
- Charts contain templates
- Values customize charts
- Releases are deployed instances
- Repositories store charts

---

### Step 3: Add Helm Repositories

**Objective:** Access public charts

**Instructions:**

1. **Add common repositories:**
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable
```

2. **Update repositories:**
```bash
helm repo update
```

3. **Search charts:**
```bash
helm search repo nginx
```

---

### Step 4: Create Your First Chart

**Objective:** Create Helm chart for Notes App

**Instructions:**

1. **Create chart:**
```bash
helm create notes-app
```

2. **Explore chart structure:**
```
notes-app/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ...
└── charts/
```

3. **Understand files:**
- `Chart.yaml`: Chart metadata
- `values.yaml`: Default values
- `templates/`: Kubernetes manifests

---

### Step 5: Install and Test Chart

**Objective:** Deploy chart to cluster

**Instructions:**

1. **Install chart:**
```bash
helm install notes-app ./notes-app
```

2. **List releases:**
```bash
helm list
```

3. **Get release status:**
```bash
helm status notes-app
```

4. **Uninstall:**
```bash
helm uninstall notes-app
```

---

## Verification

1. Helm CLI installed
2. Repositories added
3. Chart created
4. Chart deployed successfully

---

## Task Checklist

- [ ] Installed Helm CLI
- [ ] Understood Helm architecture
- [ ] Added repositories
- [ ] Created first chart
- [ ] Installed and tested chart

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

