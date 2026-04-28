# Phase 18 — Distributed Systems

## Overview

The Notes App now runs across dozens of pods, databases, queues, and cloud services. This phase steps back and studies the **theory and patterns** that underpin all distributed systems: consensus algorithms, consistency models, CAP theorem, and durable execution. Understanding these concepts helps you make better architectural decisions and debug hard distributed systems problems.

## Prerequisites

- **Phase 14 complete** — Microservices and the Saga pattern give concrete examples for theory
- **Phase 17 complete** — Kafka (ZooKeeper) and Kubernetes (etcd) are live examples of distributed consensus
- **Phase 03 complete** — Kubernetes / etcd are the practical ground for Raft theory

## Learning Objectives

- Understand the Raft consensus algorithm and how it achieves distributed leader election and log replication
- Understand how etcd uses Raft to store Kubernetes cluster state
- Understand ZooKeeper's role in Kafka broker coordination and its relationship to the Raft-based KRaft mode
- Understand the CAP theorem: you can have at most two of Consistency, Availability, and Partition tolerance
- Classify Notes App databases by their CAP trade-offs (PostgreSQL = CP, Kafka = AP, Redis = AP by default)
- Understand eventual consistency and how Kafka consumers achieve it for the search index
- Implement durable execution with **Restate.dev** — note creation becomes a reliable, replayable workflow
- Understand the two-generals problem and why exactly-once delivery is hard

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/distributed-systems/task-001-raft-consensus.md`
   > Study the Raft algorithm: leader election, term numbers, log replication, and commitment. Run the Raft simulation at `raft.github.io`. Answer: what happens to the Kubernetes API server when two out of three etcd nodes fail?

2. `tasks/distributed-systems/task-002-etcd-and-kubernetes.md`
   > Connect to the etcd cluster backing your EKS development cluster (local Kind cluster). Use `etcdctl get /registry/deployments/notes-app/backend` to see how Kubernetes stores the backend Deployment as a serialised protobuf. Understand etcd backup and restore.

3. `tasks/distributed-systems/task-003-zookeeper-fundamentals.md`
   > Understand ZooKeeper znodes, watches, and leader election recipes. Connect to the ZooKeeper instance used by Kafka. Observe how Kafka broker IDs and topic partition leaders are stored in ZooKeeper. Compare with KRaft (Kafka's built-in Raft, replacing ZooKeeper in recent versions).

4. `tasks/distributed-systems/task-004-restate-durable-execution.md`
   > Implement the Notes App note-creation workflow using Restate.dev. The workflow: `createNote` → `sendWelcomeEmail` → `indexForSearch` → `auditLog`. Restate guarantees the workflow runs to completion even if any step crashes mid-way, with automatic retry and exactly-once semantics.

5. `tasks/distributed-systems/task-005-cap-theorem.md`
   > Classify each Notes App component by CAP: PostgreSQL (CP — won't return stale data), Elasticsearch (AP — may return slightly stale search results after a partition), Redis Cluster (AP — allows stale reads by default). Justify each classification.

6. `tasks/distributed-systems/task-006-consistency-models.md`
   > Understand the consistency spectrum: linearisability (strongest), sequential consistency, causal consistency, eventual consistency (weakest). Map each Notes App database to its consistency model and explain why that model was chosen.

## CAP Theorem — Notes App Classification

| Component | Type | CAP Choice | Rationale |
|-----------|------|-----------|-----------|
| PostgreSQL (Auth) | SQL | CP | Never return wrong user data |
| MongoDB (Notes) | NoSQL | CP | Notes content must be consistent |
| Redis (Cache) | Cache | AP | Stale cache is acceptable |
| Elasticsearch | Search | AP | Slightly stale search results are OK |
| Kafka | Queue | AP | Messages are eventually delivered |
| etcd | Coord | CP | Cluster state must be consistent |

## Success Criteria

Before moving to Phase 19, verify:

- [ ] You can explain the Raft leader election process in 2 minutes without notes
- [ ] `etcdctl get /registry/deployments/notes-app/backend` returns the backend Deployment data
- [ ] Restate workflow for note creation runs to completion even when you `kill -9` the Notes Service mid-workflow
- [ ] You can classify any system as CP, AP, or CA and explain the trade-off
- [ ] You can explain why Kafka provides at-least-once delivery by default and how idempotent producers achieve exactly-once

---

## ➡️ Next Phase

**[Phase 19 — Serverless (Lambda & Cloud Functions)](./phase-19-serverless.md)**

Phase 19 adds serverless functions for event-driven tasks that do not need always-on servers: email notifications, image resizing, scheduled cleanup, and edge authentication — all without managing any infrastructure.
