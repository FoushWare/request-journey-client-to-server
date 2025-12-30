# Task: Service Mesh - Istio Observability and Tracing

**Related Issue:** #143 (Phase 7)  
**Prerequisites:** task-001 (Istio setup), Prometheus and Grafana setup (from logging phase)  
**Estimated Time:** 3-4 hours  
**Notes App Context:** Integrate Istio with Prometheus, Grafana, and Jaeger to provide comprehensive observability for Notes App services, including metrics, dashboards, and distributed tracing

---

## Learning Objectives

By the end of this task, you will be able to:

- Integrate Istio with Prometheus for metrics
- Create Grafana dashboards for Istio
- Enable distributed tracing with Jaeger
- Visualize service dependencies with Kiali
- Understand Istio observability stack
- Monitor Notes App through service mesh

---

## Theory Section

### Istio Observability

**Metrics:**
- Service-level metrics (requests, latency, errors)
- Proxy-level metrics (Envoy stats)
- Automatic collection via Prometheus

**Tracing:**
- Distributed tracing across services
- Request flow visualization
- Latency analysis per service

**Visualization:**
- Grafana dashboards
- Kiali service graph
- Jaeger trace UI

---

## Prerequisites Check

- [ ] Completed task-001 (Istio setup)
- [ ] Prometheus installed (from logging phase)
- [ ] Grafana installed (from logging phase)
- [ ] Optional: Jaeger for tracing

---

## Step-by-Step Instructions

### Step 1: Configure Prometheus for Istio

**Objective:** Collect Istio metrics

**Instructions:**

1. **Verify Prometheus is scraping Istio:**
```bash
kubectl get servicemonitor -n istio-system
```

2. **Check Prometheus targets:**
   - Access Prometheus UI
   - Check Targets
   - Verify istio endpoints

---

### Step 2: Create Grafana Dashboards

**Objective:** Visualize Istio metrics

**Instructions:**

1. **Import Istio dashboards:**
   - Go to Grafana
   - Import dashboard ID: 7639 (Istio Service Dashboard)
   - Import dashboard ID: 7636 (Istio Workload Dashboard)

2. **View metrics:**
   - Service request rates
   - Error rates
   - Latency percentiles

---

### Step 3: Enable Distributed Tracing

**Objective:** Set up Jaeger for tracing

**Instructions:**

1. **Install Jaeger:**
```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.19/samples/addons/jaeger.yaml
```

2. **Access Jaeger UI:**
```bash
kubectl port-forward -n istio-system svc/tracing 16686:80
```

3. **View traces:**
   - Open http://localhost:16686
   - Search for Notes App traces
   - Visualize request flow

---

### Step 4: Install Kiali (Optional)

**Objective:** Visualize service mesh

**Instructions:**

1. **Install Kiali:**
```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.19/samples/addons/kiali.yaml
```

2. **Access Kiali:**
```bash
kubectl port-forward -n istio-system svc/kiali 20001:20001
```

3. **View service graph:**
   - See service dependencies
   - View traffic flow
   - Check health status

---

## Verification

1. Prometheus collecting Istio metrics
2. Grafana dashboards showing data
3. Jaeger tracing working
4. Kiali service graph visible

---

## Task Checklist

- [ ] Prometheus integrated
- [ ] Grafana dashboards created
- [ ] Jaeger tracing enabled
- [ ] Kiali installed (optional)
- [ ] Observability working

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

