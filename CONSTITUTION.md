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

1. 📘 **Guide.md** — Step-by-step learning guide
2. 🧪 **Capsule Project** — Isolated hands-on mini-project
3. 📊 **Architecture Diagram** (optional but encouraged)
4. 🧩 **Integration Notes** — How it connects to the main Notes App

---

## 4. Source of Truth

| Source | Role |
|---|---|
| **GitHub Issues** | Ideas and new topics |
| **`issues/`** | Structured specs converted from GitHub Issues |
| **`tasks/`** | Execution units (step-by-step tasks per topic) |
| **`plans/`** | Integration plans for groups of issues |
| **`implementation/`** | Starter code and final solutions |
| **`capsule-projects/`** | Isolated mini-projects per concept |
| **`issues/ISSUE_TRACKER.md`** | Tracks which GitHub issues have been processed |

---

## 5. AI Collaboration Rules

- AI **MUST** check `issues/ISSUE_TRACKER.md` before processing issues to avoid duplication
- AI **MUST** update `issues/ISSUE_TRACKER.md` after processing new issues
- AI **MUST** check if previously processed issues have been updated (`updated_at` changed)
- AI **MUST NOT** skip steps in the Spec Kit Pipeline
- AI **MUST** create all required output files (issue md, task files, implementation stubs)
- AI **MUST** follow the task file format used in `tasks/`

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

---

**Version**: 1.0  
**Last Updated**: 2026-03-27
