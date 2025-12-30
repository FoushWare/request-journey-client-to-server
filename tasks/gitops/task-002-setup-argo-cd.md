# Task: GitOps - Setup Argo CD for Kubernetes Deployments

**Related Issue:** #141  
**Prerequisites:** task-001 (Flux CD setup - for comparison), Kubernetes basics, Helm knowledge recommended  
**Estimated Time:** 4-6 hours  
**Notes App Context:** Set up Argo CD as an alternative GitOps tool to manage Notes App Kubernetes deployments, providing a UI-driven GitOps workflow and comparing it with Flux CD

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand Argo CD architecture and components
- Install and configure Argo CD in Kubernetes cluster
- Use Argo CD UI for deployment visualization
- Configure Argo CD Applications for Notes App
- Compare Argo CD vs Flux CD
- Understand when to use each tool

---

## Theory Section

### What is Argo CD?

**Argo CD** is a declarative, GitOps continuous delivery tool for Kubernetes. It provides:
- **Web UI**: Visual interface for managing deployments
- **CLI**: Command-line interface for automation
- **Multi-cluster Support**: Manage multiple clusters
- **Application Management**: Declarative application definitions

**Argo CD vs Flux CD:**

| Feature | Argo CD | Flux CD |
|---------|---------|---------|
| **UI** | Rich Web UI | CLI-focused |
| **Installation** | Manual/Helm | Bootstrap command |
| **Helm Support** | Native | Via Helm Controller |
| **Multi-cluster** | Strong support | Limited |
| **Learning Curve** | Moderate | Steeper |
| **Community** | CNCF project | CNCF project |

**Why This Matters for Notes App:**

- **Visual Management**: See deployment status in UI
- **Easy Onboarding**: UI helps team understand deployments
- **Multi-environment**: Manage dev/staging/prod easily
- **Comparison**: Understand which tool fits your needs

**Argo CD Architecture:**

- **API Server**: REST API and gRPC server
- **Application Controller**: Monitors and syncs applications
- **Repo Server**: Handles Git operations
- **Application CRD**: Defines applications declaratively

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed Kubernetes tasks (task-001 through task-010)
- [ ] Completed task-001 (Flux CD) for comparison
- [ ] Kubernetes cluster accessible
- [ ] `kubectl` configured
- [ ] Git repository with Notes App manifests
- [ ] Basic understanding of Git workflows

**Verify Prerequisites:**
```bash
kubectl cluster-info
git remote -v
kubectl get nodes
```

---

## Step-by-Step Instructions

### Step 1: Install Argo CD

**Objective:** Deploy Argo CD in Kubernetes cluster

**Instructions:**

1. **Create Argo CD namespace:**
```bash
kubectl create namespace argocd
```

2. **Install Argo CD:**
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

3. **Wait for Argo CD to be ready:**
```bash
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=argocd-server \
  -n argocd \
  --timeout=300s
```

4. **Verify installation:**
```bash
kubectl get pods -n argocd
```

**Expected Output:**
- All Argo CD pods running
- argocd-server, argocd-application-controller, argocd-repo-server running

---

### Step 2: Access Argo CD UI

**Objective:** Access Argo CD web interface

**Instructions:**

1. **Get initial admin password:**
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

2. **Port-forward to access UI:**
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

3. **Access UI:**
   - Open browser: https://localhost:8080
   - Username: `admin`
   - Password: (from step 1)
   - Accept self-signed certificate

4. **Change admin password (recommended):**
   - Click on user icon → Account → Update Password
   - Set new secure password

**Expected Output:**
- Argo CD UI accessible
- Logged in as admin
- Dashboard visible

---

### Step 3: Install Argo CD CLI (Optional)

**Objective:** Install CLI for command-line operations

**Instructions:**

1. **Install Argo CD CLI:**
```bash
# macOS
brew install argocd

# Linux
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
```

2. **Login via CLI:**
```bash
argocd login localhost:8080 --insecure
```

3. **Verify CLI:**
```bash
argocd version
argocd cluster list
```

**Expected Output:**
- Argo CD CLI installed
- Logged in successfully
- Can run CLI commands

---

### Step 4: Connect Git Repository

**Objective:** Configure Argo CD to access your Git repository

**Instructions:**

1. **Via UI:**
   - Go to Settings → Repositories
   - Click "Connect Repo"
   - **Type**: Git
   - **Repository URL**: `https://github.com/FoushWare/request-journey-client-to-server`
   - **Name**: `notes-app-repo`
   - Click "Connect"

2. **Via CLI:**
```bash
argocd repo add https://github.com/FoushWare/request-journey-client-to-server \
  --name notes-app-repo \
  --type git
```

3. **For private repositories:**
```bash
argocd repo add https://github.com/FoushWare/request-journey-client-to-server \
  --name notes-app-repo \
  --username your-username \
  --password your-token
```

4. **Verify repository:**
```bash
argocd repo list
```

**Expected Output:**
- Repository connected
- Status shows "Successful"
- Repository appears in list

---

### Step 5: Create Argo CD Application for Notes App

