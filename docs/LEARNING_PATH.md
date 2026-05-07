# Notes App Learner-First Learning Path

## Purpose

This repository now follows a strict app-first progression so learners see a working product early, then gradually evolve it into production-grade architecture.

## Canonical 10-Phase Order

1. **App without backend (mock server)**
2. **Frontend to backend with fixed responses (no DB)**
3. **Backend with real database**
4. **Containerization**
5. **Microfrontend**
6. **Microservice architecture**
7. **Microservice challenges**
8. **Kubernetes platform**
9. **Ansible automation**
10. **Other production capabilities**

> Each phase can contain multiple plans, tracks, and task groups.

---

## Phase-to-Repository Mapping

### Phase 1-3: App Foundation

- `tasks/app-foundation/task-001-run-notes-app-with-mock-server.md`
- `tasks/app-foundation/task-002-connect-frontend-to-fixed-backend.md`
- `tasks/app-foundation/task-003-connect-backend-to-real-database.md`
- `implementation/app-foundation/`

### Phase 4: Containerization

- `tasks/docker/`
- `implementation/docker/`

### Phase 5: Microfrontend

- Microfrontend-focused tasks and plans (existing and upcoming)

### Phase 6: Microservice Architecture

- `tasks/microservices/` (core decomposition/migration tasks)
- `implementation/microservices/`

### Phase 7: Microservice Challenges

- `tasks/microservices/` (advanced patterns)
- `tasks/messaging/`
- `tasks/distributed-systems/`
- `tasks/service-mesh/`
- `tasks/logging/`

### Phase 8: Kubernetes Platform

- `tasks/kubernetes/`
- `tasks/helm/`
- `tasks/gitops/`

### Phase 9: Ansible Automation

- `tasks/ansible/`

### Phase 10: Other Production Capabilities

- `tasks/security/`
- `tasks/ci-cd/`
- `tasks/nginx/`
- `tasks/aws/`
- `tasks/networking/`
- `tasks/integration/`
- `tasks/hashicorp/`
- `tasks/system-design/`
- `capsule-projects/`

---

## Sequencing Rules

- Do not skip phases 1-3.
- Keep API contracts stable while moving from mock → fixed backend → real DB.
- Introduce infrastructure only after users can run real app flows.
- Treat advanced tracks as phase 10 unless they are explicitly needed by earlier phases.
