# Phase 20 — System Design

## Overview

You have built a production-grade Notes App — now you need to **think about it at scale**. This phase applies system design principles to the architecture you have created: drawing architecture diagrams, designing for 10× and 100× traffic, analysing caching strategies, running load tests, and practising the kind of reasoning required in senior engineering roles and system design interviews.

## Prerequisites

- **All previous phases** — the entire Notes App stack must be deployed and operational
- This is a theory + practice phase — it draws on everything built so far

## Learning Objectives

- Draw and explain a complete system architecture diagram for the Notes App
- Identify and address single points of failure in the current architecture
- Design a caching strategy: what to cache, where, for how long, and how to invalidate
- Scale the Notes App to handle 10,000 concurrent users — identify bottlenecks first
- Run a professional load test with `k6` or `Locust` and interpret the results
- Understand and apply back-of-the-envelope estimation (storage, bandwidth, QPS)
- Understand database sharding, read replicas, and connection pooling for PostgreSQL
- Apply the PACELC theorem (extension of CAP) to the Notes App data stores
- Practice a full system design interview answer for "Design a Notes App" (30-minute format)

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/system-design/task-001-architecture-diagram.md`
   > Draw the complete Notes App architecture: MFEs → CloudFront → NGINX → API Gateway → 4 microservices → 5 databases → Kafka → Lambda → Observability stack. Annotate each component with the technology used, SLA target, and data volume. Use the Mermaid format from `CONSTITUTION.md`.

2. `tasks/system-design/task-002-load-testing-k6.md`
   > Write a `k6` load test script that simulates: 100 concurrent users, each logging in, creating 3 notes, and searching. Run the test against the Notes App. Identify which service hits CPU or memory limits first. Fix the bottleneck (add a replica, increase cache TTL, or add a database read replica).

3. `tasks/system-design/task-003-scaling-strategies.md`
   > Design the Notes App for three scale levels:
   > - **1,000 daily users**: current setup is sufficient
   > - **1,000,000 daily users**: add read replicas for PostgreSQL, Redis cluster, Elasticsearch multi-node, Kafka multi-broker, EKS node auto-scaling
   > - **1,000,000,000 daily users**: database sharding, multi-region active-active, eventual consistency everywhere, CDN edge compute

4. `tasks/system-design/task-004-caching-strategy.md`
   > Design and implement a multi-layer caching strategy:
   > - **Layer 1**: Browser cache (static assets — `max-age=31536000`)
   > - **Layer 2**: CloudFront CDN cache (API responses for anonymous content)
   > - **Layer 3**: NGINX proxy cache (API 60-second TTL)
   > - **Layer 4**: Redis application cache (`GET /api/notes` per user, 5-minute TTL)
   > - **Layer 5**: PostgreSQL query cache (prepared statements)
   >
   > Define cache invalidation: when a note is updated, invalidate the Redis cache entry for that user.

## Back-of-the-Envelope Estimates for Notes App

Practice these estimations using the Notes App as the subject:

| Question | Your Estimate |
|----------|--------------|
| Storage for 1M users × 10 notes × 1 KB each | 10 GB |
| Bandwidth for 10K req/s × 5 KB avg response | 50 MB/s = 400 Mbps |
| Redis memory for 1M cached user note lists × 10 KB | 10 GB |
| S3 attachments: 100K uploads/day × 500 KB | 50 GB/day |
| Elasticsearch index: 10M notes × 200 B indexed text | 2 GB |

## System Design Interview Practice

After completing the four tasks, answer this design question in 30 minutes (set a timer):

> **"Design a scalable note-taking application for 10 million users."**

Structure your answer using:
1. Clarify requirements (functional + non-functional)
2. Capacity estimation (storage, bandwidth, QPS)
3. High-level design (client → CDN → LB → services → DBs)
4. Deep dive (database schema, caching, Kafka event flow)
5. Scale (identify bottlenecks and solutions)

## Success Criteria

Before moving to Phase 21 (Final Integration), verify:

- [ ] Architecture diagram includes every component built across all 19 phases
- [ ] `k6` load test identifies the bottleneck at 1,000 concurrent users (e.g., database connection pool exhaustion)
- [ ] After fixing the bottleneck, the Notes App sustains 1,000 concurrent users with P95 latency < 500 ms
- [ ] Caching strategy is documented with TTLs and invalidation rules for each layer
- [ ] You can present a 5-minute verbal architecture walkthrough without reading from notes

---

## ➡️ Final Phase

**[Phase 21 — Integration & Production Readiness](./phase-21-integration-final.md)**

The final phase ties everything together: end-to-end testing, final security audit, documentation completeness, on-call runbook, cost optimisation, and a production readiness checklist. This is your graduation checkpoint.
