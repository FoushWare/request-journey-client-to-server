# Final Solution: Consul Service Discovery

This directory contains Consul service discovery configuration.

## Files

### `service-registration.json`
- Service registration definition
- Includes health check

### `register-service.sh`
- Script to register services with Consul

### `query-services.sh`
- Script to query services from Consul

## Service Registration

1. **Register Service**:
   ```bash
   curl --request PUT \
     --data @service-registration.json \
     http://consul-server:8500/v1/agent/service/register
   ```

2. **Query Services**:
   ```bash
   curl http://consul-server:8500/v1/catalog/services
   ```

3. **DNS Query** (from pod):
   ```bash
   dig @consul-dns.consul.svc.cluster.local notes-app-backend.service.consul
   ```

## Health Checks

Consul monitors service health:
- HTTP checks
- TCP checks
- Script checks

Unhealthy services are marked and removed from service discovery.

