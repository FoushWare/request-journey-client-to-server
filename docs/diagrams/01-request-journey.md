# 🔄 Request Journey — Client to Response

> This diagram traces the **full lifecycle of a single HTTP request** from the browser to the database and back.  
> Each step in this journey is a lesson in this project.

---

## Full Request Journey

```mermaid
sequenceDiagram
    participant Browser as 🌐 Browser
    participant DNS as 🔍 DNS Resolver
    participant CDN as 🌍 CDN (CloudFront)
    participant LB as ⚖️ Load Balancer (ELB)
    participant NGINX as 🔀 NGINX (Reverse Proxy)
    participant AG as 🚪 API Gateway
    participant Auth as 🔒 Auth Service
    participant Notes as 📝 Notes Service
    participant Redis as ⚡ Redis Cache
    participant PG as 🗄️ PostgreSQL
    participant Kafka as 📨 Kafka

    Browser->>DNS: GET notes-app.com/api/notes
    DNS-->>Browser: IP: 1.2.3.4 (TTL: 300s)

    Browser->>CDN: HTTPS Request (TLS handshake)
    CDN-->>Browser: Static assets from edge cache (if cached)
    CDN->>LB: Forward API requests

    LB->>NGINX: Route to available instance (round-robin)
    Note over LB,NGINX: SSL terminated at LB or NGINX

    NGINX->>AG: Proxy to API gateway
    Note over NGINX,AG: Rate limiting, logging, compression

    AG->>Auth: Validate JWT token
    Auth-->>AG: ✅ User ID: user_123

    AG->>Notes: GET /notes?userId=user_123
    Notes->>Redis: Cache lookup: "notes:user:user_123"

    alt Cache Hit
        Redis-->>Notes: [note1, note2, note3] (from cache)
    else Cache Miss
        Notes->>PG: SELECT * FROM notes WHERE user_id='user_123'
        PG-->>Notes: [note1, note2, note3]
        Notes->>Redis: SET "notes:user:user_123" (TTL: 60s)
    end

    Notes-->>AG: 200 OK { notes: [...] }
    AG-->>NGINX: Response
    NGINX-->>LB: Response (gzip compressed)
    LB-->>Browser: 200 OK (HTTPS)

    Notes-)Kafka: Publish note.accessed event (async)
    Note over Notes,Kafka: Non-blocking, fire-and-forget
```

---

## Component Roles in the Request Journey

```mermaid
graph LR
    subgraph "Step 1: DNS Resolution"
        B["Browser"] -->|"notes-app.com"| DNS["DNS Resolver"]
        DNS -->|"1.2.3.4 (TTL 300s)"| B
    end

    subgraph "Step 2: Edge & CDN"
        B2["Browser"] -->|HTTPS| CDN["CDN Edge Node"]
        CDN -->|static assets| B2
        CDN -->|API requests| Origin["Origin Servers"]
    end

    subgraph "Step 3: Load Balancer"
        LB["ELB / NGINX LB"] -->|round-robin| S1["Server 1"]
        LB -->|round-robin| S2["Server 2"]
        LB -->|round-robin| S3["Server 3"]
    end

    subgraph "Step 4: API & Auth"
        API["API Gateway"] -->|validate| Auth["Auth Service"]
        Auth -->|JWT verify| API
    end

    subgraph "Step 5: Business Logic"
        API2["Notes Service"] -->|cache lookup| Cache["Redis Cache"]
        API2 -->|on miss| DB["PostgreSQL"]
        DB -->|data| API2
        API2 -->|store| Cache
    end

    subgraph "Step 6: Response Path"
        Resp["200 OK + JSON"] -->|gzip| NGINX2["NGINX"]
        NGINX2 -->|HTTPS| Client["Browser"]
    end
```

---

## Error Handling in the Journey

```mermaid
flowchart TD
    Request["Incoming Request"]

    Request --> RateLimit{"Rate Limit OK?"}
    RateLimit -->|Exceeded| E1["429 Too Many Requests"]
    RateLimit -->|OK| AuthCheck{"JWT Valid?"}

    AuthCheck -->|Invalid/Expired| E2["401 Unauthorized"]
    AuthCheck -->|Valid| RouteMatch{"Route Exists?"}

    RouteMatch -->|No| E3["404 Not Found"]
    RouteMatch -->|Yes| ServiceUp{"Service Healthy?"}

    ServiceUp -->|Down| E4["503 Service Unavailable"]
    ServiceUp -->|Up| DBQuery{"DB Query OK?"}

    DBQuery -->|Timeout| E5["504 Gateway Timeout"]
    DBQuery -->|Error| E6["500 Internal Server Error"]
    DBQuery -->|Success| E7["200 OK"]

    E1 -->|logged| Log["Structured Log (JSON)"]
    E2 -->|logged| Log
    E4 -->|logged| Log
    E6 -->|logged| Log
    E7 -->|logged| Log

    Log --> ELK["ELK Stack / CloudWatch"]
```

---

## Latency Budget for a Request

```mermaid
gantt
    title Request Latency Budget (Total: ~100ms target)
    dateFormat X
    axisFormat %Lms

    section DNS
    DNS Lookup (cached)    : 0, 1
    section TLS
    TLS Handshake          : 1, 11
    section Network
    Client → CDN           : 11, 16
    CDN → Load Balancer    : 16, 17
    section Processing
    NGINX proxy            : 17, 18
    Auth token validation  : 18, 23
    Redis cache lookup     : 23, 24
    Notes DB query (miss)  : 24, 44
    Redis store            : 44, 45
    section Response
    JSON serialization     : 45, 48
    gzip compression       : 48, 50
    Response transport     : 50, 60
```

> **Goal**: < 100ms P95 for cache hits, < 250ms P95 for cache misses  
> Use `tasks/system-design/task-002-load-testing-k6.md` to measure this.
