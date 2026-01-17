# Issue #139: Helm kubernetes

**Status**: open  
**Created**: 2025-12-23T12:46:54Z  
**Updated**: 2025-12-23T12:46:54Z  
**Author**: @FoushWare  
**URL**: [https://github.com/FoushWare/request-journey-client-to-server/issues/139](https://github.com/FoushWare/request-journey-client-to-server/issues/139)

## Details

**Labels**:   
**Assignees**:   
**Milestone**: None  

## Description

## Objective
Introduce **Helm** into the project to manage Kubernetes manifests as reusable, versioned, and configurable packages.

This issue ensures the project follows **real-world Kubernetes deployment practices** instead of raw YAML sprawl.

---

## Why Helm?
- Simplifies Kubernetes deployments
- Enables environment-based configuration (dev / staging / prod)
- Provides versioning and rollback for infrastructure
- Matches industry-standard Kubernetes workflows

---

## Phase 1: Helm Fundamentals

- [ ] Understand what Helm is and how it works
- [ ] Learn Helm architecture:
  - Helm CLI
  - Charts
  - Releases
  - Repositories
- [ ] Understand the difference between:
  - Values
  - Templates
  - Manifests

---

## Phase 2: Install & Configure Helm

- [ ] Install Helm CLI locally
- [ ] Verify Helm version compatibility with Kubernetes cluster
- [ ] Add public Helm repositories
- [ ] Explore existing charts (nginx, mysql, prometheus)

---

## Phase 3: Create Project Helm Chart

- [ ] Initialize a Helm chart for the project
- [ ] Define chart structure:
  - Chart.yaml
  - values.yaml
  - templates/
- [ ] Convert existing Kubernetes YAML files into Helm templates
- [ ] Parameterize:
  - Image names & tags
  - Resource requests & limits
  - Environment variables
  - Service types

---

## Phase 4: Environment Configuration

- [ ] Create separate values files:
  - values-dev.yaml
  - values-staging.yaml
  - values-prod.yaml
- [ ] Configure environment-specific:
  - Replicas
  - Resources
  - Ingress domains
  - TLS settings

---

## Phase 5: Helm Releases & Lifecycle

- [ ] Deploy application using `helm install`
- [ ] Upgrade application using `helm upgrade`
- [ ] Rollback to previous release using `helm rollback`
- [ ] Uninstall release safely

---

## Phase 6: Helm + CI/CD Integration

- [ ] Integrate Helm into CI/CD pipeline
- [ ] Automate:
  - Helm lint
  - Helm install / upgrade
- [ ] Use Helm for versioned deployments

---

## Phase 7: Helm Best Practices

- [ ] Use `.helmignore`
- [ ] Apply semantic versioning to charts
- [ ] Separate charts for:
  - Frontend
  - Backend
  - Database
- [ ] Evaluate umbrella charts vs multiple charts

---

## Deliverables
- Helm charts committed to `/helm/`
- All Kubernetes resources deployed via Helm
- Environment-specific configuration documented
- Helm usage documented in README

---

## Acceptance Criteria
- No manual `kubectl apply` for core services
- All deployments managed through Helm
- Successful install, upgrade, and rollback tested

---

## Labels
kubernetes+helm  
devops+deployment  
infrastructure+as-code  
ci-cd+automation  
learning+advanced

