# Final Solution: Distributed Tracing with Jaeger

This directory contains distributed tracing setup for Notes App microservices.

## Files

### `tracing-setup.js`
- OpenTelemetry SDK setup
- Jaeger exporter configuration
- HTTP and Express instrumentations

### `jaeger-deployment.yaml`
- Jaeger deployment in Kubernetes
- Collector and UI services

## Setup Steps

1. **Install Dependencies**:
   ```bash
   npm install @opentelemetry/sdk-trace-node \
               @opentelemetry/exporter-jaeger \
               @opentelemetry/instrumentation-http \
               @opentelemetry/instrumentation-express
   ```

2. **Initialize Tracing** (in each service):
   ```javascript
   require('./tracing-setup');
   ```

3. **Deploy Jaeger**:
   ```bash
   kubectl apply -f jaeger-deployment.yaml
   ```

4. **Access Jaeger UI**:
   ```bash
   kubectl port-forward -n istio-system svc/jaeger-query 16686:16686
   # Open http://localhost:16686
   ```

## Viewing Traces

1. Make requests to Notes App
2. Open Jaeger UI
3. Select service and search for traces
4. View request flow across services
5. Analyze latency per service

## Benefits

- See complete request journey
- Identify latency bottlenecks
- Debug distributed systems
- Monitor service dependencies

