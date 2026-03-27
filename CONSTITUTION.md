# 🧭 Project Constitution

## 1. Purpose

This project exists to teach the **full lifecycle of a request** from client to server and back, including all underlying systems, patterns, and tooling — everything from the browser to CDN, cache, load balancers, servers, databases, microservices, and back to the client.

---

## 2. Core Principles

### 2.1 Learning by Building

Every concept MUST include:
- Explanation of what it is and why it matters
- Real-world analogy
- Hands-on implementation (capsule project or integration task)

### 2.2 System Thinking First

We always explain:
- **Why this exists** — what problem it solves
- **Where it sits** in the request journey
- **How it connects** to the bigger picture

### 2.3 Progressive Complexity

Topics are introduced in layers:
1. Basic — concept, theory, local setup
2. Intermediate — integration, configuration, patterns
3. Advanced — production-level, performance, security

### 2.4 Multi-Stack Exposure

We intentionally use multiple technologies:
- **Languages**: Go, Rust, Python, TypeScript/JavaScript
- **Databases**: SQL (PostgreSQL), NoSQL (MongoDB/Redis), Graph (Neo4j)
- **Communication**: REST, gRPC, Message Passing (Kafka, RabbitMQ)
- **Monorepo**: Nx workspace for backend microservices (Node.js/TypeScript services)

### 2.5 Real DevOps Practices

Everything must be:
- Dockerized
- Observable (Prometheus + Grafana)
- Deployable (Kubernetes / AWS)
- Automated (CI/CD pipelines)

### 2.6 Security by Default

Every feature must include:
- Threat consideration
- Secure implementation (no shortcuts)
- Security tested before shipped

---

## 3. Output Requirements

Each module MUST produce:

1. 📘 **Guide.md** — Step-by-step learning guide (task file in `tasks/`)
2. 🧪 **Capsule Project** — Isolated hands-on mini-project in `capsule-projects/`
3. 📊 **Architecture Diagram** — **MANDATORY** Mermaid diagram (see Section 9 — Diagram Standard)
4. 🧩 **Integration Notes** — How it connects to the main Notes App
5. 🤖 **Automation Reference** — Link to the IaC equivalent in `automation/` (Terraform module or Ansible role)

> ⚠️ **Diagrams are not optional.** Every task, feature, capsule project, and subsystem MUST include at least one Mermaid diagram. See Section 9 for the full standard.
>
> ⚠️ **Every task shows the raw/manual steps.** The `automation/` directory provides the equivalent fully-automated IaC version. Tasks MUST reference the relevant automation resource at the bottom.

---

## 4. Source of Truth

| Source | Role |
|---|---|
| **GitHub Issues** | Ideas and new topics |
| **`issues/`** | Structured specs converted from GitHub Issues |
| **`tasks/`** | Execution units — raw/manual step-by-step instructions per topic |
| **`plans/`** | Integration plans for groups of issues |
| **`implementation/`** | Starter code and final solutions |
| **`capsule-projects/`** | Isolated mini-projects per concept |
| **`automation/terraform/`** | Full IaC automation — Terraform modules for every infrastructure concept |
| **`automation/ansible/`** | Full configuration automation — Ansible roles for every operational concept |
| **`docs/diagrams/`** | Mandatory Mermaid architecture diagrams (see Section 9) |
| **`issues/ISSUE_TRACKER.md`** | Tracks which GitHub issues have been processed |

> **Tasks vs Automation**: Tasks in `tasks/` teach concepts by doing them manually. `automation/` contains the production-grade IaC equivalent. Both are required — you learn by doing it manually first, then understand what the automation does.

---

## 5. AI Collaboration Rules

- AI **MUST** check `issues/ISSUE_TRACKER.md` before processing issues to avoid duplication
- AI **MUST** update `issues/ISSUE_TRACKER.md` after processing new issues
- AI **MUST** check if previously processed issues have been updated (`updated_at` changed)
- AI **MUST NOT** skip steps in the Spec Kit Pipeline
- AI **MUST** create all required output files (issue md, task files, implementation stubs)
- AI **MUST** follow the task file format used in `tasks/`
- AI **MUST** create a Mermaid diagram for every task, feature, and subsystem (see Section 9)
- AI **MUST** reference the equivalent `automation/terraform/` module or `automation/ansible/` role at the bottom of every task
- AI **MUST** place all diagrams in `docs/diagrams/` and follow the naming convention `NN-kebab-name.md`

