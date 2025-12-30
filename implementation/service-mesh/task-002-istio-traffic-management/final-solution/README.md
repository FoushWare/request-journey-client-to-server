# Final Solution: Istio Traffic Management

This directory contains traffic management configurations for Notes App.

## Files

### `virtualservice.yaml`
- Basic routing rules
- Path-based routing (/api → backend, / → frontend)

### `destinationrule.yaml`
- Traffic policies (load balancing, connection pooling)
- Subsets for versioning (v1, v2)

### `canary-release.yaml`
- Traffic splitting: 90% v1, 10% v2
- Gradual rollout strategy

### `blue-green.yaml`
- Instant traffic switch between versions
- Easy rollback

## Usage

1. **Apply DestinationRule** (defines subsets):
   ```bash
   kubectl apply -f destinationrule.yaml
   ```

2. **Apply VirtualService** (defines routing):
   ```bash
   kubectl apply -f virtualservice.yaml
   ```

3. **For Canary Release**:
   ```bash
   kubectl apply -f canary-release.yaml
   # Gradually increase v2 weight as you gain confidence
   ```

4. **For Blue-Green**:
   ```bash
   kubectl apply -f blue-green.yaml
   # Switch by changing weights
   ```

## Testing

```bash
# Test routing
curl http://notes-app-frontend:3000/
curl http://notes-app-backend:5000/api/health

# Monitor traffic distribution
istioctl proxy-config route <pod-name>.notes-app
```

