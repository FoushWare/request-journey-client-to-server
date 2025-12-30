# Final Solution: Service Discovery in Kubernetes

This directory contains examples of service discovery implementation.

## Kubernetes Service Discovery

### DNS Format
- Same namespace: `<service-name>`
- Different namespace: `<service-name>.<namespace>.svc.cluster.local`
- Full FQDN: `<service-name>.<namespace>.svc.cluster.local`

### Example URLs
```javascript
// Same namespace
const AUTH_URL = 'http://auth-service:3001';

// Different namespace
const AUTH_URL = 'http://auth-service.notes-app.svc.cluster.local:3001';
```

## Files

### `service-discovery-example.js`
- Example code showing how services discover each other
- Uses environment variables for flexibility

### `test-service-discovery.sh`
- Script to test DNS resolution
- Tests service communication

## Testing

1. **Test DNS Resolution**:
   ```bash
   kubectl run -it --rm test-pod --image=busybox --restart=Never -- nslookup auth-service.notes-app
   ```

2. **Test Service Communication**:
   ```bash
   kubectl exec -n notes-app <pod-name> -- curl http://auth-service:3001/health
   ```

3. **Verify Services**:
   ```bash
   kubectl get svc -n notes-app
   kubectl get endpoints -n notes-app
   ```

## Best Practices

- Use environment variables for service URLs
- Handle connection failures gracefully
- Use timeouts for service calls
- Log service discovery issues

