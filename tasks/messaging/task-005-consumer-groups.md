# Task: Kafka Consumer Groups

**Related Issue:** #157  
**Category:** Messaging  
**Prerequisites:** task-004-kafka-partitions  
**Estimated Time:** 2–3 hours  
**Language:** Go or Python  
**Notes App Context:** Scale the Notes App's email consumer using consumer groups

---

## Learning Objectives

- Understand how consumer groups enable horizontal scaling
- Observe partition assignment across consumers in a group
- Simulate consumer failure and partition rebalancing
- Understand consumer group lag and how to monitor it

---

## Theory Section

### Consumer Groups

```
Topic: email-events (6 partitions)
Consumer Group: email-service-group

Consumer 1: partitions [0, 1]
Consumer 2: partitions [2, 3]
Consumer 3: partitions [4, 5]
```

Adding a consumer to the group → Kafka rebalances partition assignments.

### Consumer Lag

**Lag** = how far behind a consumer is from the latest message.

```
Partition 0: Latest Offset = 1000
Consumer offset: 950
Lag: 50 messages behind
```

High lag = consumers can't keep up with the producer → need more consumers.

### Sticky Assignor

Default rebalancing can cause unnecessary partition reassignments.  
The **Sticky Assignor** minimizes changes during rebalancing — only the partitions of the failed consumer are redistributed.

---

## Step-by-Step Instructions

### Step 1: Start 3 Consumers in the Same Group

```python
# Start 3 instances of this consumer with the same group.id
consumer = Consumer({
    'bootstrap.servers': 'localhost:9092',
    'group.id': 'email-service-group',
    'auto.offset.reset': 'earliest',
})
consumer.subscribe(['email-events'])
```

### Step 2: Observe Partition Assignment

```bash
# Check which partitions are assigned to each consumer
docker exec kafka kafka-consumer-groups \
  --bootstrap-server localhost:9092 \
  --describe --group email-service-group
```

### Step 3: Simulate Consumer Failure

1. Kill one of the 3 consumers
2. Watch Kafka rebalance the partitions among the remaining 2 consumers
3. Verify no messages are lost or duplicated

### Step 4: Monitor Consumer Lag

```bash
# Monitor lag
docker exec kafka kafka-consumer-groups \
  --bootstrap-server localhost:9092 \
  --describe --group email-service-group | grep LAG
```

Add a Grafana dashboard showing lag over time.

### Step 5: Understand Over-Partitioning

What happens if you add a 7th consumer to a 6-partition topic?
- The 7th consumer gets **no partitions assigned** — it sits idle
- Having more consumers than partitions wastes resources
- This is why choosing partition count carefully matters

---

## Task Checklist

- [ ] Started 3 consumers in the same consumer group
- [ ] Verified partition assignment is spread across consumers
- [ ] Simulated consumer failure and observed rebalancing
- [ ] Monitored consumer lag with CLI
- [ ] Added consumer lag to Grafana dashboard
- [ ] Understood what happens with more consumers than partitions

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed
