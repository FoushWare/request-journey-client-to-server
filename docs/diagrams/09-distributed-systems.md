# 🌐 Distributed Systems — Consensus, Coordination, and Durable Execution

> How the Notes App handles distributed coordination, leader election, and fault-tolerant workflows.  
> Covers: Raft (etcd), ZooKeeper, and Restate.dev.

---

## Distributed Systems Overview

```mermaid
graph TB
    subgraph Problem["The Distributed Systems Problems"]
        P1["Problem 1: Leader Election
        Who is the master node?
        What happens when it crashes?"]
        P2["Problem 2: Distributed Config
        Where is the source of truth for config?"]
        P3["Problem 3: Durable Workflows
        How to resume a workflow after a crash?"]
        P4["Problem 4: Service Coordination
        How do services discover and coordinate?"]
    end

    subgraph Solutions["Solutions in This Project"]
        S1["Raft / etcd
        → K8s control plane
        → Distributed config store"]
        S2["ZooKeeper
        → Kafka broker coordination
        → Leader election recipes"]
        S3["Restate.dev
        → Durable execution
        → Saga pattern workflows"]
        S4["Consul (HashiCorp)
        → Service discovery
        → Health checking"]
    end

    P1 --> S1
    P1 --> S2
    P2 --> S1
    P3 --> S3
    P4 --> S4

    style Problem fill:#ffebee
    style Solutions fill:#e8f5e9
```

---

## Raft Consensus Algorithm

```mermaid
sequenceDiagram
    participant L as Leader (Node 1)
    participant F1 as Follower (Node 2)
    participant F2 as Follower (Node 3)

    Note over L,F2: Normal Operation — Leader sends heartbeats

    L->>F1: AppendEntries (heartbeat, empty)
    L->>F2: AppendEntries (heartbeat, empty)
    F1-->>L: OK
    F2-->>L: OK

    Note over L,F2: Write Request

    L->>L: Write log entry: {term:1, index:5, cmd:"SET x=3"}
    L->>F1: AppendEntries {entry}
    L->>F2: AppendEntries {entry}
    F1-->>L: ACK
    F2-->>L: ACK
    L->>L: Commit (majority ACK)
    L->>F1: Commit notification
    L->>F2: Commit notification

    Note over L,F2: Leader Election (after crash)

    F1->>F1: Election timeout, increment term to 2
    F1->>F2: RequestVote {term:2, candidateId:F1}
    F2-->>F1: VoteGranted
    F1->>F1: Become Leader (got majority)
    F1->>F2: AppendEntries (new heartbeat as leader)
```

---

## ZooKeeper Leader Election Recipe

```mermaid
graph TB
    subgraph ZK_Tree["ZooKeeper ZNode Tree"]
        Root["/"]
        Election["/election"]
        N1["/election/n_0000000001 (Notes Service 1)"]
        N2["/election/n_0000000002 (Notes Service 2)"]
        N3["/election/n_0000000003 (Notes Service 3)"]
        Config["/config"]
        DB_URL["/config/database_url"]
        Kafka_URL["/config/kafka_brokers"]
    end

    Root --> Election
    Root --> Config
    Election --> N1
    Election --> N2
    Election --> N3
    Config --> DB_URL
    Config --> Kafka_URL

    subgraph Algorithm["Election Algorithm"]
        Step1["1. Each node creates ephemeral sequential znode"]
        Step2["2. Get all children of /election"]
        Step3["3. Node with LOWEST sequence = Leader"]
        Step4["4. Non-leaders WATCH the node just before them"]
        Step5["5. Leader crashes → ephemeral znode deleted → watcher fires → next node becomes leader"]
    end

    N1 -->|"smallest sequence → Leader"| Leader["Notes Service 1 is Leader"]
    N2 -->|"watches N1"| Watch["Watches for N1 deletion"]
    N3 -->|"watches N2"| Watch2["Watches for N2 deletion"]
```

---

## Restate.dev — Durable Execution

```mermaid
sequenceDiagram
    participant Client
    participant Restate as Restate Server
    participant NotesSvc as Notes Service
    participant EmailSvc as Email Service
    participant DB as MongoDB

    Client->>Restate: POST /notes/CreateNoteWithNotification
    Restate->>NotesSvc: Step 1: createNote(userId, title, content)

    Note over Restate: Restate persists every step
    Note over Restate: If crash here, resumes from step 1 output

    NotesSvc->>DB: insertOne(note)
    DB-->>NotesSvc: noteId: "abc123"
    NotesSvc-->>Restate: ✅ noteId: "abc123"

    Note over Restate: Step 1 output saved. On crash, skip step 1.

    Restate->>EmailSvc: Step 2: sendWelcomeEmail(userId, noteId)
    EmailSvc-->>Restate: ✅ Email sent

    Note over Restate: Step 2 output saved.

    Restate->>NotesSvc: Step 3: updateNoteStatus(noteId, "published")
    NotesSvc->>DB: updateOne(noteId, {status: "published"})
    NotesSvc-->>Restate: ✅ Updated

    Restate-->>Client: ✅ Workflow complete

    Note over Restate: If ANY step crashes, Restate retries from exact failure point.
    Note over Restate: No duplicate emails. No lost data. Exactly-once semantics.
```

---

## Saga Pattern — Distributed Transactions

```mermaid
graph TB
    subgraph SagaFlow["Notes App — Create + Share Note (Saga)"]
        T1["T1: Create Note in MongoDB"]
        T2["T2: Index note in Elasticsearch"]
        T3["T3: Add node in Neo4j graph"]
        T4["T4: Send share email via Email Service"]

        T1 --> T2
        T2 --> T3
        T3 --> T4
    end

    subgraph Compensations["Compensating Transactions (on failure)"]
        C1["C1: Delete note from MongoDB"]
        C2["C2: Remove from Elasticsearch index"]
        C3["C3: Remove Neo4j node"]

        T4 -->|"Email fails"| C3
        C3 --> C2
        C2 --> C1
    end

    subgraph Orchestrator["Restate Orchestrator"]
        Orch["Restate handles:
        - Step execution order
        - Automatic retries with backoff
        - Compensation on failure
        - No manual state tracking needed"]
    end

    Note["Without Restate: must manually track saga state in DB.
    With Restate: state is managed automatically and durably."]
```
