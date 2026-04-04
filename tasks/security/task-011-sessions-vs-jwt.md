# Task: Sessions vs JWT vs Cookies – Auth Mechanisms Compared

**Related Issue:** #155  
**Category:** Security  
**Prerequisites:** task-001 (JWT implementation), Docker  
**Estimated Time:** 4–5 hours  
**Language:** TypeScript/Node.js  
**Notes App Context:** Implement different auth mechanisms across different Notes App clients

---

## Learning Objectives

- Understand the difference between stateful and stateless authentication
- Implement server-side sessions with Redis
- Implement JWT access + refresh token pattern
- Implement HttpOnly cookie authentication
- Understand CSRF, XSS vulnerabilities per mechanism
- Know when to use each approach

---

## Theory Section

### Authentication Mechanisms Compared

#### 1. Server-Side Sessions (Stateful)

```
Client                    Server
  │───── login ──────────► │
  │◄───── session_id ────── │ (stores session in Redis)
  │                         │
  │── GET /notes ──────────► │
  │  (Cookie: session_id)    │
  │                         │── lookup session in Redis
  │◄────── 200 OK ─────────│
```

**Pros:** Easy to revoke, full control  
**Cons:** Requires session storage (Redis), not suitable for mobile or microservices

#### 2. JWT (Stateless)

```
Client                    Server
  │───── login ──────────► │
  │◄──── JWT token ──────── │ (no storage — JWT is self-contained)
  │                         │
  │── GET /notes ──────────► │
  │  (Authorization: Bearer) │
  │                         │── verify JWT signature (no DB lookup)
  │◄────── 200 OK ─────────│
```

**Pros:** Stateless, works across microservices, mobile-friendly  
**Cons:** Can't revoke until expiry (unless blacklist), larger than session ID

#### 3. HttpOnly Cookies

```
Client                    Server
  │───── login ──────────► │
  │◄──── Set-Cookie ──────── │ (HttpOnly; Secure; SameSite=Strict)
  │                         │
  │── GET /notes ──────────► │
  │  (Cookie auto-sent)      │
  │                         │── verify JWT inside cookie
  │◄────── 200 OK ─────────│
```

