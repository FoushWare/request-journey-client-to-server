# Issue #140: Flux CD Kubernetes deployments

**State:** Open  
**Created:** 2025-12-23T12:48:46Z  
**Updated:** 2025-12-23T12:48:46Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/140

**Labels:** None

---

## Objective
Introduce **Flux CD** to implement a **GitOps workflow** where GitHub becomes the single source of truth for Kubernetes deployments.

This ensures all cluster state changes are **declarative, auditable, and automated**.

---

## Why Flux CD?
- Enforces Git as the source of truth
- Automates Kubernetes reconciliation
- Works natively with Helm
- Provides safe, observable deployments
- Industry-standard GitOps tool

---

## Phase 1: GitOps Fundamentals

- [ ] Understand GitOps principles
- [ ] Understand how Flux CD works
- [ ] Compare GitOps vs traditional CI/CD
- [ ] Identify what parts of this project will be managed by Flux

---

## Phase 2: Install Flux CD

- [ ] Install Flux CLI locally
- [ ] Bootstrap Flux CD on Kubernetes cluster
- [ ] Connect Flux to GitHub repository
- [ ] Verify Flux system components are running

---

## Phase 3: Repository Structure for GitOps

- [ ] Create GitOps directory structure:
  - `/clusters/dev`
  - `/clusters/staging`
  - `/clusters/prod`
- [ ] Separate application manifests from infrastructure manifests
- [ ] Define ownership and folder boundaries

---

## Phase 4: Flux Sources & Reconciliation

- [ ] Configure GitRepository source
- [ ] Define reconciliation intervals
- [ ] Observe automatic sync behavior
- [ ] Validate self-healing when drift occurs

---

## Phase 5: Helm + Flux Integration

- [ ] Configure HelmRepository source
- [ ] Define HelmRelease objects
- [ ] Deploy application using HelmRelease
- [ ] Manage versioned releases via Git commits

---

## Phase 6: Multi-Environment GitOps

- [ ] Manage dev, staging, and prod via Git
- [ ] Promote releases using Git history
- [ ] Use different Helm values per environment
- [ ] Prevent direct cluster changes

---

## Phase 7: Security & Access Control

- [ ] Restrict cluster access (no manual kubectl)
- [ ] Use read-only cluster credentials
- [ ] Secure GitHub tokens/secrets
- [ ] Audit changes via Git history

---

## Phase 8: Observability & Troubleshooting

- [ ] Monitor Flux reconciliation status
- [ ] Inspect Flux logs
- [ ] Handle failed syncs safely
- [ ] Document rollback strategy

---

## Deliverables
- Flux CD fully managing Kubernetes state
- Helm deployments controlled via Git
- GitOps directory structure committed
- Documentation explaining GitOps workflow

---

## Acceptance Criteria
- Cluster state always matches Git repository
- Manual kubectl changes are reverted
- Deployments occur via Git commits only
- Successful Helm-based releases via Flux

---

## Labels
gitops+fluxcd  
kubernetes+automation  
devops+deployment  
ci-cd+advanced  
infrastructure+as-code


Docker
  → Kubernetes
    → Helm
      → Flux CD (GitOps)
        → AWS EKS
          → Observability + Security


