# Task: GitOps - Setup Flux CD for Kubernetes Deployments

**Related Issue:** #140  
**Prerequisites:** task-001 through task-010 (Kubernetes basics), Helm knowledge recommended  
**Estimated Time:** 4-6 hours  
**Notes App Context:** Set up Flux CD to manage Notes App Kubernetes deployments using GitOps principles, where GitHub becomes the single source of truth for all cluster state

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand GitOps principles and how they differ from traditional CI/CD
- Install and configure Flux CD in a Kubernetes cluster
- Set up Git repository as the source of truth
- Configure Flux to automatically reconcile cluster state
- Deploy Notes App using Flux CD
- Understand Flux CD architecture and components

---

## Theory Section

### What is GitOps?

**GitOps** is a methodology that uses Git as the single source of truth for declarative infrastructure and applications. Key principles:

- **Declarative**: Everything is described as code (YAML manifests)
- **Version Controlled**: All changes tracked in Git
- **Automated**: Changes in Git automatically applied to cluster
- **Observable**: Easy to see what's deployed and what changed
- **Self-Healing**: Cluster automatically reconciles to match Git state

**Why GitOps Matters for Notes App:**

- **Consistency**: Cluster always matches Git repository
- **Auditability**: All changes tracked in Git history
- **Safety**: No manual `kubectl` changes (they get reverted)
- **Collaboration**: Team reviews changes via pull requests
- **Rollback**: Easy to revert to previous Git commit

**Flux CD Architecture:**

- **Source Controller**: Watches Git repositories
- **Kustomize Controller**: Applies Kustomize overlays
- **Helm Controller**: Manages Helm releases
- **Image Automation**: Updates images automatically
- **Notification Controller**: Sends alerts

**Key Concepts:**

- **GitRepository**: Source that points to a Git repo
- **Kustomization**: Applies Kustomize overlays
- **HelmRelease**: Manages Helm chart releases
- **Reconciliation**: Process of making cluster match Git
- **Drift Detection**: Detecting when cluster differs from Git

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed Kubernetes tasks (task-001 through task-010)
- [ ] Kubernetes cluster accessible (local or remote)
- [ ] `kubectl` configured and working
- [ ] Git repository with Notes App Kubernetes manifests
- [ ] GitHub account with repository access
- [ ] Basic understanding of Git workflows

**Verify Prerequisites:**
```bash
# Check kubectl access
kubectl cluster-info

# Check Git repository
git remote -v

# Verify cluster is ready
kubectl get nodes
```

---

## Step-by-Step Instructions

### Step 1: Understand GitOps Principles

**Objective:** Learn the fundamentals of GitOps

**Key Concepts:**

1. **Git as Source of Truth:**
   - All Kubernetes manifests stored in Git
   - Git history shows all changes
   - No manual cluster modifications

2. **Automatic Reconciliation:**
   - Flux watches Git repository
   - Detects changes in Git
   - Automatically applies to cluster
   - Reverts manual changes

3. **Pull vs Push Model:**
   - **Traditional CI/CD**: Push to cluster (Jenkins, GitHub Actions)
   - **GitOps**: Pull from Git (Flux, Argo CD)
   - GitOps is pull-based, more secure

**Why This Matters:**
- Prevents configuration drift
- Enables easy rollback
- Improves security (no direct cluster access needed)

---

### Step 2: Install Flux CLI

**Objective:** Install Flux CLI tool locally

**Instructions:**

1. **Install Flux CLI (macOS/Linux):**
```bash
# Using Homebrew (macOS)
brew install fluxcd/tap/flux

# Or using install script
curl -s https://fluxcd.io/install.sh | sudo bash
```

2. **Verify installation:**
```bash
flux --version
```

3. **Check Flux prerequisites:**
```bash
flux check --pre
```

**Expected Output:**
- Flux CLI installed
- Version displayed
- Prerequisites check passes

**Troubleshooting:**
- **Issue**: Command not found
  - **Solution**: Add Flux to PATH or use full path
- **Issue**: Prerequisites fail
  - **Solution**: Install kubectl, ensure cluster access

---

### Step 3: Bootstrap Flux CD in Kubernetes Cluster

**Objective:** Install Flux CD components in your cluster

**Instructions:**

1. **Export GitHub credentials (for private repos):**
```bash
export GITHUB_TOKEN=your-github-token
export GITHUB_USER=your-username
```

2. **Bootstrap Flux CD:**
```bash
flux bootstrap github \
  --owner=your-username \
  --repository=request-journey-client-to-server \
  --branch=main \
  --path=clusters/dev \
  --personal
```

