# Task: Load Testing with k6

**Related Issue:** #154  
**Category:** System Design  
**Prerequisites:** Docker, running Notes App  
**Estimated Time:** 3–4 hours  
**Tools:** k6, Grafana, Prometheus  
**Notes App Context:** Stress test the Notes App and identify bottlenecks

---

## Learning Objectives

- Use k6 to simulate high user load
- Baseline test the single-instance Notes App
- Identify bottlenecks under load
- Observe system behavior with Prometheus/Grafana during tests

---

## Theory Section

### Load Testing Concepts

| Term | Definition |
|------|-----------|
| **Throughput** | Requests per second the system can handle |
| **Latency** | Time to complete a single request |
| **P95/P99** | 95th/99th percentile latency |
| **Error Rate** | % of requests that fail |
| **Saturation** | When a resource is at 100% capacity |

### The Four Golden Signals (from Google SRE)

1. **Latency** — How long requests take
2. **Traffic** — How much demand is on the system
3. **Errors** — Rate of failed requests
4. **Saturation** — How full a service is (CPU, memory, connections)

---

## Step-by-Step Instructions

### Step 1: Install k6

```bash
# macOS
brew install k6

# Docker
docker pull grafana/k6
```

### Step 2: Write a Basic k6 Test

```javascript
// test-notes-api.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '30s', target: 10 },   // Ramp up to 10 users
    { duration: '1m', target: 10 },    // Stay at 10 users
    { duration: '30s', target: 100 },  // Ramp up to 100 users
    { duration: '1m', target: 100 },   // Stay at 100 users
    { duration: '30s', target: 0 },    // Ramp down
  ],
};

const BASE_URL = 'http://localhost:3000';

export default function () {
  // Login
  let loginRes = http.post(`${BASE_URL}/auth/login`, JSON.stringify({
    email: 'test@example.com',
    password: 'password'
  }), { headers: { 'Content-Type': 'application/json' } });
  
  check(loginRes, { 'login status 200': (r) => r.status === 200 });
  
  let token = loginRes.json('token');
  
  // Get notes
  let notesRes = http.get(`${BASE_URL}/api/notes`, {
    headers: { Authorization: `Bearer ${token}` }
  });
  
  check(notesRes, { 'notes status 200': (r) => r.status === 200 });
  
  sleep(1);
}
```

### Step 3: Run Baseline Test (Single Instance)

```bash
k6 run test-notes-api.js
```

Record:
- Max throughput (req/s)
- P95 latency
- Error rate at 100 users

### Step 4: Send Metrics to Grafana

```bash
# Run with Prometheus output
k6 run --out prometheus=namespace=k6 test-notes-api.js
```

Watch your Grafana dashboard in real time as load increases.

### Step 5: Identify the Bottleneck

Look for the first resource that hits 100%:
- CPU: `docker stats`
- Memory: `docker stats`
- Database connections: check PostgreSQL logs
- Response time degradation: k6 output

---

## Verification

1. k6 installed and test script works
2. Baseline measurement recorded
3. Load test run at 100, 500, 1000 users
4. Bottleneck identified (CPU/DB/Memory)
5. Results visible in Grafana

---

## Task Checklist

- [ ] k6 installed
- [ ] Basic load test script written
- [ ] Baseline test run and recorded
- [ ] Grafana showing k6 metrics
- [ ] Bottleneck identified under load
- [ ] Load test report documented

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed
