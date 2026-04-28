# Phase 12 — GitOps

## Overview

In previous phases you deployed to Kubernetes with `kubectl apply`. In production, direct cluster access is dangerous — anyone with `kubectl` access can make unreviewed changes. **GitOps** fixes this: the cluster's desired state is stored in Git, and a GitOps operator (**Argo CD** or **Flux CD**) continuously syncs the cluster to match the Git repository. No one touches the cluster directly — all changes go through a Git pull request.

## Prerequisites

- **Phase 03 complete** — Kubernetes manifests are in Git
- **Phase 04 complete** — CI/CD pipeline builds and pushes Docker images to ECR; the pipeline will now update Git (image tags) instead of running `kubectl apply`
- **Phase 10 complete** — EKS cluster is the target environment

## Learning Objectives

- Understand the GitOps principles: Git as the single source of truth, declarative desired state, automated reconciliation
- Install and configure Argo CD on the EKS cluster
- Set up a GitOps repository separate from the application code repository
- Define Argo CD `Application` CRDs that point to the K8s manifests directory
- Update the CI/CD pipeline to commit new image tags to the GitOps repo instead of running `kubectl apply`
- Explore Flux CD as an alternative GitOps operator
- Manage multi-environment deployments (dev / staging / prod) with Argo CD `ApplicationSets`
- Understand GitOps security: signed commits, RBAC on the GitOps repo, Argo CD RBAC policies
- Implement GitOps best practices: health checks, sync waves, automated rollback on health failure

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/gitops/task-001-setup-flux-cd.md`
   > Install Flux CD in the EKS cluster (`flux bootstrap github`). Point it at the GitOps repository. Verify Flux detects and applies the `k8s/` manifests automatically when you push a change to Git.

2. `tasks/gitops/task-002-setup-argo-cd.md`
   > Install Argo CD in the EKS cluster. Create an `Application` CR that tracks `k8s/overlays/prod` in the GitOps repository. Access the Argo CD UI and observe the sync status.

3. `tasks/gitops/task-003-multi-cluster-argocd.md`
   > Register multiple clusters (dev, staging, prod) with Argo CD. Use `ApplicationSet` with a list generator to deploy the Notes App to all environments from a single definition.

4. `tasks/gitops/task-004-gitops-best-practices.md`
   > Practice: update the backend image tag in `values.yaml` via a pull request. Watch Argo CD detect the diff and automatically apply the rolling update. Set up auto-sync with health checks — if the new pod fails its readiness probe, Argo CD rolls back.

## GitOps Deployment Flow

```
Developer pushes code
       │
       ▼
GitHub Actions CI
  lint → test → build → push image to ECR
       │
       ▼ (commit new image tag)
GitOps Repository (values.yaml updated)
       │
       ▼ (watches repo)
Argo CD detects drift
       │
       ▼
kubectl apply (rolling update to EKS)
       │
       ▼
Health check passes → Deployment complete ✅
Health check fails  → Argo CD auto-rollback ↩️
```

## Success Criteria

Before moving to Phase 13, verify:

- [ ] Pushing a code change triggers CI, which commits a new image tag to the GitOps repo
- [ ] Argo CD detects the Git change and automatically deploys the new image within 3 minutes
- [ ] Argo CD UI shows all Notes App applications as `Healthy` and `Synced`
- [ ] You can roll back a bad deployment by reverting the Git commit (no `kubectl` needed)
- [ ] Multi-environment: same Helm chart deploys to `dev` namespace and `prod` namespace with different values
- [ ] Direct `kubectl apply` to the prod namespace is blocked by Argo CD RBAC (it reverts immediately)

---

## ➡️ Next Phase

**[Phase 13 — Service Mesh (Istio)](./phase-13-service-mesh.md)**

With GitOps managing deployments, Phase 13 adds a **Service Mesh** layer. Istio wraps every microservice pod with an Envoy sidecar proxy, providing automatic mTLS encryption between services, traffic management (canary deploys, circuit breakers), and deep observability — all without changing application code.
