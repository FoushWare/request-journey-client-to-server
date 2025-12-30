# Task: GitOps - Multi-Cluster and Multi-Environment Argo CD

**Related Issue:** #142  
**Prerequisites:** task-002 (Argo CD setup), multiple Kubernetes clusters or namespaces  
**Estimated Time:** 3-4 hours  
**Notes App Context:** Configure Argo CD to manage Notes App across multiple clusters and environments (dev, staging, prod) with proper load balancing and environment promotion

---

## Learning Objectives

By the end of this task, you will be able to:

- Configure Argo CD for multiple clusters
- Set up multi-environment GitOps workflows
- Implement environment promotion strategies
- Configure load balancing across clusters
- Manage applications across multiple environments
- Understand multi-cluster GitOps best practices

---

## Theory Section

### Multi-Cluster GitOps

**Why Multi-Cluster:**
- **Environment Isolation**: Separate dev, staging, prod clusters
- **Geographic Distribution**: Deploy to multiple regions
- **Disaster Recovery**: Backup clusters in different locations
- **Compliance**: Isolate sensitive workloads

**Multi-Environment Strategies:**
- **Separate Clusters**: One cluster per environment
- **Separate Namespaces**: One namespace per environment in same cluster
- **Git Branches**: Different Git branches per environment
- **Git Paths**: Different paths in same repository

**Argo CD Multi-Cluster:**
- **Cluster Registration**: Register multiple clusters
- **Application per Cluster**: Deploy same app to multiple clusters
- **ApplicationSets**: Manage multiple applications declaratively
- **Cluster Secrets**: Secure cluster access

---

## Prerequisites Check

- [ ] Completed task-002 (Argo CD setup)
- [ ] Access to multiple clusters OR multiple namespaces
- [ ] Git repository organized for environments
- [ ] Understanding of environment promotion

---

## Step-by-Step Instructions

### Step 1: Register Additional Clusters

**Objective:** Add additional Kubernetes clusters to Argo CD

**Instructions:**

1. **Get cluster credentials:**
```bash
# For local cluster
kubectl config get-contexts

# For remote cluster
kubectl config view
```

2. **Register cluster via CLI:**
```bash
argocd cluster add <context-name> --name staging-cluster
```

3. **Or register via UI:**
   - Go to Settings → Clusters
   - Click "Connect Cluster"
   - Enter cluster details

4. **Verify clusters:**
```bash
argocd cluster list
```

---

### Step 2: Organize Git Repository for Multi-Environment

**Objective:** Structure repository for multiple environments

**Instructions:**

1. **Create environment structure:**
```
clusters/
├── dev/
│   └── apps/
│       └── notes-app/
├── staging/
│   └── apps/
│       └── notes-app/
└── prod/
    └── apps/
        └── notes-app/
```

2. **Environment-specific values:**
   - Different replica counts
   - Different resource limits
   - Different ingress domains
   - Different database sizes

---

### Step 3: Create Applications per Environment

**Objective:** Deploy Notes App to each environment

**Instructions:**

1. **Create dev Application:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: notes-app-dev
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/FoushWare/request-journey-client-to-server
    targetRevision: main
    path: clusters/dev/apps/notes-app
  destination:
    server: https://kubernetes.default.svc
    namespace: notes-app-dev
  syncPolicy:
    automated:
      prune: true
```

2. **Create staging and prod similarly**

3. **Apply Applications:**
```bash
kubectl apply -f clusters/dev/argocd-app.yaml
kubectl apply -f clusters/staging/argocd-app.yaml
kubectl apply -f clusters/prod/argocd-app.yaml
```

---

### Step 4: Implement Environment Promotion

**Objective:** Promote changes from dev → staging → prod

**Instructions:**

1. **Promotion Strategy:**
   - Dev: Auto-sync from `main` branch
   - Staging: Manual sync or auto-sync from `staging` branch
   - Prod: Manual sync only from `prod` branch

2. **Git-based Promotion:**
   - Merge dev changes to staging branch
   - Merge staging to prod branch
   - Argo CD syncs automatically

3. **Manual Promotion:**
   - Use Argo CD UI to sync
   - Or use CLI: `argocd app sync notes-app-staging`

---

### Step 5: Configure Load Balancing (Multi-Cluster)

**Objective:** Set up load balancing across clusters

**Instructions:**

1. **For multi-cluster load balancing:**
   - Use external load balancer (ALB, NGINX)
   - Configure DNS to point to multiple clusters
   - Use health checks per cluster

2. **For single-cluster multi-namespace:**
   - Use Ingress with multiple backends
   - Configure service discovery
   - Use NGINX for load balancing

---

## Verification

1. Multiple clusters registered in Argo CD
2. Applications deployed to each environment
3. Environment promotion working
4. Load balancing configured

---

## Task Checklist

- [ ] Registered multiple clusters
- [ ] Organized Git for multi-environment
- [ ] Created Applications per environment
- [ ] Configured environment promotion
- [ ] Set up load balancing
- [ ] Verified multi-cluster deployment

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

