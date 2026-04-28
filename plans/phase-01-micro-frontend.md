# Phase 01 — Micro-Frontend Architecture

## Overview

**Start here.** Before any containerization or deployment, you must first structure the Notes App frontend as a collection of independently deployable Micro-Frontends (MFEs). This phase turns the monolithic React/Next.js frontend into a Shell App that composes four Remote MFEs — Auth, Notes, Search, and Profile — using **Webpack 5 Module Federation** inside an **Nx monorepo**.

Every subsequent phase (Docker, Kubernetes, CI/CD, …) will package and deploy these MFEs. Getting this architecture right is the foundation of the entire learning journey.

## Prerequisites

- Basic knowledge of React and JavaScript/TypeScript
- Node.js and npm/yarn installed locally
- Familiarity with the Notes App (frontend: Next.js/React, backend: Node.js/Express)
- No previous phases required — **this is Phase 1**

## Learning Objectives

- Understand what Micro-Frontends are and why they are used
- Configure Webpack 5 Module Federation in a Shell App (host) and Remote MFEs
- Structure an Nx monorepo with multiple frontend apps and shared libraries
- Route between MFEs using the Shell's client-side router
- Share global state (AuthContext, theme) across independently loaded MFEs
- Understand the difference between CSR (client-side rendered) and SSR (server-side rendered) MFEs
- Prepare MFE build outputs for cloud deployment (S3 + CloudFront for CSR, Kubernetes for SSR)

## Task Sequence

Complete the following tasks **in order**. Each task depends on the previous one.

1. `tasks/micro-frontend/task-001-introduction-to-micro-frontends.md`
   > Learn the architecture, decomposition strategy, and when MFEs make sense. Draw the diagram of Shell + 4 remotes.

2. `tasks/micro-frontend/task-002-module-federation-webpack5.md`
   > Configure Webpack 5 `ModuleFederationPlugin` in the Shell App (host). Expose components from Auth, Notes, Search, and Profile remotes. Share singleton dependencies (React, ReactDOM).

3. `tasks/micro-frontend/task-003-single-spa-orchestration.md`
   > Explore single-spa as an alternative orchestration layer. Understand framework-agnostic MFE loading and compare with Module Federation.

4. `tasks/micro-frontend/task-004-nx-monorepo-micro-frontends.md`
   > Set up the Nx workspace. Use Nx generators to scaffold the Shell App and four Remote MFE apps. Create shared libraries (`shared/ui`, `shared/auth`, `shared/types`). Run `nx affected:build` to understand selective rebuilds.

5. `tasks/micro-frontend/task-005-deploy-mfe-kubernetes-cdn.md`
   > Understand the deployment split: CSR MFEs (Auth, Notes, Search) → S3 + CloudFront; SSR MFE (Profile) → Kubernetes. Set cache headers for `remoteEntry.js` (no-cache) vs chunks (1-year cache). This task is **preview only** — actual deployment happens in Phase 10 (AWS) and Phase 03 (Kubernetes).

## MFE ↔ Microservice Mapping

| Micro-Frontend | Port | Backend Calls |
|----------------|------|---------------|
| Shell App | 3000 | None (orchestration only) |
| Auth MFE | 3001 | `POST /api/auth/login`, `POST /api/auth/register` |
| Notes MFE | 3002 | `GET/POST /api/notes/*` |
| Search MFE | 3003 | `GET /api/search/*` |
| Profile MFE | 3004 | `GET /api/auth/me`, `PATCH /api/auth/me` |

## Success Criteria

Before moving to Phase 02, verify:

- [ ] Nx monorepo contains: Shell App + Auth MFE + Notes MFE + Search MFE + Profile MFE
- [ ] Shell App loads remote MFEs dynamically via Module Federation at runtime
- [ ] Shared libraries (`@notes-app/shared-ui`, `@notes-app/shared-auth`) work across all MFEs
- [ ] `AuthContext` created in Shell is accessible from all MFEs without prop-drilling
- [ ] `nx run-many --target=build --all` builds all apps successfully
- [ ] MFEs load correctly at their designated ports in local development
- [ ] You can navigate between `/auth`, `/notes`, `/search`, `/me` and each route loads the correct MFE

## Key Files You Will Create

```
nx-workspace/
├── apps/
│   ├── shell/               ← Host app (port 3000)
│   │   └── webpack.config.js  (Module Federation host config)
│   ├── auth-mfe/            ← Remote MFE (port 3001)
│   ├── notes-mfe/           ← Remote MFE (port 3002)
│   ├── search-mfe/          ← Remote MFE (port 3003)
│   └── profile-mfe/         ← Remote MFE (port 3004)
└── libs/
    ├── shared-ui/           ← Button, Modal, Navbar components
    ├── shared-auth/         ← AuthContext, useAuth hook
    └── shared-types/        ← TypeScript interfaces
```

---

## ➡️ Next Phase

**[Phase 02 — Docker Containerization](./phase-02-docker-containerization.md)**

Once all MFEs are working locally, Phase 02 will package each MFE and the backend into Docker containers so the entire Notes App stack can run with a single `docker-compose up` command.
