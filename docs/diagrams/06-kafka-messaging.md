# 📨 Kafka Messaging Architecture — Events, DLQ, and Consumer Groups

> Apache Kafka is the event backbone of the Notes App.  
> This diagram shows topics, consumers, partitions, and failure handling.

---

## Kafka Architecture Overview

```mermaid
graph TB
    subgraph Producers["📤 Event Producers"]
        Auth["Auth Service"]
        Notes["Notes Service"]
        NotesSvc2["Notes Service (writes)"]
    end

    subgraph Kafka_Cluster["Apache Kafka Cluster"]
        subgraph Topics["Topics (Partitioned)"]
            UT["user-events<br/>Partitions: 3<br/>Retention: 7 days"]
            NT["note-events<br/>Partitions: 6<br/>Retention: 7 days"]
            AT["auth-events<br/>Partitions: 3<br/>Retention: 7 days"]
            ET["email-events<br/>Partitions: 3<br/>Retention: 7 days"]
            RT["retry-email-events<br/>Partitions: 3<br/>Retention: 1 day"]
            DLQ["dlq-email-events (DLQ)<br/>Partitions: 1<br/>Retention: 30 days"]
        end

        subgraph ZK_Section["ZooKeeper / KRaft"]
            ZooK["ZooKeeper<br/>(Leader election for Kafka brokers)"]
        end
    end

    subgraph Consumers["📥 Event Consumers"]
        EmailSvc["Email Service<br/>Group: email-service"]
        SearchSvc["Search Service<br/>Group: search-service"]
        NotifSvc["Notification Service<br/>Group: notification-service"]
        DLQMonitor["DLQ Monitor<br/>Group: dlq-monitor"]
    end

    subgraph External["External"]
        SMTP["SMTP / Mailhog"]
        ES["Elasticsearch"]
    end

    %% Producers → Topics
    Auth -->|"user.registered"| UT
    Auth -->|"password.reset"| AT
    Notes -->|"note.created, note.updated"| NT
    NT -->|routing| ET
    UT -->|routing| ET

    %% Topics → Consumers
    ET --> EmailSvc
    NT --> SearchSvc
    NT --> NotifSvc
    RT --> EmailSvc
    DLQ --> DLQMonitor

    %% Failure path
    EmailSvc -->|"3 retries failed"| RT
    RT -->|"3 more retries failed"| DLQ

    %% External
    EmailSvc --> SMTP
    SearchSvc --> ES

    style Producers fill:#e8f5e9
    style Kafka_Cluster fill:#fff3e0
    style Consumers fill:#e3f2fd
    style External fill:#fce4ec
```

---

## Kafka Partitioning and Consumer Groups

```mermaid
graph TB
    subgraph Topic["note-events Topic (6 partitions)"]
        P0["Partition 0"]
        P1["Partition 1"]
        P2["Partition 2"]
        P3["Partition 3"]
        P4["Partition 4"]
        P5["Partition 5"]
    end

    subgraph CG1["Consumer Group: search-service (3 consumers)"]
        C1["Consumer 1<br/>← P0, P1"]
        C2["Consumer 2<br/>← P2, P3"]
        C3["Consumer 3<br/>← P4, P5"]
    end

    subgraph CG2["Consumer Group: notification-service (2 consumers)"]
        N1["Consumer A<br/>← P0, P1, P2"]
        N2["Consumer B<br/>← P3, P4, P5"]
    end

    P0 --> C1
    P1 --> C1
    P2 --> C2
    P3 --> C2
    P4 --> C3
    P5 --> C3

    P0 --> N1
    P1 --> N1
    P2 --> N1
    P3 --> N2
    P4 --> N2
    P5 --> N2

    Note1["Each consumer group reads independently.
    Adding consumers in a group = more parallelism.
    Max consumers per group = number of partitions."]
```

---

## Message Ordering with Partition Keys

```mermaid
graph LR
    subgraph Producers2["Producers"]
        P_User1["user_id: user_A<br/>events: created, updated, deleted"]
        P_User2["user_id: user_B<br/>events: created, shared"]
    end

    subgraph Partitioner["Kafka Partitioner (hash key % partitions)"]
        Hash["hash('user_A') % 6 = Partition 2
        hash('user_B') % 6 = Partition 4"]
    end

    subgraph OrderedPartitions["Guaranteed Order per User"]
        Part2["Partition 2: user_A events (in order)"]
        Part4["Partition 4: user_B events (in order)"]
    end

    P_User1 --> Hash
    P_User2 --> Hash
    Hash --> Part2
    Hash --> Part4

    Note["Ordering is guaranteed PER PARTITION.
    Use userId as partition key for user-scoped events.
    Never mix different users in order-dependent streams."]
```

---

## Dead Letter Queue (DLQ) Flow

```mermaid
flowchart TD
    Event["email-events: {to, template, data}"]

    Event --> Attempt1["Attempt 1"]
    Attempt1 -->|SMTP timeout| Retry1["Wait 1s → Retry"]
    Retry1 --> Attempt2["Attempt 2"]
    Attempt2 -->|SMTP timeout| Retry2["Wait 2s → Retry"]
    Retry2 --> Attempt3["Attempt 3"]
    Attempt3 -->|SMTP timeout| RetryTopic["→ retry-email-events topic<br/>(delayed by 1 hour)"]

    RetryTopic --> RetryAttempt["Retry from retry topic"]
    RetryAttempt -->|Still failing| DLQTopic["→ dlq-email-events topic<br/>(30 day retention)"]

    DLQTopic --> Monitor["DLQ Monitor Service"]
    Monitor -->|"alert"| Slack["Slack #alerts"]
    Monitor -->|"manual replay"| AdminDash["Admin Dashboard"]
    AdminDash -->|"replay"| Event

    subgraph Success["Happy Path"]
        S1["Attempt"] -->|"SMTP OK"| S2["Mark offset committed"]
        S2 --> S3["Redis SET email:sent:{id} (idempotency)"]
    end
```

---

## Kafka Rebalancing

```mermaid
sequenceDiagram
    participant GroupCoord as Group Coordinator
    participant C1 as Consumer 1 (P0,P1)
    participant C2 as Consumer 2 (P2,P3)
    participant C3 as Consumer 3 (P4,P5)

    Note over C1,C3: Normal state: 3 consumers, 6 partitions

    C3->>GroupCoord: Heartbeat missed (consumer crashed)
    GroupCoord->>C1: STOP_FETCH
    GroupCoord->>C2: STOP_FETCH
    Note over GroupCoord: Rebalance triggered

    GroupCoord->>C1: Assign P0, P1, P2, P4
    GroupCoord->>C2: Assign P3, P5
    C1->>GroupCoord: Assignment ACK
    C2->>GroupCoord: Assignment ACK

    Note over C1,C2: Rebalancing complete<br/>~30 seconds downtime during rebalance
    Note over C1,C2: Use static group membership to reduce rebalancing
```
