# Final Solution: Kubernetes Pods with Probes, Resources, Volumes, and Ingress

This directory contains production-ready Pod configurations.

## Files

### `pod-with-probes.yaml`
- Pod with liveness, readiness, and startup probes
- Resource requests and limits
- Persistent volume mount

### `pvc.yaml`
- PersistentVolumeClaim for data storage

### `ingress.yaml`
- Ingress configuration for external access
- Path-based routing
- TLS configuration

### `install-ingress.sh`
- Script to install NGINX Ingress Controller

## Usage

1. **Install Ingress Controller**:
   ```bash
   chmod +x install-ingress.sh
   ./install-ingress.sh
   ```

2. **Create PVC**:
   ```bash
   kubectl apply -f pvc.yaml
   ```

3. **Create Pod**:
   ```bash
   kubectl apply -f pod-with-probes.yaml
   ```

4. **Create Ingress**:
   ```bash
   kubectl apply -f ingress.yaml
   ```

5. **Verify**:
   ```bash
   kubectl get pods -n notes-app
   kubectl get ingress -n notes-app
   kubectl describe pod notes-app-backend -n notes-app
   ```

## Key Features

- **Health Probes**: Ensure containers are healthy
- **Resource Limits**: Prevent resource exhaustion
- **Persistent Storage**: Data survives pod restarts
- **External Access**: Ingress provides external access

