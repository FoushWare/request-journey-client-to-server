# Task: Service Mesh - Istio Security and mTLS

**Related Issue:** #143 (Phase 6)  
**Prerequisites:** task-001 (Istio setup), task-002 (Traffic management)  
**Estimated Time:** 3-4 hours  
**Notes App Context:** Enable mutual TLS (mTLS) and configure AuthorizationPolicies to secure service-to-service communication in Notes App without changing application code

---

## Learning Objectives

By the end of this task, you will be able to:

- Enable mutual TLS (mTLS) in Istio
- Configure PeerAuthentication policies
- Create AuthorizationPolicies
- Enforce zero-trust security model
- Understand Istio security concepts
- Secure Notes App service communication

---

## Theory Section

### Istio Security

**Mutual TLS (mTLS):**
- Both client and server authenticate
- Encrypts all service-to-service traffic
- Automatic certificate management
- No application code changes

**AuthorizationPolicies:**
- Control who can access what
- Enforce access policies
- Zero-trust security
- Service-level security

**Why This Matters:**
- Automatic encryption
- No code changes needed
- Centralized security policies
- Defense in depth

---

## Prerequisites Check

- [ ] Completed task-001 and task-002
- [ ] Istio installed
- [ ] Services in mesh

---

## Step-by-Step Instructions

### Step 1: Enable mTLS

**Objective:** Enable mutual TLS for all services

**Instructions:**

1. **Create PeerAuthentication:**
```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: notes-app
spec:
  mtls:
    mode: STRICT
```

2. **Apply:**
```bash
kubectl apply -f clusters/dev/istio/peer-authentication.yaml
```

3. **Verify mTLS:**
```bash
istioctl authn tls-check notes-app-backend notes-app
```

---

### Step 2: Create AuthorizationPolicies

**Objective:** Control service access

**Instructions:**

1. **Allow frontend to access backend:**
```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: notes-app
spec:
  selector:
    matchLabels:
      app: notes-app-backend
  action: ALLOW
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/notes-app/sa/notes-app-frontend"]
    to:
    - operation:
        methods: ["GET", "POST"]
```

2. **Apply and test**

---

## Verification

1. mTLS enabled and verified
2. AuthorizationPolicies created
3. Access controlled properly
4. Zero-trust enforced

---

## Task Checklist

- [ ] Enabled mTLS
- [ ] Created AuthorizationPolicies
- [ ] Verified security
- [ ] Tested access control

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

