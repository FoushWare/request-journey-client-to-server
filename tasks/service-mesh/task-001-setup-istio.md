# Task: Service Mesh - Setup Istio Service Mesh

**Related Issue:** #143  
**Prerequisites:** task-001 through task-010 (Kubernetes basics), microservices knowledge recommended  
**Estimated Time:** 4-6 hours  
**Notes App Context:** Install and configure Istio service mesh to manage, secure, and observe service-to-service communication in the Notes App Kubernetes cluster without changing application code

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand what a service mesh is and why it's needed
- Install Istio in a Kubernetes cluster
- Configure automatic sidecar injection
- Onboard services into the service mesh
- Understand Istio architecture (Envoy, istiod)
- Compare service mesh vs API Gateway vs Ingress

---

## Theory Section

### What is a Service Mesh?

A **service mesh** is a dedicated infrastructure layer for handling service-to-service communication. It provides:
- **Traffic Management**: Routing, load balancing, retries
- **Security**: mTLS, authentication, authorization
- **Observability**: Metrics, logs, traces
- **Resilience**: Circuit breakers, timeouts

**Why Service Mesh Matters:**

- **Without Service Mesh**: Each service handles communication logic
- **With Service Mesh**: Communication logic handled at platform level
- **Benefits**: Consistent policies, no code changes needed, centralized control

**Istio Architecture:**

- **Envoy Proxy**: Sidecar container that intercepts traffic
- **istiod (Control Plane)**: Manages and configures Envoy proxies
- **Data Plane**: Envoy proxies running alongside services
- **Control Plane**: istiod managing the mesh

**Why This Matters for Notes App:**

The Notes App (especially in microservices) benefits from:
- Automatic mTLS between services
- Traffic management without code changes
- Observability across all services
- Consistent security policies

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed Kubernetes tasks (task-001 through task-010)
- [ ] Kubernetes cluster with sufficient resources (4GB+ RAM recommended)
- [ ] `kubectl` configured and working
- [ ] Notes App deployed in Kubernetes
- [ ] Understanding of microservices (helpful but not required)

**Verify Prerequisites:**
```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

---

## Step-by-Step Instructions

### Step 1: Understand Service Mesh Concepts

**Objective:** Learn service mesh fundamentals

**Key Concepts:**

1. **Sidecar Pattern:**
   - Envoy proxy runs alongside each service
   - Intercepts all traffic to/from service
   - Applies policies transparently

2. **Control Plane vs Data Plane:**
   - **Control Plane**: istiod manages configuration
   - **Data Plane**: Envoy proxies handle traffic

3. **Service Mesh Benefits:**
   - No application code changes
   - Centralized policy management
   - Automatic observability
   - Built-in security

---

### Step 2: Install Istio CLI

**Objective:** Install Istio command-line tool

**Instructions:**

1. **Download Istio:**
```bash
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
```

2. **Verify installation:**
```bash
istioctl version
```

3. **Check prerequisites:**
```bash
istioctl verify-install
```

**Expected Output:**
- Istio CLI installed
- Version displayed
- Prerequisites verified

---

### Step 3: Install Istio in Cluster

**Objective:** Deploy Istio control plane

**Instructions:**

1. **Install Istio with default profile:**
```bash
istioctl install --set values.defaultRevision=default
```

2. **Verify installation:**
```bash
kubectl get pods -n istio-system
```

3. **Check Istio components:**
```bash
istioctl verify-install
```

**Expected Output:**
- istiod pod running
- istio-ingressgateway running
- istio-egressgateway running (optional)
- All components healthy

**Troubleshooting:**
- **Issue**: Pods not starting
  - **Solution**: Check cluster resources, increase node memory
- **Issue**: Installation fails
  - **Solution**: Check cluster access, verify kubectl permissions

---

### Step 4: Enable Automatic Sidecar Injection

**Objective:** Configure automatic Envoy sidecar injection

**Instructions:**

1. **Label namespace for injection:**
```bash
kubectl label namespace notes-app istio-injection=enabled
```

2. **Verify label:**
```bash
kubectl get namespace notes-app --show-labels
```

3. **For existing deployments, restart pods:**
```bash
kubectl rollout restart deployment -n notes-app
```

4. **Verify sidecars injected:**
```bash
kubectl get pods -n notes-app
# Should see 2/2 containers (app + istio-proxy)
```

**Expected Output:**
- Namespace labeled
- Pods have 2 containers (app + istio-proxy)
- Envoy sidecar running

---

### Step 5: Onboard Notes App Services

**Objective:** Deploy Notes App with Istio sidecars

**Instructions:**

1. **Ensure namespace is labeled:**
```bash
kubectl label namespace notes-app istio-injection=enabled --overwrite
```

2. **Deploy Notes App (if not already deployed):**
```bash
kubectl apply -f clusters/dev/apps/notes-app/ -n notes-app
```

3. **Verify sidecars:**
```bash
kubectl get pods -n notes-app -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[*].name}{"\n"}{end}'
```

4. **Check Envoy proxy:**
```bash
kubectl exec -n notes-app <pod-name> -c istio-proxy -- pilot-agent request GET server_info
```

**Expected Output:**
- All pods have istio-proxy sidecar
- Services communicating through mesh
- Traffic intercepted by Envoy

---

### Step 6: Verify Service Mesh is Working

**Objective:** Confirm Istio is managing traffic

**Instructions:**

1. **Check Envoy configuration:**
```bash
istioctl proxy-config cluster <pod-name>.notes-app
```

2. **View service endpoints:**
```bash
istioctl proxy-config endpoint <pod-name>.notes-app
```

3. **Check traffic flow:**
```bash
kubectl logs -n notes-app <pod-name> -c istio-proxy --tail=50
```

4. **Test service communication:**
```bash
# From one pod, call another service
kubectl exec -n notes-app <pod-name> -c <app-container> -- curl http://notes-app-backend:5000/health
```

**Expected Output:**
- Envoy proxies configured
- Traffic flowing through mesh
- Logs show Envoy activity

---

## Notes App Specifics

### How This Applies to Notes App

**Service Mesh Benefits:**
- Frontend → Backend communication secured with mTLS
- Automatic retries and timeouts
- Observability for all requests
- Traffic policies without code changes

**Architecture:**
```
Frontend Pod (with Envoy) → Backend Pod (with Envoy)
         ↓                           ↓
    Envoy Proxy                 Envoy Proxy
         ↓                           ↓
    istiod (Control Plane)
