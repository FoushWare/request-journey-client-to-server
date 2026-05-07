# Plan: Integrate New GitHub Issues #160–#162

**Date**: 2026-03-29  
**Status**: Completed  
**Related Issues**: #160, #161, #162

---

## Overview

This document details the integration of 3 new GitHub issues (#160–#162) into the DevOps learning path. All three issues extend the **Microservices** track and focus on foundational architectural patterns that real engineering teams apply: decomposition strategies, the monolith-first migration approach, and the sidecar pattern for cross-cutting concerns.

## Learner-First Roadmap Alignment (Restructured)

This integration plan is mapped to the restructured roadmap as follows:

- **Phase 6**: Microservice design and decomposition (#160, #161)
- **Phase 7**: Microservice operational patterns and sidecars (#162)

This placement ensures microservice work happens only after the app is proven in mock/backend/database phases.

---

## Issues Integrated

### Microservices Architecture (3 issues)

- **#160**: Microservices Decomposition — four strategies (business capabilities, DDD sub-domains, entity separation, action separation) with cohesion/coupling evaluation criteria
- **#161**: Monolith First Then Convert to Microservices — build the full Notes App as a monolith first, then migrate incrementally using the Strangler Fig pattern (mirrors what companies like Netflix, Amazon, and Shopify actually did)
- **#162**: Sidecar Pattern — co-located helper containers for cross-cutting concerns (mTLS via Envoy, log collection via Fluent Bit, secret injection via init containers)

---

## Implementation Summary

### Extended Category: Microservices (`tasks/microservices/`)

Three new tasks added:

- **task-010-microservices-decomposition.md**: All four decomposition strategies, DDD bounded contexts, cohesion/coupling metrics, Architecture Decision Record template, Notes App decomposition scorecard
- **task-011-monolith-to-microservices.md**: Modular monolith build (full stack), seam identification, Strangler Fig pattern with Nginx API Gateway, database split strategy, step-by-step migration from monolith to extracted services
- **task-012-sidecar-pattern.md**: Multi-container Pod YAML, Fluent Bit sidecar for log forwarding, Envoy sidecar for mTLS, init containers for secret injection and dependency waiting, Istio auto-injection explanation

---

## New Files Created

### Issue Files (3 new files)
- `issues/issue-160.md` — Microservices Decomposition Strategies
- `issues/issue-161.md` — Monolith First then Convert to Microservices
- `issues/issue-162.md` — Sidecar Pattern for Shared Logic

### Task Files (3 new task files)
- `tasks/microservices/task-010-microservices-decomposition.md`
- `tasks/microservices/task-011-monolith-to-microservices.md`
- `tasks/microservices/task-012-sidecar-pattern.md`

### Implementation Stubs (6 new directories, 6 `.gitkeep` files)
- `implementation/microservices/task-010-decomposition/starter/.gitkeep`
- `implementation/microservices/task-010-decomposition/final-solution/.gitkeep`
- `implementation/microservices/task-011-monolith-to-microservices/starter/.gitkeep`
- `implementation/microservices/task-011-monolith-to-microservices/final-solution/.gitkeep`
- `implementation/microservices/task-012-sidecar-pattern/starter/.gitkeep`
- `implementation/microservices/task-012-sidecar-pattern/final-solution/.gitkeep`

### Updated Files
- `issues/ISSUE_TRACKER.md` — Added rows for #159–#162, updated summary statistics

---

## Task Content Highlights

### task-010: Microservices Decomposition
- Complete comparison of all four decomposition strategies with Notes App examples
- DDD bounded context mapping (Core vs Supporting vs Generic subdomains)
- Cross-schema FK prohibition rule for future database splitting
- Cohesion/coupling scoring table for evaluating proposed decompositions
- ADR (Architecture Decision Record) template for documenting decomposition decisions
- Mermaid diagram: decomposition strategies → resulting services → quality metrics
- Automation reference: eks (deploy services), ecr (image per service), notes-app Ansible role

### task-011: Monolith First → Microservices
- Modular monolith architecture with strict inter-module boundaries from day one
- PostgreSQL schema-per-module design (no cross-schema FK constraints — enables future splitting)
- Full Docker Compose stack: postgres, redis, backend, frontend, nginx API gateway
- Strangler Fig implementation: nginx routing changes to extract services one at a time
- Database split strategy with dual-write → read migration → cutover phases
- Mermaid flowchart: monolith → identify seams → extract → repeat → full microservices
- Automation reference: eks, rds (per-service DB), ecr, notes-app Ansible role

### task-012: Sidecar Pattern
- Multi-container Pod YAML with main app + Fluent Bit sidecar + Envoy sidecar + init containers
- Fluent Bit ConfigMap with tail input, record_modifier filter, Elasticsearch output
- Envoy static configuration for mTLS (mutual TLS with downstream TLS context, require_client_certificate)
- Init container sequence: wait-for-postgres → fetch-secrets (AWS SSM) → main app starts
- Istio auto-injection via `kubectl label namespace ... istio-injection=enabled`
- Pattern comparison table: Sidecar vs Ambassador vs Adapter
- Mermaid diagram: Pod with main container + sidecar containers + external systems
- Automation reference: eks, security_groups (mTLS port 15001), kubernetes Ansible role

---

## Task Dependency Chain

```
task-001 (Microservices intro)
  ↓
task-002 (Database design)
  ↓
task-010 (Decomposition strategies) ← Issue #160
  ↓
task-011 (Monolith first → migrate) ← Issue #161
  ↓
task-012 (Sidecar pattern)          ← Issue #162
  ↓
tasks/service-mesh/ (Istio)
```

---

## Statistics

- **Total New Issues**: 3 (#160–#162)
- **Total New Tasks**: 3
- **New Task Categories**: 0 (all in existing `tasks/microservices/`)
- **Total New Implementation Directories**: 6
- **Updated Files**: 1 (`issues/ISSUE_TRACKER.md`)
- **Total Issues on GitHub (post-sync)**: 162
- **Total Processed Issues**: 130

---

**Document Status**: Complete  
**Last Updated**: 2026-03-29
