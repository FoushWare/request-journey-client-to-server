# Task: Service Mesh - Istio Traffic Management

**Related Issue:** #143 (Phase 4)  
**Prerequisites:** task-001 (Istio setup)  
**Estimated Time:** 3-4 hours  
**Notes App Context:** Configure Istio VirtualServices and DestinationRules to manage traffic routing, implement canary releases, and perform controlled rollouts for Notes App services

---

## Learning Objectives

By the end of this task, you will be able to:

- Create and configure VirtualServices
- Define DestinationRules for traffic policies
- Implement traffic splitting and canary releases
- Perform blue-green deployments
- Control traffic routing declaratively
- Understand Istio traffic management concepts

---

## Theory Section

### Istio Traffic Management

**VirtualService:**
- Defines routing rules for services
- Controls how requests are routed
- Supports path-based and header-based routing
- Enables traffic splitting

**DestinationRule:**
- Defines policies for traffic to a service
- Configures load balancing
- Sets connection pool settings
- Defines subsets for traffic splitting

**Traffic Splitting:**
- Route percentage of traffic to different versions
- Enable canary releases
- Gradual rollout strategies

**Why This Matters for Notes App:**
- Deploy new versions safely
- Test new features with limited traffic
- Roll back quickly if issues occur
- A/B testing capabilities

---

## Prerequisites Check

- [ ] Completed task-001 (Istio setup)
- [ ] Istio installed and running
- [ ] Notes App services have Envoy sidecars
- [ ] Multiple versions of Notes App (for canary)

---

## Step-by-Step Instructions

### Step 1: Create VirtualService for Notes App

**Objective:** Define routing rules for Notes App

**Instructions:**

1. **Create `clusters/dev/istio/virtualservice-notes-app.yaml`:**
```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: notes-app
  namespace: notes-app
spec:
  hosts:
  - notes-app-backend
  - notes-app-frontend
  http:
  - match:
    - uri:
        prefix: "/api"
    route:
    - destination:
        host: notes-app-backend
        port:
          number: 5000
  - match:
    - uri:
        prefix: "/"
    route:
    - destination:
        host: notes-app-frontend
        port:
          number: 3000
```

2. **Apply VirtualService:**
```bash
kubectl apply -f clusters/dev/istio/virtualservice-notes-app.yaml
```

3. **Verify:**
```bash
kubectl get virtualservice -n notes-app
```

---

### Step 2: Create DestinationRule

**Objective:** Define traffic policies

**Instructions:**

1. **Create DestinationRule:**
```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: notes-app-backend
  namespace: notes-app
spec:
  host: notes-app-backend
  trafficPolicy:
    loadBalancer:
      simple: ROUND_ROBIN
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http1MaxPendingRequests: 10
        http2MaxRequests: 100
        maxRequestsPerConnection: 2
    outlierDetection:
      consecutiveErrors: 3
      interval: 30s
      baseEjectionTime: 30s
```

2. **Apply and verify**

---

### Step 3: Implement Canary Release

**Objective:** Route traffic to multiple versions

**Instructions:**

1. **Create subsets in DestinationRule:**
```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: notes-app-backend
spec:
  host: notes-app-backend
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

2. **Split traffic in VirtualService:**
```yaml
spec:
  http:
  - route:
    - destination:
        host: notes-app-backend
        subset: v1
      weight: 90
    - destination:
        host: notes-app-backend
        subset: v2
      weight: 10
```

3. **Test canary:**
   - Deploy v2 with label `version: v2`
   - 10% traffic goes to v2
   - Monitor v2 performance
   - Gradually increase weight

---

### Step 4: Blue-Green Deployment

**Objective:** Switch traffic between versions instantly

**Instructions:**

1. **Deploy both versions:**
   - Blue: Current production version
   - Green: New version

2. **Switch traffic:**
```yaml
# Initially: 100% to blue
spec:
  http:
  - route:
    - destination:
        subset: blue
      weight: 100

# Switch: 100% to green
spec:
  http:
  - route:
    - destination:
        subset: green
      weight: 100
```

3. **Rollback:**
   - Change weight back to blue
   - Instant rollback

---

## Verification

1. VirtualService created and routing traffic
2. DestinationRule applied
3. Canary release working
4. Blue-green deployment tested

---

## Task Checklist

- [ ] Created VirtualService
- [ ] Created DestinationRule
- [ ] Implemented canary release
- [ ] Tested blue-green deployment
- [ ] Verified traffic routing

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