**For public repositories (no token needed):**
```bash
flux bootstrap github \
  --owner=FoushWare \
  --repository=request-journey-client-to-server \
  --branch=main \
  --path=clusters/dev \
  --personal
```

3. **Verify Flux installation:**
```bash
kubectl get pods -n flux-system
```

4. **Check Flux components:**
```bash
flux get all
```

**Expected Output:**
- Flux pods running in `flux-system` namespace
- GitRepository source created
- Kustomization created
- Flux components healthy

**Troubleshooting:**
- **Issue**: Bootstrap fails with authentication error
  - **Solution**: Check GitHub token, ensure repo access
- **Issue**: Pods not starting
  - **Solution**: Check cluster resources, node availability

---

### Step 4: Create GitOps Repository Structure

**Objective:** Organize repository for GitOps workflow

**Instructions:**

1. **Create directory structure:**
```bash
mkdir -p clusters/dev
mkdir -p clusters/staging
mkdir -p clusters/prod
mkdir -p apps/notes-app
```

2. **Create base structure:**
```
clusters/
└── dev/
    ├── flux-system/        # Flux configuration (auto-created)
    └── apps/               # Application deployments
        └── notes-app/
            ├── kustomization.yaml
            └── deployment.yaml
```

3. **Create `clusters/dev/apps/notes-app/kustomization.yaml`:**
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml
  - ingress.yaml

namespace: notes-app

commonLabels:
  app: notes-app
  environment: dev
```

4. **Commit structure to Git:**
```bash
git add clusters/
git commit -m "Add GitOps directory structure"
git push
```

**Expected Output:**
- Directory structure created
- Committed to Git repository
- Ready for Flux to manage

---

### Step 5: Configure GitRepository Source

**Objective:** Configure Flux to watch your Git repository

**Instructions:**

1. **Check existing GitRepository (created during bootstrap):**
```bash
flux get sources git
```

2. **View GitRepository details:**
```bash
kubectl get gitrepository -n flux-system -o yaml
```

3. **Verify repository connection:**
```bash
flux reconcile source git flux-system
```

**Expected Output:**
- GitRepository exists
- Status shows "Ready"
- Repository accessible

**Note:** GitRepository is usually created during bootstrap. If not, create manually:
```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/FoushWare/request-journey-client-to-server
  ref:
    branch: main
```

---

### Step 6: Create Kustomization for Notes App

**Objective:** Configure Flux to deploy Notes App from Git

**Instructions:**

1. **Create `clusters/dev/apps/notes-app/kustomization.yaml` (if not exists):**
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base/backend
  - ../../base/frontend
  - ../../base/database

namespace: notes-app

commonLabels:
  app: notes-app
  environment: dev
```

2. **Create Flux Kustomization resource:**
```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: notes-app
  namespace: flux-system
spec:
  interval: 5m
  path: ./clusters/dev/apps/notes-app
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  validation: client
```

3. **Apply Kustomization:**
```bash
kubectl apply -f clusters/dev/flux-kustomization.yaml
```

4. **Verify Kustomization:**
```bash
flux get kustomizations
```

**Expected Output:**
- Kustomization created
- Status shows "Ready"
- Notes App deployed automatically

---

### Step 7: Test GitOps Workflow

**Objective:** Verify Flux automatically applies Git changes

**Instructions:**

1. **Make a change to deployment:**
   - Edit `clusters/dev/apps/notes-app/deployment.yaml`
   - Change replica count or image tag

2. **Commit and push:**
```bash
git add clusters/dev/apps/notes-app/
git commit -m "Update Notes App deployment"
git push
```

3. **Watch Flux reconcile:**
```bash
flux get kustomizations notes-app --watch
```

4. **Verify changes applied:**
```bash
kubectl get deployment notes-app-backend -n notes-app
```

5. **Test self-healing:**
   - Manually delete a pod: `kubectl delete pod <pod-name> -n notes-app`
   - Watch Flux recreate it to match Git state

**Expected Output:**
- Changes in Git automatically applied
- Cluster matches Git state
- Manual changes reverted

---

### Step 8: Monitor Flux Reconciliation

**Objective:** Understand how to monitor and troubleshoot Flux

**Instructions:**

1. **Check Flux status:**
```bash
flux get all
```

2. **View Flux logs:**
```bash
kubectl logs -n flux-system -l app=kustomize-controller --tail=50
```

3. **Check reconciliation events:**
```bash
flux events --kind Kustomization
```

4. **View Kustomization details:**
```bash
kubectl describe kustomization notes-app -n flux-system
```

