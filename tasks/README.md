# Tasks Directory

This repository uses a learner-first execution order. Task folders remain category-based, but learners should follow the priority phases below.

## Canonical Priority Order

1. App with mock server
2. App with backend fixed responses
3. App with real database
4. Containerization
5. Microfrontend
6. Microservice
7. Microservice challenges
8. Kubernetes
9. Ansible
10. Other production capabilities

## Directory Structure

```
tasks/
├── app-foundation/   # Phase 1-3 app-first tasks
├── docker/           # Phase 4 containerization
├── microservices/    # Phases 6-7
├── kubernetes/       # Phase 8
├── ansible/          # Phase 9
├── ci-cd/            # Phase 10
├── security/         # Phase 10
├── logging/          # Phase 7/10 depending on scope
├── nginx/            # Phase 10
├── aws/              # Phase 10
├── integration/      # Phase 10
├── networking/       # Phase 10
├── gitops/           # Phase 8/10
├── service-mesh/     # Phase 7/10
├── helm/             # Phase 8
├── hashicorp/        # Phase 10
├── distributed-systems/ # Phase 7/10
├── messaging/        # Phase 7/10
└── system-design/    # Phase 10
```

## How to Execute

1. Start with `tasks/app-foundation/` and finish tasks 001-003.
2. Move to `tasks/docker/`.
3. Continue according to `docs/LEARNING_PATH.md`.
4. Use matching `implementation/<category>/task-xxx/` starter/final-solution folders.

## Task File Convention

Each task should include:

- Objective
- Prerequisites
- Learning outcomes
- Implementation requirements
- Verification criteria
- Next task reference
