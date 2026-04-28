# Phase 17 — Kafka & Event Streaming

## Overview

The Saga pattern in Phase 14 published events to Kafka. This phase takes a deep look at **Apache Kafka** itself: how topics and partitions work, how consumer groups enable parallel processing, how to handle message failures with dead-letter queues, and how to guarantee exactly-once delivery. By the end, the Notes App event pipeline is production-grade, observable, and fault-tolerant.

## Prerequisites

- **Phase 14 complete** — Kafka is already used for the Saga choreography between microservices
- **Phase 03 complete** — Kafka runs as a pod in Kubernetes (or Docker Compose)
- **Phase 06 complete** — Kafka consumer lag metrics will feed into Grafana dashboards

## Learning Objectives

- Understand Kafka's architecture: brokers, topics, partitions, offsets, replicas, ZooKeeper / KRaft
- Create topics with the correct partition count and replication factor for the Notes App workload
- Write producers and consumers in Node.js using `kafkajs`
- Understand consumer groups and how partition assignment enables horizontal scaling
- Handle message failures with a Dead-Letter Queue (DLQ) and retry topics
- Implement idempotent producers to prevent duplicate messages
- Monitor Kafka with Prometheus JMX exporter + Grafana (consumer lag, throughput, offset commits)
- Understand Kafka Streams for stateful event processing (conceptual)
- Compare Kafka with alternatives: RabbitMQ, AWS SQS/SNS, Redis Pub/Sub

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/messaging/task-001-kafka-setup.md`
   > Run a single-broker Kafka cluster with ZooKeeper in Docker Compose (or as a Kubernetes StatefulSet). Create the Notes App topics: `notes-events` (3 partitions), `user-events` (2 partitions), `email-queue` (1 partition). Produce and consume a test message with `kafka-console-producer` and `kafka-console-consumer`.

2. `tasks/messaging/task-002-dead-letter-queue.md`
   > Add a `dead-letter-queue` topic. Modify the Email Service consumer to catch exceptions and forward unprocessable messages to the DLQ. Monitor the DLQ topic for alerts when messages accumulate.

3. `tasks/messaging/task-003-retry-patterns.md`
   > Implement exponential backoff retry in the Search Service consumer. Retry a failed indexing operation 3 times before sending to the DLQ. Add a backoff delay topic (`retry-1`, `retry-2`, `retry-3`) for delayed reprocessing.

4. `tasks/messaging/task-004-kafka-partitions.md`
   > Understand partition count, consumer group assignment, and throughput scaling. Increase `notes-events` to 6 partitions and add a second consumer instance. Verify partition rebalancing with `kafka-consumer-groups.sh --describe`.

5. `tasks/messaging/task-005-consumer-groups.md`
   > Run two separate consumer groups on `notes-events`: `email-consumer-group` (Email Service) and `search-consumer-group` (Search Service). Verify both groups receive every message independently (fan-out pattern).

## Notes App Kafka Topics

| Topic | Partitions | Producers | Consumer Groups |
|-------|-----------|-----------|----------------|
| `notes-events` | 3 | Notes Service | email-group, search-group, audit-group |
| `user-events` | 2 | Auth Service | email-group |
| `email-queue` | 1 | Notes Service | email-group |
| `dead-letter-queue` | 1 | Email Service, Search Service | ops-alert-group |

## Kafka Observability

Connect Kafka metrics to the Grafana stack from Phase 06:

- Consumer lag per group and topic (key alert: lag growing means consumers are falling behind)
- Throughput: messages produced/consumed per second
- Offset commit rate
- Broker disk usage

## Success Criteria

Before moving to Phase 18, verify:

- [ ] `kafka-topics.sh --list` shows all four Notes App topics
- [ ] A `notes-events` message produced by the Notes Service is consumed by **both** the Email Service and Search Service independently
- [ ] Sending a malformed message routes it to the DLQ within 3 retries
- [ ] Adding a second Search Service consumer pod causes Kafka to rebalance partitions (verify with `--describe`)
- [ ] Grafana Kafka dashboard shows consumer lag is 0 under normal load
- [ ] DLQ Grafana alert fires when a test bad message accumulates in the DLQ

---

## ➡️ Next Phase

**[Phase 18 — Distributed Systems](./phase-18-distributed-systems.md)**

Phase 18 goes deeper into the theory and practice of distributed systems: the Raft consensus algorithm powering etcd (which powers Kubernetes), ZooKeeper's role in Kafka coordination, durable execution with Restate, and CAP theorem trade-offs.
