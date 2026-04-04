# Issue #161: Monolith First, Then Convert to Microservices

**State:** Open  
**Created:** 2026-03-29T11:43:41Z  
**Updated:** 2026-03-29T11:43:41Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/161

**Labels:** None

---

## Description

Martin Fowler's "Monolith First" pattern is a pragmatic engineering philosophy: **build the full application as a well-structured monolith first, get it to production, then incrementally extract microservices** when the actual pain points are known. This mirrors exactly what successful companies do — Netflix, Amazon, Airbnb, and Shopify all started as monoliths.

Starting with a microservices architecture from day one is an anti-pattern for most teams. Reasons: the domain is not yet understood (you'll draw the wrong boundaries), there is no operational infrastructure yet (no service mesh, no distributed tracing, no CI/CD for 10 services), and the team is small (microservices add communication overhead). A **well-designed monolith** with internal module boundaries, clean interfaces between modules, and a solid test suite is the best starting point.

**Phase 1 — Build the Monolith**  
Implement the entire Notes App as a single deployable unit: React frontend, Express.js backend (with internal modules for auth, notes, search, notifications), PostgreSQL database, Redis cache, and full Docker Compose deployment. Apply all system design best practices (connection pooling, caching, input validation, logging, health checks). Deploy to a cloud VM with proper CI/CD.

**Phase 2 — Identify Seams**  
Analyse the monolith for natural split points: which modules communicate only via clear interfaces? Which have separate data ownership? Which scale independently? Which change at different rates? These seams become your future service boundaries. Use static analysis, coupling metrics, and the decomposition strategies from issue #160.

**Phase 3 — Extract Services (Strangler Fig Pattern)**  
The **Strangler Fig** pattern (Fowler) incrementally replaces monolith functionality with microservices, proxied behind an API Gateway. Route a percentage of traffic to the new service, validate behaviour, then gradually increase to 100% and delete the monolith code. One service at a time, with no big-bang rewrite.

**Phase 4 — Full Microservices**  
After all services are extracted: deploy to Kubernetes (EKS), add a service mesh (Istio), configure distributed tracing, implement the Saga pattern for distributed transactions.

---

## Why This Matters

- Matches how real companies actually transition — you learn from the monolith's pain, not from guessing upfront
- Prevents the "distributed monolith" trap: a microservices rewrite with the same wrong boundaries
- Demonstrates the full lifecycle: build → operate → migrate — the complete DevOps experience
- The Strangler Fig pattern is the industry standard for safe, incremental migration
- Forces learners to deploy a real production-grade app before adding microservices complexity

---

## Key Concepts

### Monolith First
Build and operate a monolith before decomposing it. Understand the domain, the team structure, and the performance bottlenecks before drawing service boundaries.

### Strangler Fig Pattern
Named after the strangler fig tree that gradually surrounds and replaces the host tree. An API Gateway routes requests: new functionality goes to microservices; old functionality stays in the monolith until extracted.

### Seam
A natural boundary within the monolith where the code can be split with minimal coupling. Found by analysing data ownership, change frequency, and communication patterns.

### Modular Monolith
A monolith structured with strict internal module boundaries and explicit interfaces — easier to test, maintain, and eventually decompose than a "big ball of mud" monolith.

### Feature Toggles
Used during migration to enable/disable the new microservice vs the monolith code path. Allows rollback without redeployment.

### Database Decomposition
The hardest part of migration: each extracted service needs its own database. Techniques include the Database View pattern, shared database (temporary), and event-driven sync.

---

## Learning Objectives

- [ ] Build a complete, production-grade monolithic Notes App (frontend + backend + DB + deployment)
- [ ] Apply system design best practices to the monolith (caching, connection pooling, health checks)
- [ ] Identify seams in the monolith using coupling metrics and DDD bounded contexts
- [ ] Implement the Strangler Fig pattern with an API Gateway
- [ ] Extract the first microservice from the monolith (Auth Service)
- [ ] Split the database per extracted service
- [ ] Deploy extracted services to Kubernetes alongside the shrinking monolith
- [ ] Complete the migration: full microservices running on EKS

---

## Tasks to Create

- `tasks/microservices/task-011-monolith-to-microservices.md`

---

## Notes App Integration

The Notes App is the perfect vehicle for this pattern:

1. **Monolith phase**: Single Express.js app with modules `auth/`, `notes/`, `search/`, `notifications/`. PostgreSQL + Redis. React frontend. Docker Compose. Deployed to EC2 or ECS.
2. **Identify seams**: Auth module reads only the `users` table. Notes module reads only the `notes` table. These are clean seams.
3. **Extract Auth Service first**: Proxy auth routes through API Gateway to new Auth Service. Auth Service gets its own Postgres instance. Monolith delegates auth via HTTP calls.
4. **Extract Notes Service**: Notes CRUD moves to Notes Service with its own DB.
5. **Final state**: 5 microservices on EKS, original monolith code deleted.

This end-to-end progression simulates exactly what a developer joining a company with a legacy monolith would experience.
