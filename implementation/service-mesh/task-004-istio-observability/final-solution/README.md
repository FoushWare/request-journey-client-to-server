# Final Solution: Istio Observability

This directory contains observability setup for Istio.

## Files

### `jaeger-install.yaml`
- Jaeger deployment for distributed tracing
- Access UI via port-forward: `kubectl port-forward -n istio-system svc/tracing 16686:80`

### `kiali-install.yaml`
- Kiali deployment for service mesh visualization
- Access UI via port-forward: `kubectl port-forward -n istio-system svc/kiali 20001:20001`

## Setup Steps

1. **Install Jaeger**:
   ```bash
   kubectl apply -f jaeger-install.yaml
   # Or use: kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.19/samples/addons/jaeger.yaml
   ```

2. **Access Jaeger UI**:
   ```bash
   kubectl port-forward -n istio-system svc/tracing 16686:80
   # Open http://localhost:16686
   ```

3. **Install Kiali** (optional):
   ```bash
   kubectl apply -f kiali-install.yaml
   ```

4. **Access Kiali UI**:
   ```bash
   kubectl port-forward -n istio-system svc/kiali 20001:20001
   # Open http://localhost:20001
   ```

5. **Import Grafana Dashboards**:
   - Dashboard ID: 7639 (Istio Service Dashboard)
   - Dashboard ID: 7636 (Istio Workload Dashboard)

## What You Can See

- **Prometheus**: Service metrics (requests, latency, errors)
- **Grafana**: Visualized dashboards
- **Jaeger**: Distributed traces across services
- **Kiali**: Service dependency graph

## Testing

Make requests to Notes App and view:
- Metrics in Grafana
- Traces in Jaeger
- Service graph in Kiali

