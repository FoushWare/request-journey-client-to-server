# 🗄️ Database Topology — Storage Architecture

> Each microservice owns its data. No shared databases.  
> This diagram shows what data lives where and why.

---

## Database Ownership Map

```mermaid
graph TB
    subgraph Auth["🔒 Auth Service"]
        AuthDB[("PostgreSQL
        Tables:
        - users (id, email, password_hash)
        - refresh_tokens (family_id, token, user_id)
        - sessions (session_id, user_id, data)")]
        AuthCache[("Redis
        Keys:
        - session:{id} → user data
        - refresh:{userId}:{token} → 1
        - rate_limit:{ip} → count")]
    end

    subgraph Notes["📝 Notes Service"]
        NotesDB[("MongoDB
        Collections:
        - notes (id, userId, title, content, tags, createdAt)
        - tags (id, name, count)
        - note_shares (noteId, sharedWithId, permissions)")]
        NotesCache[("Redis
        Keys:
        - notes:user:{userId} → [notes] (TTL 60s)
        - note:{id} → note object (TTL 300s)
        - tags:popular → [tags] (TTL 3600s)")]
    end

    subgraph Search["🔍 Search Service"]
        SearchDB[("Elasticsearch
        Indices:
        - notes (title, content, tags, userId)
        Mappings:
        - title: text (analyzed)
        - content: text (analyzed)
        - tags: keyword (exact)
        - userId: keyword (filter)")]
    end

    subgraph Graph["🕸️ Graph Features"]
        GraphDB[("Neo4j
        Nodes:
        - User, Note, Tag
        Relationships:
        - User-[:FOLLOWS]->User
        - User-[:CREATED]->Note
        - Note-[:TAGGED_WITH]->Tag
        - User-[:SHARED_WITH]->Note")]
    end

    style Auth fill:#e8eaf6
    style Notes fill:#e8f5e9
    style Search fill:#fff3e0
    style Graph fill:#f3e5f5
```

---

## Data Flow — Creating a Note

```mermaid
sequenceDiagram
    participant Client
    participant NotesSvc as Notes Service
    participant MongoDB
    participant Redis
    participant Kafka
    participant SearchSvc as Search Service
    participant ES as Elasticsearch
    participant Neo4j

    Client->>NotesSvc: POST /notes {title, content, tags}

    NotesSvc->>MongoDB: insertOne({userId, title, content, tags})
    MongoDB-->>NotesSvc: {_id: "note123"}

    NotesSvc->>Redis: DEL "notes:user:{userId}" (invalidate cache)
    NotesSvc->>Kafka: PUBLISH note-events {type: "note.created", noteId, userId, title, content, tags}

    Kafka->>SearchSvc: Consume "note.created"
    SearchSvc->>ES: index {noteId, title, content, tags, userId}

    Kafka->>Neo4j: Consume "note.created" (async)
    Note over Neo4j: MERGE (n:Note {id: "note123"})
    Note over Neo4j: CREATE (u)-[:CREATED]->(n)
    Note over Neo4j: FOREACH tag → MERGE (t:Tag) CREATE (n)-[:TAGGED_WITH]->(t)

    NotesSvc-->>Client: 201 Created {noteId: "note123"}
```

---

## Database Scaling Patterns Applied

```mermaid
graph TB
    subgraph SQL_Scaling["PostgreSQL Scaling (Auth Service)"]
        Master[("PG Master<br/>(writes)")]
        Replica1[("PG Replica 1<br/>(reads)")]
        Replica2[("PG Replica 2<br/>(reads)")]
        Pool["PgBouncer<br/>(connection pool)"]

        Pool -->|writes| Master
        Pool -->|reads| Replica1
        Pool -->|reads| Replica2
        Master -->|async replication| Replica1
        Master -->|async replication| Replica2
    end

    subgraph Mongo_Scaling["MongoDB Scaling (Notes Service)"]
        Primary[("Primary<br/>(reads + writes)")]
        Secondary1[("Secondary 1")]
        Secondary2[("Secondary 2")]

        Primary -->|oplog replication| Secondary1
        Primary -->|oplog replication| Secondary2
        Note["Replica Set: 1 primary + 2 secondaries
        Auto-failover if primary fails"]
    end

    subgraph Redis_HA["Redis High Availability"]
        RSentinel["Redis Sentinel<br/>(monitors masters)"]
        RMaster[("Redis Master")]
        RSlave1[("Redis Slave 1")]
        RSlave2[("Redis Slave 2")]

        RSentinel -->|monitors| RMaster
        RMaster -->|replication| RSlave1
        RMaster -->|replication| RSlave2
        RSentinel -->|promote on failure| RSlave1
    end
```

---

## SQL vs NoSQL Decision Guide

```mermaid
flowchart TD
    Q1{"Is the data relational?
    (foreign keys, joins needed)"}

    Q1 -->|Yes| Q2{"Need ACID transactions?"}
    Q1 -->|No| Q3{"What shape is the data?"}

    Q2 -->|Yes| SQL["✅ Use PostgreSQL"]
    Q2 -->|No| Q4{"Need to scale to billions of rows?"}
    Q4 -->|No| SQL
    Q4 -->|Yes| Wide["✅ Use Cassandra / DynamoDB"]

    Q3 -->|"JSON documents"| Doc["✅ Use MongoDB"]
    Q3 -->|"Key → Value"| KV["✅ Use Redis / DynamoDB"]
    Q3 -->|"Nodes + Edges"| Graph["✅ Use Neo4j"]
    Q3 -->|"Full-text search"| Search["✅ Use Elasticsearch"]
    Q3 -->|"Time series"| TS["✅ Use InfluxDB / TimescaleDB"]
```

---

## CAP Theorem — Our Databases

```mermaid
graph TB
    subgraph CAP["CAP Theorem — Where Our Databases Sit"]
        subgraph CP["CP (Consistency + Partition Tolerance)"]
            PGDB["PostgreSQL (with sync replication)"]
            Etcd["etcd"]
            ZK["ZooKeeper"]
        end

        subgraph AP["AP (Availability + Partition Tolerance)"]
            CouchDB_like["MongoDB (eventual consistency mode)"]
            CassandraDB["Cassandra / DynamoDB"]
        end

        subgraph CA["CA (Consistency + Availability) — No real partition tolerance"]
            MySQL["MySQL (single node)"]
        end
    end

    Note["In distributed systems:
    Network partitions ALWAYS happen.
    You must choose CP or AP.
    CA only works on a single node."]
```
