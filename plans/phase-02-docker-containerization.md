# Phase 02 — Docker Containerization

## Overview

With the Micro-Frontend architecture in place (Phase 01), it is now time to package every piece of the Notes App — frontend MFEs, backend API, and databases — into Docker containers. By the end of this phase the entire stack runs with a single `docker-compose up` command on any machine.

Docker is the **foundation of everything that follows**: Kubernetes (Phase 03), CI/CD (Phase 04), and Cloud deployment (Phase 10) all depend on Docker images.

## Prerequisites

- **Phase 01 complete** — Nx monorepo with Shell App + 4 MFEs is working locally
- Docker Desktop (or Docker Engine on Linux) installed
- Basic Linux command-line familiarity
- Understand what the Notes App frontend and backend do

## Learning Objectives

- Understand containerization concepts: images, containers, layers, and the image registry
- Write multi-stage Dockerfiles for Next.js (frontend MFEs) and Node.js (backend) to minimize image size
- Use `.dockerignore` to exclude unnecessary files from the image build context
- Compose all services (frontend, backend, PostgreSQL, MongoDB, Redis) with Docker Compose
- Connect containers with Docker networks so services communicate by service name
- Store database data across container restarts using named volumes
- Configure environment variables securely in containers
- Add Docker health checks so Compose knows when a container is ready
- Collect and inspect container logs with `docker logs` and `docker-compose logs`

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/docker/task-001-create-notes-app-frontend-dockerfile.md`
   > Write a multi-stage Dockerfile for the Shell App / Notes MFE (Next.js). Stage 1: install & build. Stage 2: lightweight production image with only the compiled output.

2. `tasks/docker/task-002-create-notes-app-backend-dockerfile.md`
   > Write a multi-stage Dockerfile for the Node.js/Express backend API. Use a non-root user for security.

3. `tasks/docker/task-003-create-docker-compose-for-notes-app.md`
   > Create `docker-compose.yml` that starts frontend, backend, PostgreSQL, MongoDB, and Redis together. Verify `docker-compose up` brings up the full Notes App.

4. `tasks/docker/task-004-add-nginx-reverse-proxy-container.md`
   > Add an NGINX container to the Compose file. Route `/api/*` to the backend and `/` to the frontend. This is a preview of Phase 07 (NGINX deep-dive).

5. `tasks/docker/task-005-add-environment-variables.md`
   > Use `.env` files and Docker Compose `env_file` / `environment` keys to pass `DATABASE_URL`, `JWT_SECRET`, and other secrets into containers without hardcoding them.

6. `tasks/docker/task-006-add-docker-healthchecks.md`
   > Add `HEALTHCHECK` instructions to Dockerfiles and `healthcheck:` blocks in Compose so Docker knows when each service is truly ready before starting dependents.

7. `tasks/docker/task-007-create-shared-docker-network.md`
   > Define a named Docker bridge network (`notes-app-net`) shared by all containers. Confirm services can reach each other by container name (e.g., `backend` → `postgres`).

8. `tasks/docker/task-008-add-persistent-volumes-for-database.md`
   > Mount named volumes for PostgreSQL and MongoDB data directories. Verify data survives `docker-compose down` and `docker-compose up`.

9. `tasks/docker/task-009-configure-container-logging.md`
   > Configure Docker logging drivers. Use `json-file` with log rotation settings. Forward logs to the ELK Stack (preview of Phase 06 Observability).

## Success Criteria

Before moving to Phase 03, verify:

- [ ] `docker-compose up` starts all services with no errors
- [ ] Notes App is accessible at `http://localhost` — you can register, login, create a note, view notes
- [ ] Containers communicate via service names on the shared Docker network (no `localhost` hardcoding)
- [ ] PostgreSQL and MongoDB data persists after `docker-compose down && docker-compose up`
- [ ] All containers have health checks and become `healthy` (not just `running`)
- [ ] No secrets are hardcoded in Dockerfiles or Compose files — all come from `.env`
- [ ] `docker images` shows multi-stage built images (frontend < 200 MB, backend < 150 MB)
- [ ] `docker-compose logs backend` shows structured JSON logs

## Key Files You Will Create

```
notes-app/
├── frontend/
│   └── Dockerfile              ← Multi-stage Next.js image
├── backend/
│   └── Dockerfile              ← Multi-stage Node.js image
├── .dockerignore               ← Excludes node_modules, .git, .env
├── docker-compose.yml          ← Orchestrates all services
├── .env.example                ← Template for required environment variables
└── nginx/
    └── nginx.conf              ← Reverse proxy config for Compose setup
```

---

## ➡️ Next Phase

**[Phase 03 — Kubernetes Orchestration](./phase-03-kubernetes-orchestration.md)**

With Docker images ready, Phase 03 moves the containers into Kubernetes. You will write Deployment, Service, Ingress, ConfigMap, and Secret manifests to run the Notes App in a production-grade cluster.
