# Final Solution: Istio Service Mesh Setup

This directory contains the complete solution for setting up Istio.

## Files

### `istio-install.yaml`
- IstioOperator configuration
- Customizes resource requests/limits
- Install with: `istioctl install -f istio-install.yaml`

### `namespace-label.yaml`
- Labels namespace for automatic sidecar injection
- Apply before deploying pods

## Installation Steps

1. **Install Istio CLI**:
   ```bash
   curl -L https://istio.io/downloadIstio | sh -
   cd istio-*
   export PATH=$PWD/bin:$PATH
   ```

2. **Install Istio**:
   ```bash
   istioctl install -f istio-install.yaml
   ```

3. **Label Namespace**:
   ```bash
   kubectl apply -f namespace-label.yaml
   ```

4. **Deploy Notes App** (pods will get sidecars automatically):
   ```bash
   kubectl apply -f <your-notes-app-manifests>
   ```

5. **Verify Sidecars**:
   ```bash
   kubectl get pods -n notes-app
   # Should see 2/2 containers (app + istio-proxy)
   ```

6. **Check Envoy Configuration**:
   ```bash
   istioctl proxy-config cluster <pod-name>.notes-app
   ```

## Verification

- All pods have `istio-proxy` sidecar
- Traffic flows through Envoy
- Istio control plane (istiod) running