---

## 6. Spec Kit Pipeline

```
GitHub Issues → issues/ (spec files) → tasks/ (execution units) → implementation/ (code)
                                     → plans/ (integration docs)
                                     → capsule-projects/ (mini-projects)
```

---

## 7. The Request Journey Map

The full journey this project covers:

```
Client (Browser/App)
  └─► DNS Resolution
  └─► CDN (Edge Cache)
  └─► Load Balancer (L4/L7)
  └─► API Gateway / Reverse Proxy (NGINX)
  └─► Application Services (Microservices)
        ├─► Auth Service
        ├─► Notes Service
        ├─► Email Service
        └─► ... (more services)
  └─► Messaging (Kafka, RabbitMQ)
  └─► Databases (SQL, NoSQL, Graph, Cache)
  └─► Distributed Systems (Consensus, Leader Election)
  └─► Observability (Logs, Metrics, Traces)
  └─► Cloud (AWS, LocalStack)
  └─► Response back to Client
```

---

## 8. Project Rules

1. All tasks use the **Notes App** as the base application context
2. All implementations must be **reproducible** (no manual steps without documentation)
3. All new features must be **containerized** with Docker
4. All secrets must use **environment variables** or **Vault** — never hardcoded
5. All issues must be processed and tracked in `issues/ISSUE_TRACKER.md`
6. All tasks MUST include a Mermaid diagram (see Section 9)
7. All tasks MUST reference the `automation/` equivalent at the bottom (Terraform module or Ansible role)
8. Node.js/TypeScript microservices MUST live inside the Nx monorepo workspace (see `tasks/microservices/task-009-nx-monorepo-for-microservices.md`)

---

## 9. Diagram Standard (Constitution)

> This section governs how diagrams are created, named, and used across the entire project.  
> It applies to **every contributor and every AI agent**.

### 9.1 Diagrams Are Mandatory

Every one of the following MUST include at least one Mermaid diagram:
- Every task file (`tasks/**/*.md`)
- Every capsule project (`capsule-projects/*/README.md`)
- Every issue spec (`issues/issue-*.md`)
- Every plan document (`plans/*.md`)
- Every implementation stub (`implementation/**/README.md`)
- The overall project big picture (`docs/diagrams/00-big-picture.md`)

### 9.2 Diagram Location

| Where to create the diagram | Which diagram to create |
|-----------------------------|------------------------|
| Inside the task/issue/plan file | Inline diagram showing the concept |
| `docs/diagrams/NN-kebab-name.md` | Standalone full diagram for a subsystem |
| `docs/diagrams/00-big-picture.md` | Updated whenever a new subsystem is added |

### 9.3 Naming Convention

Standalone diagrams in `docs/diagrams/` use zero-padded two-digit numbers:
```
00-big-picture.md         ← always kept up-to-date
01-request-journey.md
02-microservices-architecture.md
...
11-nx-monorepo.md
```

### 9.4 Mermaid Diagram Types

Use the diagram type that best fits the content:

| Content Type | Mermaid Type | Syntax |
|-------------|-------------|--------|
| Architecture / components | Flowchart | `` ```mermaid\ngraph TB `` |
| Request / protocol flows | Sequence | `` ```mermaid\nsequenceDiagram `` |
| Git branching strategy | Git Graph | `` ```mermaid\ngitGraph `` |
| Concept trees / learning maps | Mindmap | `` ```mermaid\nmindmap `` |
| Timelines / latency budgets | Gantt | `` ```mermaid\ngantt `` |

### 9.5 Required Diagrams Per Task

Every task MUST contain **at minimum**:

```markdown
## Architecture Diagram

> Where this fits in the request journey:

\`\`\`mermaid
graph TB
    %% Show where this concept sits in the overall system
    %% Highlight the component being taught in this task
\`\`\`

**Related standalone diagram:** [docs/diagrams/NN-name.md](../../docs/diagrams/NN-name.md)
```

### 9.6 Big Picture Update Rule

Whenever a new subsystem, service, or concept is added to the project, `docs/diagrams/00-big-picture.md` MUST be updated to include it.

### 9.7 Diagram Standard Reference

Full diagram catalog and guidelines: [`docs/diagrams/README.md`](docs/diagrams/README.md)

---

**Version**: 2.0  
**Last Updated**: 2026-03-27