**Expected Output:**
- Flux status visible
- Logs show reconciliation activity
- Events show sync history

---

## Notes App Specifics

### How This Applies to Notes App

**GitOps Workflow:**
- Notes App manifests stored in Git
- Changes via Git commits only
- Automatic deployment on Git push
- Self-healing if cluster drifts

**Repository Structure:**
```
clusters/
└── dev/
    └── apps/
        └── notes-app/
            ├── backend-deployment.yaml
            ├── frontend-deployment.yaml
            ├── database-statefulset.yaml
            └── kustomization.yaml
```

**Benefits:**
- No manual `kubectl apply` needed
- All changes auditable in Git
- Easy rollback via Git revert
- Team collaboration via PRs

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. Flux CD installed in cluster
2. GitRepository source configured
3. Kustomization created for Notes App
4. Notes App deployed via Flux
5. Changes in Git automatically applied
6. Manual changes reverted by Flux

**Technical Verification:**
1. Flux pods running: `kubectl get pods -n flux-system`
2. GitRepository ready: `flux get sources git`
3. Kustomization ready: `flux get kustomizations`
4. Notes App deployed: `kubectl get pods -n notes-app`

**Commands to Run:**
```bash
# Check Flux status
flux get all

# Verify Notes App
kubectl get all -n notes-app

# Test GitOps: Make change, commit, verify applied
```

**Expected Results:**
- Flux manages Notes App deployments
- Git is source of truth
- Automatic reconciliation works
- Self-healing verified

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Flux Bootstrap Fails**

**Symptoms:**
- Bootstrap command fails
- Authentication errors

**Causes:**
- Invalid GitHub token
- Repository not accessible
- Insufficient permissions

**Solutions:**
1. Verify GitHub token is valid
2. Check repository access
3. Use `--personal` flag for personal repos
4. Check network connectivity

---

**Issue 2: Kustomization Not Syncing**

**Symptoms:**
- Kustomization shows "Not Ready"
- No resources deployed

**Causes:**
- Invalid YAML in Git
- Path incorrect
- Source not accessible

**Solutions:**
1. Check Kustomization path
2. Verify YAML syntax
3. Check GitRepository status
4. Review Flux logs

---

**Issue 3: Manual Changes Not Reverted**

**Symptoms:**
- Manual `kubectl` changes persist
- Flux doesn't revert

**Causes:**
- Reconciliation interval too long
- Prune not enabled
- Kustomization paused

**Solutions:**
1. Enable `prune: true` in Kustomization
2. Reduce reconciliation interval
3. Manually trigger: `flux reconcile kustomization notes-app`

---

## Best Practices

### Security Best Practices
- Use read-only Git credentials when possible
- Restrict cluster access (no manual kubectl)
- Use separate branches for environments
- Review all changes via pull requests

### Operational Best Practices
- Use separate Kustomizations per application
- Organize by environment (dev/staging/prod)
- Use Kustomize overlays for environment differences
- Monitor Flux reconciliation status

### GitOps Best Practices
- Commit all manifests to Git
- Never make manual cluster changes
- Use Git branches for promotion
- Document GitOps workflow

---

## Additional Resources

### Documentation
- [Flux CD Documentation](https://fluxcd.io/docs/)
- [GitOps Principles](https://www.weave.works/technologies/gitops/)
- [Kustomize Documentation](https://kustomize.io/)

### Learning Resources
- [Flux CD Getting Started](https://fluxcd.io/docs/get-started/)
- [GitOps Best Practices](https://www.weave.works/blog/gitops-best-practices)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-002-setup-argo-cd.md` - Set up Argo CD for comparison
2. **Related Tasks**: 
   - `task-003-multi-cluster-argocd.md` - Multi-cluster GitOps
   - Helm tasks for Helm + Flux integration
3. **Future Learning**: 
   - Advanced Flux features (Image Automation)
   - Multi-cluster GitOps
   - Flux + Helm integration

---

## Reflection Questions

1. How does GitOps differ from traditional CI/CD?
2. Why is Git as source of truth beneficial?
3. How does Flux ensure cluster matches Git?
4. What are the security benefits of GitOps?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Installed Flux CLI
- [ ] Bootstrapped Flux CD in cluster
- [ ] Created GitOps repository structure
- [ ] Configured GitRepository source
- [ ] Created Kustomization for Notes App
- [ ] Tested GitOps workflow
- [ ] Verified automatic reconciliation
- [ ] Tested self-healing
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours/Days]  
**Mentor Notes:** [Space for mentor feedback]