```

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. Istio installed in cluster
2. Control plane running (istiod)
3. Namespace labeled for injection
4. Notes App pods have Envoy sidecars
5. Traffic flowing through mesh
6. Envoy proxies configured

**Technical Verification:**
1. Istio pods running: `kubectl get pods -n istio-system`
2. Sidecars injected: `kubectl get pods -n notes-app`
3. Envoy working: Check proxy logs

**Commands to Run:**
```bash
# Check Istio installation
istioctl verify-install

# Check sidecars
kubectl get pods -n notes-app

# Check Envoy config
istioctl proxy-config cluster <pod-name>.notes-app
```

**Expected Results:**
- Istio managing Notes App traffic
- All services have sidecars
- Mesh operational

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Sidecars Not Injected**

**Symptoms:**
- Pods only have 1 container
- No istio-proxy container

**Solutions:**
1. Verify namespace label: `kubectl get namespace notes-app --show-labels`
2. Restart pods after labeling
3. Check injection webhook: `kubectl get mutatingwebhookconfiguration`

---

**Issue 2: Services Cannot Communicate**

**Symptoms:**
- Services can't reach each other
- Connection timeouts

**Solutions:**
1. Verify sidecars are running
2. Check Istio policies
3. Verify service DNS resolution
4. Check Envoy proxy logs

---

## Best Practices

### Security Best Practices
- Enable mTLS by default
- Use AuthorizationPolicies
- Restrict service-to-service access
- Monitor security events

### Operational Best Practices
- Label namespaces appropriately
- Monitor Envoy proxy resources
- Use Istio telemetry
- Document mesh policies

---

## Additional Resources

### Documentation
- [Istio Documentation](https://istio.io/latest/docs/)
- [Istio Getting Started](https://istio.io/latest/docs/setup/getting-started/)

---

## Next Steps

1. **Immediate Next Task**: `task-002-istio-traffic-management.md` - Traffic routing and management
2. **Related Tasks**: Security, observability

---

## Task Checklist

- [ ] Installed Istio CLI
- [ ] Installed Istio in cluster
- [ ] Enabled automatic sidecar injection
- [ ] Onboarded Notes App services
- [ ] Verified service mesh working
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

