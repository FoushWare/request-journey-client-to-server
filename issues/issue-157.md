# Issue #157: User Partitions in Kafka Topics

**State:** Open  
**Created:** 2026-03-25T08:16:13Z  
**Updated:** 2026-03-25T08:16:13Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/157

**Labels:** None

---

## Description

Study and implement **Kafka partitions** — understand how partitioning enables parallelism and how partition keys affect message ordering and distribution.

---

## Why This Matters

Partitions are the core of Kafka's scalability model:
- A topic with 1 partition = sequential processing (one consumer at a time)
- A topic with N partitions = N consumers can process in parallel
- But: messages within a partition are **always ordered**
- Choosing the right **partition key** is critical for correctness

---

## Key Concepts

### Partitions
- A Kafka topic is divided into N partitions
- Each partition is an ordered, append-only log
- Each partition can be consumed by **one consumer** in a consumer group
- More partitions = more parallelism, but more overhead

### Partition Keys
- When producing a message, you can specify a **partition key**
- All messages with the same key always go to the same partition
- This ensures **ordering per key** (e.g., all events for user123 are ordered)

### Consumer Groups
- Multiple consumers can form a **consumer group**
- Each partition is assigned to exactly one consumer in the group
- If you have 6 partitions and 3 consumers → each consumer handles 2 partitions

### Rebalancing
- When a consumer joins/leaves, Kafka **rebalances** partition assignments
- During rebalance, processing pauses briefly
- Sticky assignors minimize unnecessary rebalancing

---

## Learning Objectives

- [ ] Understand Kafka's partition model
- [ ] Create topics with multiple partitions
- [ ] Implement partition-key-based message routing (user_id as partition key)
- [ ] Set up a consumer group with multiple consumers
- [ ] Observe partition assignment using Kafka tools
- [ ] Test what happens when a consumer in the group dies (rebalancing)
- [ ] Understand the trade-off between partition count and ordering guarantees
- [ ] Benchmark throughput with 1 vs 3 vs 6 partitions

---

## Tasks to Create

- `tasks/messaging/task-004-kafka-partitions.md`
- `tasks/messaging/task-005-consumer-groups.md`

---

## Notes App Integration

The Notes App's `note-events` topic will use `user_id` as the partition key:
- All events for user A go to partition 1
- All events for user B go to partition 2
- This ensures events for a single user are processed in order
- Set up 3 consumers processing the 3-partition topic in parallel
