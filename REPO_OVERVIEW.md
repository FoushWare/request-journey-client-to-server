# 🗺️ Repository Overview — Fast AI Context

> This file gives an AI assistant quick context about this repository's structure, purpose, and conventions. Read this before making any changes.

---

## Purpose

This is a **DevOps + Distributed Systems learning platform** that teaches the full lifecycle of a web request — from client to CDN, load balancer, microservices, databases, and back. Every concept is backed by hands-on tasks using the **Notes App** as the base project.

---

## Repository Structure

```
/
├── CONSTITUTION.md           ← Project rules and AI collaboration guidelines (READ FIRST)
├── README.md                 ← Project overview and learning roadmap
├── REPO_OVERVIEW.md          ← This file — fast AI context
│
├── issues/                   ← Specs converted from GitHub Issues
│   ├── ISSUE_TRACKER.md      ← Tracks all processed issues (CHECK BEFORE PROCESSING)
│   ├── README.md             ← Issues index by category
│   └── issue-NNN.md          ← One file per issue
│
├── plans/                    ← Integration plans for groups of issues
│   ├── 01-devops-learning-path-plan.md
│   ├── 02-enhanced-plan-terraform-vault-implementation.md
│   ├── 03-implementation-structure-enhancement.md
│   ├── 04-integrate-new-github-issues.md         ← Covered #133–#147
│   └── 05-integrate-new-github-issues-148-158.md ← Covered #148–#158
│
├── tasks/                    ← Step-by-step learning tasks (one per concept)
│   ├── ansible/              ← Issues #91–#100
│   ├── aws/                  ← Issues #101–#110, #145, #146, #147, #148, #149
│   ├── ci-cd/                ← Issues #51–#60
│   ├── distributed-systems/  ← Issues #150, #151, #158 (NEW)
│   ├── docker/               ← Issues #32–#40
│   ├── gitops/               ← Issues #140–#142
│   ├── hashicorp/            ← Issue #144
│   ├── helm/                 ← Issue #139
│   ├── integration/          ← Issues #111–#120
│   ├── kubernetes/           ← Issues #41–#50, #132, #133, #137, #138
│   ├── logging/              ← Issues #71–#80
│   ├── messaging/            ← Issues #156, #157 (NEW)
│   ├── microservices/        ← Issues #134–#136, #152
│   ├── networking/           ← Issues #121–#131
│   ├── nginx/                ← Issues #81–#90
│   ├── security/             ← Issues #61–#70, #155
│   ├── service-mesh/         ← Issue #143
│   ├── system-design/        ← Issues #153, #154 (NEW)
│   ├── terraform/            ← Terraform tasks
│   └── vault/                ← HashiCorp Vault tasks
│
├── implementation/           ← Code: starter code + final solutions per task
│   ├── <category>/
│   │   ├── <task-name>/
│   │   │   ├── starter/      ← Learner starts here
│   │   │   └── final-solution/ ← Reference solution
│   └── starter-notes-app/    ← Base Notes App for all tasks
│
├── capsule-projects/         ← Standalone mini-projects per concept
│   ├── e-commerce-app/
│   ├── blog-platform/
│   ├── todo-project-management/
│   ├── real-time-chat/
│   └── api-gateway/
│
└── docs/                     ← Documentation
    ├── LEARNING_PATH.md
    ├── MENTORSHIP_GUIDE.md
    └── IMPLEMENTATION_STATUS.md
```

---

## Task File Format

Every task file in `tasks/` follows this structure:

```markdown
# Task: [Title]
**Related Issue:** #NNN
**Category:** [category name]
**Prerequisites:** [what must be done first]
**Estimated Time:** [X hours]
**Language:** [Go / Python / TypeScript / etc.]
**Notes App Context:** [how this connects to the Notes App]

## Learning Objectives
## Theory Section
## Step-by-Step Instructions
## Verification
## Task Checklist
## Task Status
```

---

## Issue File Format

Every issue file in `issues/` follows this structure:

```markdown
# Issue #NNN: [Title]
**State:** Open/Closed
**Created:** [date]
**Updated:** [date]
**URL:** [GitHub URL]
**Labels:** [None / list]

## Description
## Why This Matters
## Learning Objectives
## Tasks to Create
## Notes App Integration
```

---

## Notes App

The base project is a simple **Notes App** with:
- User registration and login
- Create, read, update, delete notes
- Multi-service architecture (Auth, Notes, Email services)

All tasks use the Notes App as context — new concepts are applied TO the Notes App.

---

## Learning Path Summary (Restructured)

| Priority Phase | Focus | Main Task Areas |
|---|---|---|
| 1 | App works with mock server (no backend) | App-first foundations |
| 2 | App calls backend with fixed responses (no DB) | App-first foundations |
| 3 | Backend connected to real database | App-first foundations |
| 4 | Containerization | `tasks/docker/` |
| 5 | Microfrontend | Frontend architecture track |
| 6 | Microservice introduction | `tasks/microservices/` (core decomposition/migration tasks) |
| 7 | Microservice challenges | `tasks/microservices/`, `tasks/messaging/`, `tasks/distributed-systems/`, `tasks/service-mesh/`, `tasks/logging/` |
| 8 | Kubernetes platform | `tasks/kubernetes/`, `tasks/helm/`, `tasks/gitops/` |
| 9 | Ansible automation | `tasks/ansible/` |
| 10 | Production-readiness extras | `tasks/security/`, `tasks/aws/`, `tasks/nginx/`, `tasks/ci-cd/`, `tasks/integration/`, `tasks/networking/`, `tasks/hashicorp/`, `tasks/system-design/` |

> Detailed task categories remain in their existing directories; this table defines the new execution priority for learners.

---

## AI Workflow

When asked to process new GitHub issues:

1. **Check** `issues/ISSUE_TRACKER.md` for already-processed issues
2. **Fetch** new issues from GitHub (issues not in the tracker)
3. **Create** `issues/issue-NNN.md` for each new issue
4. **Create** task files in the appropriate `tasks/<category>/` directory
5. **Create** implementation stubs in `implementation/<category>/<task>/`
6. **Update** `issues/ISSUE_TRACKER.md` with new entries
7. **Update** `issues/README.md` with new issue categories
8. **Create** a new plan file: `plans/NN-integrate-new-github-issues-XXX-YYY.md`

**Key rule**: Always check `issues/ISSUE_TRACKER.md` first to avoid duplicating work.

---

## Tech Stack Used

| Area | Technologies |
|------|-------------|
| Languages | Go, Rust, Python, TypeScript/JavaScript |
| Databases | PostgreSQL, MongoDB, Redis, Neo4j, Elasticsearch |
| Messaging | Apache Kafka, RabbitMQ (optional) |
| Orchestration | Kubernetes, Docker Compose |
| GitOps | Argo CD, Flux CD |
| Service Mesh | Istio |
| Cloud | AWS, LocalStack (local), Digital Ocean / Azure (optional) |
| IaC | Terraform, Ansible, Helm |
| Secrets | HashiCorp Vault |
| Monitoring | Prometheus, Grafana |
| Logging | ELK Stack (Elasticsearch, Logstash, Kibana), Filebeat |
| CI/CD | GitHub Actions, Jenkins |
| Distributed Systems | etcd, ZooKeeper, Restate.dev |
| Load Testing | k6, Locust |
