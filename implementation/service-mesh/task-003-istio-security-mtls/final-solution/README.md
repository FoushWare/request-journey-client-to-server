# Final Solution: Istio Security and mTLS

This directory contains security configurations for Notes App.

## Files

### `peer-authentication.yaml`
- Enables mTLS for all service-to-service communication
- STRICT mode enforces mTLS (recommended for production)
- PERMISSIVE mode allows gradual migration

### `authorization-policy.yaml`
- Controls which services can access which
- Allows frontend to access backend
- Denies all other access (zero-trust)

## Usage

1. **Enable mTLS**:
   ```bash
   kubectl apply -f peer-authentication.yaml
   ```

2. **Apply Authorization Policies**:
   ```bash
   kubectl apply -f authorization-policy.yaml
   ```

3. **Verify mTLS**:
   ```bash
   istioctl authn tls-check notes-app-backend notes-app
   ```

4. **Test Access**:
   ```bash
   # Should work: frontend → backend
   # Should fail: other services → backend
   ```

## Security Benefits

- **mTLS**: All traffic encrypted and authenticated
- **Zero-Trust**: Only authorized services can communicate
- **Network Policies**: Defense in depth

