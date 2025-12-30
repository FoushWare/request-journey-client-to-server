# Task: Kubernetes - Pods with Probes, Resources, Volumes, and NGINX Ingress

**Related Issue:** #133  
**Prerequisites:** task-001 through task-010 (Kubernetes basics)  
**Estimated Time:** 4-5 hours  
**Notes App Context:** Create production-ready Kubernetes Pods for Notes App with health probes, resource limits, persistent volumes, and configure NGINX Ingress for external access

---

## Learning Objectives

- Create Pods with liveness and readiness probes
- Configure resource requests and limits
- Add persistent volumes to Pods
- Install and configure NGINX Ingress Controller
- Create Ingress rules for Notes App
- Understand production-ready Pod configuration

---

## Theory Section

### Production-Ready Pods

**Health Probes:**
- **Liveness Probe**: Determines if container is alive
- **Readiness Probe**: Determines if container is ready for traffic
- **Startup Probe**: Gives container time to start

**Resource Management:**
- **Requests**: Minimum resources guaranteed
- **Limits**: Maximum resources allowed
- Prevents resource starvation

**Persistent Volumes:**
- Data survives pod restarts
- Shared storage across pods
- Required for stateful applications

**NGINX Ingress:**
- External access to services
- SSL/TLS termination
- Path and host-based routing

---

## Prerequisites Check

- [ ] Completed Kubernetes basics
- [ ] Cluster with storage class
- [ ] Notes App deployed

---

## Step-by-Step Instructions

### Step 1: Create Pods with Probes

**Objective:** Add health checks to Pods

**Instructions:**

1. **Create Pod with probes:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: notes-app-backend
spec:
  containers:
  - name: backend
    image: notes-app-backend:latest
    ports:
    - containerPort: 5000
    livenessProbe:
      httpGet:
        path: /health
        port: 5000
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /ready
        port: 5000
      initialDelaySeconds: 5
      periodSeconds: 5
```

2. **Apply and test:**
```bash
kubectl apply -f pod-with-probes.yaml
kubectl describe pod notes-app-backend
```

### Step 2: Add Resource Requests and Limits

**Objective:** Configure resource constraints

**Instructions:**

1. **Add resources:**
```yaml
spec:
  containers:
  - name: backend
    resources:
      requests:
        memory: "256Mi"
        cpu: "250m"
      limits:
        memory: "512Mi"
        cpu: "500m"
```

2. **Verify scheduling:**
```bash
kubectl describe pod notes-app-backend
```

### Step 3: Add Persistent Volumes

**Objective:** Add persistent storage

**Instructions:**

1. **Create PersistentVolumeClaim:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: notes-app-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

2. **Mount in Pod:**
```yaml
spec:
  containers:
  - name: backend
    volumeMounts:
    - name: data
      mountPath: /app/data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: notes-app-data
```

### Step 4: Install NGINX Ingress Controller

**Objective:** Set up ingress for external access

**Instructions:**

1. **Install via Helm:**
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
```

2. **Verify installation:**
```bash
kubectl get pods -n ingress-nginx
```

### Step 5: Create Ingress Rules

**Objective:** Configure routing for Notes App

**Instructions:**

1. **Create Ingress:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: notes-app-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: notes-app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: notes-app-frontend
            port:
              number: 3000
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: notes-app-backend
            port:
              number: 5000
```

2. **Apply and test:**
```bash
kubectl apply -f ingress.yaml
kubectl get ingress
```

---

## Verification

1. Pods have probes configured
2. Resource limits set
3. Persistent volumes mounted
4. NGINX Ingress installed
5. Ingress rules working

---

## Task Checklist

- [ ] Created Pods with probes
- [ ] Added resource limits
- [ ] Configured persistent volumes
- [ ] Installed NGINX Ingress
- [ ] Created Ingress rules
- [ ] Verified functionality

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