**Pros:** XSS safe (JS can't read HttpOnly cookies), browser-native  
**Cons:** CSRF risk (mitigated with SameSite=Strict), browser-only

---

## Step-by-Step Instructions

### Step 1: Implement Server-Side Sessions

```typescript
// Express session with Redis store
import session from 'express-session';
import RedisStore from 'connect-redis';
import { createClient } from 'redis';

const redisClient = createClient({ url: 'redis://localhost:6379' });

app.use(session({
  store: new RedisStore({ client: redisClient }),
  secret: process.env.SESSION_SECRET!,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    httpOnly: true,
    maxAge: 1000 * 60 * 60 * 24, // 24 hours
  }
}));

// Login handler
app.post('/auth/session/login', async (req, res) => {
  const user = await validateCredentials(req.body);
  req.session.userId = user.id;
  req.session.email = user.email;
  res.json({ message: 'Logged in' });
});

// Logout (invalidates session immediately)
app.post('/auth/session/logout', (req, res) => {
  req.session.destroy();
  res.json({ message: 'Logged out' });
});
```

### Step 2: Implement JWT with Refresh Tokens

```typescript
const ACCESS_TOKEN_TTL = '15m';
const REFRESH_TOKEN_TTL = '7d';

app.post('/auth/jwt/login', async (req, res) => {
  const user = await validateCredentials(req.body);
  
  const accessToken = jwt.sign(
    { userId: user.id, email: user.email },
    process.env.JWT_SECRET!,
    { expiresIn: ACCESS_TOKEN_TTL }
  );
  
  const refreshToken = jwt.sign(
    { userId: user.id },
    process.env.REFRESH_SECRET!,
    { expiresIn: REFRESH_TOKEN_TTL }
  );
  
  // Store refresh token in Redis (allows revocation)
  await redis.setex(`refresh:${user.id}:${refreshToken}`, 7 * 24 * 3600, '1');
  
  res.json({ accessToken, refreshToken });
});

// Refresh the access token
app.post('/auth/jwt/refresh', async (req, res) => {
  const { refreshToken } = req.body;
  const payload = jwt.verify(refreshToken, process.env.REFRESH_SECRET!) as any;
  
  // Check if refresh token is still valid (not revoked)
  const exists = await redis.exists(`refresh:${payload.userId}:${refreshToken}`);
  if (!exists) throw new Error('Refresh token revoked');
  
  const newAccessToken = jwt.sign(
    { userId: payload.userId },
    process.env.JWT_SECRET!,
    { expiresIn: ACCESS_TOKEN_TTL }
  );
  
  res.json({ accessToken: newAccessToken });
});
```

### Step 3: Implement HttpOnly Cookie Auth

```typescript
app.post('/auth/cookie/login', async (req, res) => {
  const user = await validateCredentials(req.body);
  
  const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET!, {
    expiresIn: '24h'
  });
  
  res.cookie('auth_token', token, {
    httpOnly: true,    // JS cannot read this cookie (XSS protection)
    secure: true,      // HTTPS only
    sameSite: 'strict', // CSRF protection
    maxAge: 24 * 60 * 60 * 1000,
  });
  
  res.json({ message: 'Logged in' });
});
```

### Step 4: Notes App Multi-Auth Strategy

Apply different auth to different entry points:

- `/api/web/*` — HttpOnly cookie auth (browser frontend)
- `/api/mobile/*` — JWT with refresh tokens (mobile app)
- `/admin/*` — Server-side sessions (admin dashboard)

### Step 5: Security Comparison Table

| Attack | Sessions | JWT | HttpOnly Cookie |
|--------|----------|-----|-----------------|
| **XSS** | ✅ Safe (httpOnly cookie) | ⚠️ Risky if stored in localStorage | ✅ Safe (httpOnly) |
| **CSRF** | ⚠️ Needs CSRF token | ✅ Safe (manually set header) | ⚠️ Needs SameSite |
| **Token revocation** | ✅ Instant (delete session) | ⚠️ Wait for expiry (or blacklist) | ✅ (backed by JWT + blacklist) |

---

## Verification

1. Session-based login/logout works with Redis
2. JWT access + refresh token rotation works
3. HttpOnly cookie auth works
4. Refresh token can be revoked
5. Notes App uses correct auth per entry point

---

## Task Checklist

- [ ] Server-side sessions with Redis implemented
- [ ] JWT with refresh token rotation implemented
- [ ] HttpOnly cookie authentication implemented
- [ ] Token revocation implemented for JWT
- [ ] Multi-auth entry points configured
- [ ] Security comparison documented
- [ ] CSRF protection added for cookie-based auth

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

---

## Diagram

```mermaid
sequenceDiagram
    participant C as Client
    participant S as Server
    participant SS as Session Store (Redis/DB)

    Note over C,SS: 1 — Server Session
    C->>S: POST /login (credentials)
    S->>SS: Store session data
    SS-->>S: session_id
    S-->>C: Set-Cookie: session_id

    Note over C,S: 2 — JWT (Stateless)
    C->>S: POST /login (credentials)
    S-->>C: JWT access token (signed, no server state)
    C->>S: GET /api (Authorization: Bearer <jwt>)
    S-->>C: Validated from signature alone

    Note over C,S: 3 — HttpOnly Cookie
    C->>S: POST /login (credentials)
    S-->>C: Set-Cookie: token=<jwt>; HttpOnly; SameSite=Strict
    C->>S: GET /api (cookie sent automatically, JS cannot read it)
    S-->>C: Response
```

---

## Automation Reference

> The steps above are **manual/raw** — they teach you the concept by doing it yourself.  
> The `automation/` directory contains the production-grade IaC equivalent:

| What | Where | Description |
|------|-------|-------------|
| Security Role | [`automation/ansible/roles/security/`](../../automation/ansible/roles/security/) | Hardens the server and configures secure session/cookie settings |
| RDS Module | [`automation/terraform/modules/rds/`](../../automation/terraform/modules/rds/) | PostgreSQL used as a persistent server-side session store |
| ElastiCache Module | [`automation/terraform/modules/elasticache/`](../../automation/terraform/modules/elasticache/) | Redis used as a high-speed session store or JWT blacklist |
