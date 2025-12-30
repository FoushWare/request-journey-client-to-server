# Final Solution: Multi-Environment Configuration

This directory contains environment-specific Helm values.

## Files

### `values-dev.yaml`
- Development environment
- Lower resources, fewer replicas
- Dev domain

### `values-staging.yaml`
- Staging environment
- Medium resources
- Staging domain

### `values-prod.yaml`
- Production environment
- Higher resources, more replicas
- Production domain with TLS

### `deploy-environments.sh`
- Script to deploy to all environments

## Usage

1. **Deploy to Dev**:
   ```bash
   helm install notes-app-dev ./notes-app -f values-dev.yaml -n notes-app-dev
   ```

2. **Deploy to Staging**:
   ```bash
   helm install notes-app-staging ./notes-app -f values-staging.yaml -n notes-app-staging
   ```

3. **Deploy to Prod**:
   ```bash
   helm install notes-app-prod ./notes-app -f values-prod.yaml -n notes-app-prod
   ```

4. **Or use script**:
   ```bash
   chmod +x deploy-environments.sh
   ./deploy-environments.sh
   ```

## Environment Differences

- **Replicas**: Dev (1), Staging (2), Prod (3)
- **Resources**: Increase from dev to prod
- **Image Tags**: Dev uses "dev", Prod uses version tags
- **Domains**: Different domains per environment

