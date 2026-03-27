# Task: Dead Letter Queue (DLQ) with Kafka

**Related Issue:** #156  
**Category:** Messaging  
**Prerequisites:** task-001-kafka-setup  
**Estimated Time:** 4 hours  
**Language:** Go or Python  
**Notes App Context:** Handle unprocessable email events from the Notes App

---

## Learning Objectives

- Understand the Poison Pill problem in Kafka
- Implement a Dead Letter Queue strategy
- Build retry logic with exponential backoff
- Monitor the DLQ with Prometheus/Grafana
- Implement a DLQ replay mechanism

---

## Theory Section

### The Poison Pill Problem

Imagine a consumer that crashes on a specific message:

```
Topic: email-events
Messages: [msg1, msg2, POISON_MSG, msg4, msg5]
```

Kafka guarantees in-order delivery within a partition. If `POISON_MSG` always causes a crash, the consumer is stuck forever — it can't skip it and process `msg4`.

### Dead Letter Queue Pattern

**Strategy:**
1. Try to process the message
2. If it fails, retry N times with backoff
3. After N retries, publish the failed message to a `-dlq` topic
4. Continue processing the next message
5. Operators inspect and fix DLQ messages, then replay them

### Retry Topics Pattern (Confluent approach)

Instead of a single DLQ, use a chain of retry topics:
```
email-events → email-events-retry-1 → email-events-retry-2 → email-events-dlq
```

Each retry topic has an increasing delay, implementing exponential backoff.

---

## Step-by-Step Instructions

### Step 1: Create Topics

```bash
# Create main topic, retry topics, and DLQ
docker exec kafka kafka-topics --create \
  --topic email-events --partitions 3 --bootstrap-server localhost:9092

docker exec kafka kafka-topics --create \
  --topic email-events-retry-1 --partitions 3 --bootstrap-server localhost:9092

docker exec kafka kafka-topics --create \
  --topic email-events-dlq --partitions 1 --bootstrap-server localhost:9092
```

### Step 2: Implement Consumer with Retry Logic

```python
# Example: Python consumer with DLQ

def process_message(msg):
    retry_count = int(msg.headers.get('retry-count', 0))
    
    try:
        send_email(msg.value)
    except Exception as e:
        if retry_count >= MAX_RETRIES:
            # Send to DLQ
            dlq_producer.produce('email-events-dlq', msg.value,
                headers={**msg.headers, 'error': str(e), 'original-topic': msg.topic()})
        else:
            # Send to retry topic with incremented count
            retry_producer.produce(f'email-events-retry-{retry_count + 1}', msg.value,
                headers={**msg.headers, 'retry-count': str(retry_count + 1)})
```

### Step 3: Simulate the Poison Pill

1. Produce a malformed message to `email-events`
2. Observe the consumer retry N times
3. Verify the message lands in `email-events-dlq`
4. Verify processing continues with the next messages

### Step 4: Build the DLQ Monitor

1. Create a consumer that reads from `email-events-dlq`
2. Alert when messages arrive (log, Slack, or Prometheus counter)
3. Display DLQ size on Grafana dashboard

### Step 5: Build the Replay Mechanism

```bash
# Replay DLQ messages back to the main topic after fixing the issue
docker exec kafka kafka-console-consumer \
  --topic email-events-dlq --from-beginning | \
docker exec -i kafka kafka-console-producer \
  --topic email-events
```

---

## Verification

1. Poison pill message triggers DLQ after max retries
2. Normal messages after the poison pill are still processed
3. DLQ monitor alerts on new messages
4. Replay mechanism works correctly

---

## Task Checklist

- [ ] Main topic, retry topics, and DLQ topic created
- [ ] Consumer with retry logic implemented
- [ ] Poison pill simulation tested
- [ ] Messages land in DLQ after max retries
- [ ] Processing continues after DLQ routing
- [ ] DLQ monitor implemented
- [ ] Replay mechanism tested

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed
