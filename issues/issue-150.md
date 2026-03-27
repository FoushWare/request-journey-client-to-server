# Issue #150: Leader Election – Raft Consensus

**State:** Open  
**Created:** 2026-02-15T22:54:19Z  
**Updated:** 2026-02-15T22:54:19Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/150

**Labels:** None

---

## Description

Implement and study **Leader Election** using the **Raft Consensus Algorithm** as a hands-on distributed systems exercise.

**Reference video**: https://www.youtube.com/watch?v=_8Jjx1JEUlQ&t=7139s

---

## Why This Matters

Distributed systems need coordination. When you have multiple nodes, you need to agree on:
- Who is the **leader** (the one making decisions)
- What state is **committed** across all nodes
- How to **recover** when a node dies

Raft is the most readable consensus algorithm and is used in:
- **etcd** (the backbone of Kubernetes)
- **CockroachDB**
- **Consul**
- **TiKV**

---

## Learning Objectives

- [ ] Understand the CAP Theorem (Consistency, Availability, Partition Tolerance)
- [ ] Understand why distributed systems need consensus
- [ ] Learn the Raft algorithm: leader election, log replication, safety
- [ ] Visualize Raft using the Raft visualization tool
- [ ] Build a toy leader election simulation (Go or Python)
- [ ] Understand how etcd uses Raft in Kubernetes
- [ ] Compare Raft vs Paxos (conceptually)

---

## Tasks to Create

- `tasks/distributed-systems/task-001-raft-consensus-leader-election.md`
- `tasks/distributed-systems/task-002-build-raft-simulation.md`

---

## Notes App Integration

The Notes App cluster (multi-instance setup) can simulate leader election:
- One node is the leader that accepts writes
- Followers replicate from the leader
- If the leader dies, a new election occurs
