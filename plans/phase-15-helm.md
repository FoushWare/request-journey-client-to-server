# Phase 15 — Helm Package Management

## Overview

As the number of Kubernetes manifests grows — 4 microservices × (Deployment + Service + ConfigMap + HPA + NetworkPolicy + Ingress) — managing plain YAML files becomes unmanageable across three environments (dev, staging, prod). **Helm** is the Kubernetes package manager: it templates manifests, versions them as charts, and lets you deploy the entire Notes App stack to any environment with one command.

## Prerequisites

- **Phase 03 complete** — Kubernetes manifests for all services exist as plain YAML files
- **Phase 12 complete** — Argo CD will use the Helm chart as the sync target (Argo CD natively supports Helm)
- **Phase 14 complete** — All four microservices exist and need to be Helm-ified

## Learning Objectives

- Understand the Helm architecture: charts, releases, values, templates, hooks
- Install the Helm CLI and explore the Artifact Hub public chart repository
- Create a Helm chart for the Notes App from scratch (`helm create notes-app`)
- Template Kubernetes manifests with Go template directives (`{{ .Values.image.tag }}`)
- Define environment-specific `values.yaml` files (`values-dev.yaml`, `values-prod.yaml`)
- Deploy the Notes App to multiple environments with `helm upgrade --install`
- Integrate Helm into the CI/CD pipeline to automate environment promotions
- Package and version the chart with `helm package`
- Understand Helm hooks (`pre-install`, `post-upgrade`) for database migrations

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/helm/task-001-install-helm.md`
   > Install the Helm CLI. Explore `helm search hub nginx` to find public charts. Install the official NGINX chart with `helm install` to understand the install/upgrade/rollback lifecycle.

2. `tasks/helm/task-002-create-helm-chart.md`
   > Run `helm create notes-app`. Replace the default templates with the Notes App backend Deployment, Service, Ingress, and HPA. Use `{{ .Values.image.repository }}:{{ .Values.image.tag }}` instead of hardcoded image references.

3. `tasks/helm/task-003-helm-environments.md`
   > Create three values files: `values-dev.yaml` (1 replica, small resource limits, dev domain), `values-staging.yaml` (2 replicas, medium limits), `values-prod.yaml` (3 replicas, large limits, production domain). Deploy to each namespace with `helm upgrade --install notes-app ./charts/notes-app -f values-prod.yaml -n prod`.

4. `tasks/helm/task-004-helm-cicd-integration.md`
   > Update the CI/CD pipeline from Phase 04: after building the Docker image and pushing to ECR, the pipeline runs `helm upgrade --install` with the new image tag. Verify Argo CD syncs correctly when the Helm release is updated via CI.

### Additional Kubernetes Advanced Tasks

After completing the four Helm tasks, apply Helm to the remaining Kubernetes advanced topics:

5. `tasks/kubernetes/task-011-kubernetes-pods-probes-ingress.md`
   > Convert liveness/readiness probe configuration into Helm values so they can be tuned per environment.

6. `tasks/kubernetes/task-012-kubernetes-comprehensive-coverage.md`
   > Complete the comprehensive K8s checklist: PVC for StatefulSets (databases), DaemonSet for Filebeat, RBAC ServiceAccounts — all templated in Helm.

## Helm Chart Structure

```
charts/notes-app/
├── Chart.yaml               ← Chart name, version, appVersion
├── values.yaml              ← Default values (overridden per env)
├── values-dev.yaml
├── values-staging.yaml
├── values-prod.yaml
└── templates/
    ├── deployment.yaml      ← {{ .Values.replicaCount }} replicas
    ├── service.yaml
    ├── ingress.yaml         ← {{ .Values.ingress.host }}
    ├── hpa.yaml
    ├── configmap.yaml
    ├── secret.yaml          ← Values injected from CI secrets
    ├── _helpers.tpl         ← Shared template helpers
    └── NOTES.txt            ← Post-install usage instructions
```

## Success Criteria

Before moving to Phase 16, verify:

- [ ] `helm install notes-app ./charts/notes-app -f values-dev.yaml -n dev` deploys the full stack to the dev namespace
- [ ] `helm upgrade notes-app ./charts/notes-app --set image.tag=abc1234` updates the image without touching other values
- [ ] `helm rollback notes-app 1` reverts to the previous release
- [ ] `helm list -A` shows the Notes App release in all three namespaces (dev, staging, prod) with different image tags
- [ ] Argo CD shows the Helm release as the sync source and reports `Healthy` after CI updates the image tag
- [ ] `helm template notes-app ./charts/notes-app -f values-prod.yaml` renders valid Kubernetes YAML

---

## ➡️ Next Phase

**[Phase 16 — HashiCorp Ecosystem (Vault, Consul, Nomad)](./phase-16-hashicorp.md)**

Phase 16 deepens the HashiCorp toolset beyond Vault (introduced in Phase 03). **Consul** provides service discovery and distributed configuration. **Nomad** is explored as an alternative workload scheduler to Kubernetes.
