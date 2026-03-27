# 🏗️ Nx Monorepo — Notes App Workspace

> This diagram shows the Nx workspace layout for all Notes App backend microservices,  
> how services share code through libraries, and how the workspace integrates with CI/CD.

---

## Workspace Layout

```mermaid
graph TB
    subgraph Workspace["📦 notes-app-workspace/ (Nx Monorepo)"]
        direction TB

        subgraph Apps["apps/ — Deployable Microservices"]
            Auth["auth-service\n🔒 Port 3333\nExpress + TypeScript\ntags: type:app, scope:auth"]
            Notes["notes-service\n📝 Port 3334\nExpress + TypeScript\ntags: type:app, scope:notes"]
            Email["email-service\n📧 Port 3335\nKafka consumer\ntags: type:app, scope:email"]
            Search["search-service\n🔍 Port 3336\nElasticsearch client\ntags: type:app, scope:search"]
            Notif["notification-service\n🔔 Port 3337\nWebSocket server\ntags: type:app, scope:notif"]
        end

        subgraph Libs["libs/shared/ — Shared Libraries (never deployed alone)"]
            Types["shared/types\n📐 DTOs, interfaces, enums\nKafka event shapes\ntags: type:lib, scope:shared"]
            AuthLib["shared/auth\n🔑 JWT utils\nguards, decorators\ntags: type:lib, scope:shared"]
            Kafka["shared/kafka\n📨 Producer/consumer\nwrappers, retry logic\ntags: type:lib, scope:shared"]
            Config["shared/config\n⚙️ Env validation\nzod schemas\ntags: type:lib, scope:shared"]
        end

        subgraph BuildSystem["🔧 Nx Build System"]
            Cache["Build Cache\n(local + Nx Cloud)"]
            Graph["Project Graph\n(dep analysis)"]
            Affected["nx affected\n(CI optimization)"]
        end
    end

    %% Library dependencies
    Auth --> Types
    Auth --> AuthLib
    Auth --> Config
    Notes --> Types
    Notes --> Kafka
    Notes --> Config
    Email --> Kafka
    Email --> Types
    Email --> Config
    Search --> Types
    Search --> Config
    Notif --> Kafka
    Notif --> Types
    Notif --> Config

    %% Build system relationships
    Affected --> Graph
    Graph --> Cache

    style Auth fill:#e3f2fd,stroke:#1976d2
    style Notes fill:#e8f5e9,stroke:#388e3c
    style Email fill:#fff8e1,stroke:#f57c00
    style Search fill:#f3e5f5,stroke:#7b1fa2
    style Notif fill:#fce4ec,stroke:#c62828
    style Types fill:#fff9c4,stroke:#f9a825
    style AuthLib fill:#fff9c4,stroke:#f9a825
    style Kafka fill:#fff9c4,stroke:#f9a825
    style Config fill:#fff9c4,stroke:#f9a825
```

---

## Nx Project Graph (Dependency View)

```mermaid
graph LR
    subgraph Apps["Apps (deployable)"]
        auth-service
        notes-service
        email-service
        search-service
        notification-service
    end

    subgraph SharedLibs["libs/shared (importable)"]
        shared-types
        shared-auth
        shared-kafka
        shared-config
    end

    auth-service --> shared-types
    auth-service --> shared-auth
    auth-service --> shared-config

    notes-service --> shared-types
    notes-service --> shared-kafka
    notes-service --> shared-config

    email-service --> shared-types
    email-service --> shared-kafka
    email-service --> shared-config

    search-service --> shared-types
    search-service --> shared-config

    notification-service --> shared-types
    notification-service --> shared-kafka
    notification-service --> shared-config

    %% Constraint: libs CANNOT depend on apps
```

---

## CI/CD Integration with Nx Affected

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant PR as Pull Request
    participant GH as GitHub Actions
    participant Nx as Nx Affected
    participant Docker as Docker Build
    participant ECR as AWS ECR

    Dev->>PR: git push (changed notes-service)
    PR->>GH: trigger CI
    GH->>Nx: nx affected --target=test
    Note over Nx: Nx compares HEAD vs origin/main
    Note over Nx: Finds: notes-service changed
    Note over Nx: Also finds: shared-kafka changed (its dep)
    Nx->>GH: run tests for: notes-service, email-service, notification-service
    Note over Nx: email-service and notification-service depend on shared-kafka
    GH->>Nx: nx affected --target=build
    Nx->>Docker: build only affected service images
    Docker->>ECR: push notes-app/notes-service:sha-abc123
```

---

## TypeScript Path Aliases

```mermaid
graph LR
    subgraph Import["Import in any service"]
        Code["import \{ Note \} from '@notes-app/shared/types'"]
    end
    subgraph Resolve["tsconfig.base.json resolves to"]
        Path["libs/shared/types/src/index.ts"]
    end
    Code --> Path
```

The `tsconfig.base.json` at workspace root maps:
- `@notes-app/shared/types` → `libs/shared/types/src/index.ts`
- `@notes-app/shared/auth` → `libs/shared/auth/src/index.ts`
- `@notes-app/shared/kafka` → `libs/shared/kafka/src/index.ts`
- `@notes-app/shared/config` → `libs/shared/config/src/index.ts`

---

## Connection to the Request Journey

```mermaid
graph TB
    Client["🌐 Client"]
    NGINX["NGINX\n(API Gateway)"]

    subgraph NxWorkspace["Nx Workspace — all services built here"]
        Auth["auth-service\n:3333"]
        Notes["notes-service\n:3334"]
        Email["email-service\n(async)"]
    end

    subgraph SharedCode["Shared Libraries"]
        Types["shared/types\n(Note, User, DTOs)"]
        AuthLib["shared/auth\n(JWT verify)"]
    end

    Client --> NGINX
    NGINX --> Auth
    NGINX --> Notes
    Notes -->|"Kafka event"| Email
    Auth --> AuthLib
    Notes --> Types
    Auth --> Types

    style NxWorkspace fill:#e8eaf6,stroke:#3f51b5
    style SharedCode fill:#fff9c4,stroke:#f9a825
```

---

**Related Task:** [`tasks/microservices/task-009-nx-monorepo-for-microservices.md`](../../tasks/microservices/task-009-nx-monorepo-for-microservices.md)  
**Starter Config:** [`implementation/microservices/task-009-nx-monorepo/`](../../implementation/microservices/task-009-nx-monorepo/)  
**Automation:** [`automation/ansible/roles/notes-app/`](../../automation/ansible/roles/notes-app/) (deploys all Nx-built services to K8s)