**Objective:** Define Notes App as Argo CD Application

**Instructions:**

1. **Create Application YAML:**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: notes-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/FoushWare/request-journey-client-to-server
    targetRevision: main
    path: clusters/dev/apps/notes-app
  destination:
    server: https://kubernetes.default.svc
    namespace: notes-app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

2. **Apply Application:**
```bash
kubectl apply -f clusters/dev/argocd-application.yaml
```

3. **View in UI:**
   - Go to Argo CD UI
   - Click "Applications"
   - See "notes-app" application

4. **Sync application:**
   - Click on "notes-app"
   - Click "Sync" button
   - Watch resources being created

**Expected Output:**
- Application created in Argo CD
- Notes App deployed
- Status shows "Healthy" and "Synced"

---

### Step 6: Configure Auto-Sync

**Objective:** Enable automatic synchronization

**Instructions:**

1. **Enable auto-sync in UI:**
   - Go to Application → notes-app
   - Click "Enable Auto-Sync"
   - Select sync options:
     - **Prune Resources**: Yes (removes resources not in Git)
     - **Self Heal**: Yes (reverts manual changes)
   - Click "Enable"

2. **Or via YAML:**
```yaml
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
```

3. **Test auto-sync:**
   - Make change in Git
   - Commit and push
   - Watch Argo CD automatically sync

**Expected Output:**
- Auto-sync enabled
- Changes automatically applied
- Manual changes reverted

---

### Step 7: Compare Argo CD vs Flux CD

**Objective:** Understand differences and when to use each

**Comparison:**

**Argo CD Advantages:**
- Rich Web UI for visualization
- Easy to understand for beginners
- Strong multi-cluster support
- Application health status visible
- Built-in RBAC

**Flux CD Advantages:**
- Simpler installation (bootstrap)
- More Git-native approach
- Better for automation/CI integration
- Lighter weight
- Strong Helm support

**When to Use Argo CD:**
- Team needs visual interface
- Multi-cluster management required
- Need application health dashboards
- Prefer UI-driven workflows

**When to Use Flux CD:**
- Prefer CLI/Git-native approach
- Strong automation requirements
- Simpler setup preferred
- CI/CD integration focus

**For Notes App:**
- Both tools work well
- Argo CD better for learning/visualization
- Flux CD better for automation
- Can use both for different purposes

---

## Notes App Specifics

### How This Applies to Notes App

**Argo CD Application:**
- Notes App defined as Argo CD Application
- All components (backend, frontend, database) managed
- Health status visible in UI
- Easy rollback via UI

**Multi-Environment:**
- Separate Applications for dev/staging/prod
- Different Git paths per environment
- Environment promotion via Git

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. Argo CD installed and running
2. UI accessible and functional
3. Git repository connected
4. Notes App Application created
5. Notes App deployed via Argo CD
6. Auto-sync working
7. Self-healing verified

**Technical Verification:**
1. Argo CD pods running: `kubectl get pods -n argocd`
2. Application synced: `argocd app get notes-app`
3. Resources deployed: `kubectl get all -n notes-app`

**Commands to Run:**
```bash
# Check Argo CD status
argocd app list

# Get application details
argocd app get notes-app

# Check sync status
argocd app sync notes-app
```

**Expected Results:**
- Argo CD managing Notes App
- UI shows application status
- Auto-sync working
- Self-healing verified

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Argo CD UI Not Accessible**

**Symptoms:**
- Port-forward fails
- UI doesn't load

**Solutions:**
1. Check Argo CD server pod is running
2. Verify port-forward command
3. Check firewall/network settings
4. Try different port

---

**Issue 2: Repository Connection Fails**

**Symptoms:**
- Repository shows "Failed" status
- Cannot access Git repo

**Solutions:**
1. Verify repository URL is correct
2. Check credentials for private repos
3. Verify network connectivity
4. Check repository permissions

---

**Issue 3: Application Not Syncing**

**Symptoms:**
- Application shows "OutOfSync"
- Resources not deployed

**Solutions:**
1. Check application path in Git
2. Verify YAML syntax
3. Check destination namespace
4. Review application logs

---

## Best Practices

### Security Best Practices
- Change default admin password
- Use RBAC for team access
- Secure Git credentials
- Use separate repositories per environment

### Operational Best Practices
- Use ApplicationSets for multiple apps
- Organize by environment
- Monitor application health
- Document sync policies

---

## Additional Resources

### Documentation
- [Argo CD Documentation](https://argo-cd.readthedocs.io/)
- [Argo CD Best Practices](https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/)

---

## Next Steps

1. **Immediate Next Task**: `task-003-multi-cluster-argocd.md` - Multi-cluster GitOps
2. **Related Tasks**: Helm integration, advanced Argo CD features

---

## Task Checklist

- [ ] Installed Argo CD
- [ ] Accessed Argo CD UI
- [ ] Connected Git repository
- [ ] Created Notes App Application
- [ ] Enabled auto-sync
- [ ] Compared Argo CD vs Flux CD
- [ ] Verified self-healing
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

