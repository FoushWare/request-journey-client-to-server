# Final Solution: Create Shared Docker Network

This directory contains the complete solution for Docker networking.

## Files

### `docker-compose.yml`
- Defines custom network `notes-network`
- All services connected to same network
- Services can communicate using service names

### `test-network.sh`
- Script to test network connectivity
- Verifies containers can reach each other

## Key Points

1. **Custom Network**: `notes-network` with bridge driver
2. **Service Names**: Use service names (postgres, backend, frontend) instead of IPs
3. **Network Isolation**: Containers on this network can communicate
4. **DNS Resolution**: Docker provides DNS for service names

## Usage

1. **Start services**:
   ```bash
   docker-compose up -d
   ```

2. **Test connectivity**:
   ```bash
   chmod +x test-network.sh
   ./test-network.sh
   ```

3. **Verify network**:
   ```bash
   docker network ls
   docker network inspect notes-app-network
   ```

## Benefits

- Service discovery via DNS
- Network isolation
- Easy service-to-service communication
- No hardcoded IPs

