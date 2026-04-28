# Phase 03 — Kubernetes Orchestration

## Overview

You have Docker images (Phase 02). Now you run them in **Kubernetes** — the industry-standard container orchestration platform. This phase converts every `docker-compose` service into Kubernetes manifests: Deployments, Services, Ingress, ConfigMaps, Secrets, HPA, and Network Policies.

By the end of this phase the Notes App runs in a local Kubernetes cluster (Minikube or Kind) exactly as it would on a managed cloud cluster (EKS/GKE/AKS). Phase 10 (AWS) will deploy these same manifests to the cloud.

## Prerequisites

- **Phase 02 complete** — Docker images for all services are built and working
- `kubectl` installed locally
- A local cluster running: Minikube (`minikube start`) or Kind (`kind create cluster`)
- Docker images pushed to a local registry or Docker Hub

## Learning Objectives

- Understand the Kubernetes object model: Pod, ReplicaSet, Deployment, Service, Ingress, ConfigMap, Secret
- Write YAML manifests for each Notes App service
- Expose services inside and outside the cluster using ClusterIP vs LoadBalancer vs Ingress
- Manage application configuration with ConfigMaps and Secrets
- Integrate HashiCorp Vault for dynamic secret injection (Vault Agent Injector)
- Auto-scale pods based on CPU/memory with Horizontal Pod Autoscaler (HPA)
- Set resource requests and limits to prevent noisy-neighbour problems
- Configure liveness, readiness, and startup probes to make rolling updates safe
- Enforce network micro-segmentation with Network Policies
- Perform zero-downtime rolling updates and rollbacks

## Task Sequence

Complete the following tasks **in order**:

### Core Kubernetes (tasks 1–10)

1. `tasks/kubernetes/task-001-create-backend-deployment.md`
   > Write a `Deployment` manifest for the Notes App backend (2 replicas). Apply with `kubectl apply -f`.

2. `tasks/kubernetes/task-002-create-backend-service.md`
   > Expose the backend with a `ClusterIP` Service so other pods can call it by DNS name.

3. `tasks/kubernetes/task-003-create-frontend-ingress.md`
   > Install the NGINX Ingress Controller. Create an `Ingress` resource to route `/api/*` to backend and `/` to the Shell App MFE.

4. `tasks/kubernetes/task-004-create-configmaps.md`
   > Store non-secret configuration (e.g., `NODE_ENV`, `API_BASE_URL`) in ConfigMaps. Mount as environment variables.

5. `tasks/kubernetes/task-005-create-secrets.md`
   > Store sensitive values (`JWT_SECRET`, `DB_PASSWORD`) as Kubernetes Secrets. Later, in the Vault task, you will replace these with Vault-injected secrets.

6. `tasks/kubernetes/task-006-add-horizontal-pod-autoscaler.md`
   > Enable the Metrics Server. Create an HPA for the backend that scales between 2–10 replicas when CPU > 50%.

7. `tasks/kubernetes/task-007-enable-backend-logging.md`
   > Configure pods to emit structured JSON to stdout. Verify logs appear in `kubectl logs`.

8. `tasks/kubernetes/task-008-add-resource-limits.md`
   > Add `resources.requests` and `resources.limits` to every container. Understand what happens when a pod exceeds its memory limit.

9. `tasks/kubernetes/task-009-create-network-policies.md`
   > Apply a default-deny NetworkPolicy. Then add allow rules so only the backend can reach the database pods.

10. `tasks/kubernetes/task-010-setup-rolling-updates.md`
    > Configure `strategy.type: RollingUpdate` with `maxUnavailable: 0`. Deploy a new image version and watch pods roll over one by one.

### Advanced Kubernetes (tasks 11–13)

11. `tasks/kubernetes/task-011-kubernetes-pods-probes-ingress.md`
    > Add liveness, readiness, and startup probes to every Deployment. Simulate a failed readiness probe and observe Kubernetes hold back traffic.

12. `tasks/kubernetes/task-012-kubernetes-comprehensive-coverage.md`
    > Work through the comprehensive Kubernetes checklist: Namespaces, RBAC ServiceAccounts, PersistentVolumeClaims, StatefulSets for databases, DaemonSets for log shippers.

13. `tasks/kubernetes/task-013-deploy-microservices-to-cloud.md`
    > Preview task: walk through what changes when deploying to a managed cluster (EKS). Full execution happens in Phase 10 (AWS).

### HashiCorp Vault Integration (Vault tasks 1–10)

Run these alongside or after the core Kubernetes tasks. Vault replaces plain Kubernetes Secrets with dynamically generated, auto-rotating credentials.

1. `tasks/vault/task-001-install-hashicorp-vault.md`
2. `tasks/vault/task-002-configure-vault-basics.md`
3. `tasks/vault/task-003-store-notes-app-secrets.md`
4. `tasks/vault/task-004-vault-policies-and-auth.md`
5. `tasks/vault/task-005-integrate-vault-with-kubernetes.md`
6. `tasks/vault/task-006-vault-secrets-in-k8s-deployments.md`
7. `tasks/vault/task-007-integrate-vault-with-aws.md`
8. `tasks/vault/task-008-dynamic-secrets-and-rotation.md`
9. `tasks/vault/task-009-vault-high-availability.md`
10. `tasks/vault/task-010-vault-best-practices.md`

## Success Criteria

Before moving to Phase 04, verify:

- [ ] `kubectl get pods -n notes-app` shows all pods `Running` and `Ready`
- [ ] Notes App accessible through the Ingress at `http://notes-app.local`
- [ ] HPA scales the backend pod count when you run a load test (`k6` or `hey`)
- [ ] Rolling update deploys a new image with zero downtime (`maxUnavailable: 0`)
- [ ] Network Policies block direct pod-to-pod access except allowed paths
- [ ] Vault is running; backend pods fetch database credentials from Vault (not plain K8s Secrets)
- [ ] `kubectl rollout undo deployment/backend` successfully reverts a bad deploy

## Key Files You Will Create

```
k8s/
├── namespace.yaml
├── backend/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml
│   └── network-policy.yaml
├── frontend/
│   ├── deployment.yaml       ← Shell App MFE
│   └── service.yaml
├── ingress.yaml
├── configmap.yaml
└── secrets.yaml              ← Later replaced by Vault injection
```

---

## ➡️ Next Phase

**[Phase 04 — CI/CD Pipelines](./phase-04-cicd-pipelines.md)**

With Kubernetes manifests in place, Phase 04 automates everything: every code push triggers tests, builds a new Docker image, and deploys it to the cluster — without manual `kubectl apply`.
