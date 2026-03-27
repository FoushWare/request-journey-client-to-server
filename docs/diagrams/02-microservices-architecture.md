# ⚙️ Microservices Architecture — Notes App

> This diagram shows the microservices decomposition of the Notes App,  
> how they communicate, and what each service owns.

---

## Service Map

```mermaid
graph TB
    subgraph External["External Clients"]
        WebApp["Web App<br/>(React/Next.js)"]
        MobileApp["Mobile App<br/>(React Native)"]
        AdminDash["Admin Dashboard"]
    end

    subgraph Gateway["API Gateway Layer"]
        NGINX["NGINX<br/>(SSL, Rate Limit, Routing)"]
    end

    subgraph Services["Core Microservices"]
        direction TB
        AuthSvc["Auth Service<br/>🔒 Go<br/>JWT, Sessions, OAuth2"]
        NotesSvc["Notes Service<br/>📝 Go<br/>CRUD, sharing"]
        EmailSvc["Email Service<br/>📧 Python<br/>SMTP via Kafka"]
        SearchSvc["Search Service<br/>🔍 TypeScript<br/>Full-text search"]
        NotifSvc["Notification Service<br/>🔔 Go<br/>WebSocket, push"]
    end

    subgraph Messaging["Event Bus"]
        Kafka["Apache Kafka"]
        Kafka_Topics["Topics:<br/>• user-events<br/>• note-events<br/>• auth-events<br/>• email-events<br/>• search-events"]
    end

    subgraph Databases["Data Layer (Database per Service)"]
        PG[("PostgreSQL<br/>Users, Auth tokens")]
        Mongo[("MongoDB<br/>Notes documents")]
        Redis[("Redis<br/>Sessions, cache")]
        ES[("Elasticsearch<br/>Search index")]
        Neo4j[("Neo4j<br/>User graph")]
    end

    subgraph External_Services["External Services"]
        Mailhog["Mailhog (dev)<br/>AWS SES (prod)"]
        S3["AWS S3<br/>File uploads"]
    end

    %% Client to Gateway
    WebApp --> NGINX
    MobileApp --> NGINX
    AdminDash --> NGINX

    %% Gateway to Services
    NGINX -->|"/auth/*"| AuthSvc
    NGINX -->|"/notes/*"| NotesSvc
    NGINX -->|"/search/*"| SearchSvc
    NGINX -->|WebSocket| NotifSvc

    %% Synchronous inter-service (gRPC)
    NotesSvc -->|"gRPC: ValidateToken"| AuthSvc

    %% Asynchronous events (Kafka)
    AuthSvc -.->|"user.registered"| Kafka
    AuthSvc -.->|"user.login"| Kafka
    NotesSvc -.->|"note.created"| Kafka
    NotesSvc -.->|"note.shared"| Kafka

    Kafka -.->|"email-events"| EmailSvc
    Kafka -.->|"search-events"| SearchSvc
    Kafka -.->|"notif-events"| NotifSvc

    %% Service to Database
    AuthSvc --- PG
    AuthSvc --- Redis
    NotesSvc --- Mongo
    NotesSvc --- Redis
    SearchSvc --- ES
    NotesSvc -.->|graph queries| Neo4j

    %% External
    EmailSvc --> Mailhog
    NotesSvc --> S3

    style External fill:#e1f5fe
    style Gateway fill:#fff3e0
    style Services fill:#e8f5e9
    style Messaging fill:#f3e5f5
    style Databases fill:#e8eaf6
    style External_Services fill:#fce4ec
```

---

## Service Communication Patterns

```mermaid
graph LR
    subgraph Sync["Synchronous (Real-time required)"]
        A["Client"] -->|"REST (HTTP/2)"| B["API Gateway"]
        B -->|"gRPC"| C["Auth Service"]
        B -->|"gRPC"| D["Notes Service"]
    end

    subgraph Async["Asynchronous (Decoupled)"]
        E["Notes Service"] -->|"Kafka event"| F["Kafka Topic"]
        F -->|"consume"| G["Email Service"]
        F -->|"consume"| H["Search Service"]
        F -->|"consume"| I["Notification Service"]
    end

    subgraph WhenToUse["When to Use Each"]
        J["Use SYNC when:
        - Response needed immediately
        - User is waiting
        - Data must be consistent"]
        K["Use ASYNC when:
        - Side effects (email, notifications)
        - Eventual consistency OK
        - Decouple services"]
    end
```

---

## Database per Service Pattern

```mermaid
graph TB
    subgraph anti["❌ Anti-Pattern: Shared Database"]
        S1["Service A"] --> SharedDB[("Shared DB")]
        S2["Service B"] --> SharedDB
        S3["Service C"] --> SharedDB
        Note1["Problems:<br/>- Tight coupling<br/>- Schema conflicts<br/>- Cannot scale independently"]
    end

    subgraph correct["✅ Correct: Database per Service"]
        MS1["Auth Service"] --> DB1[("PostgreSQL")]
        MS2["Notes Service"] --> DB2[("MongoDB")]
        MS3["Search Service"] --> DB3[("Elasticsearch")]
        Note2["Benefits:<br/>- Independent deployments<br/>- Best database for each use case<br/>- Isolated failures"]
    end
```

---

## Auth Service — Internal Flow

```mermaid
sequenceDiagram
    participant Client
    participant AuthSvc as Auth Service
    participant PG as PostgreSQL
    participant Redis

    Client->>AuthSvc: POST /auth/login {email, password}
    AuthSvc->>PG: SELECT user WHERE email=?
    PG-->>AuthSvc: User record (hashed password)
    AuthSvc->>AuthSvc: bcrypt.Compare(password, hash)

    alt Password correct
        AuthSvc->>AuthSvc: jwt.Sign(userId, secret, 15m)
        AuthSvc->>AuthSvc: jwt.Sign(userId, refreshSecret, 7d)
        AuthSvc->>Redis: SET refresh:userId:token "1" (TTL 7d)
        AuthSvc-->>Client: {accessToken, refreshToken}
    else Password wrong
        AuthSvc-->>Client: 401 Unauthorized
    end
```
