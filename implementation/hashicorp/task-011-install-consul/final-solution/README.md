# Final Solution: Install and Configure Consul

This directory contains Consul installation and configuration.

## Files

### `consul-values.yaml`
- Helm values for Consul
- Configures server, client, and UI

### `install-consul.sh`
- Automated installation script

## Installation

1. **Add Helm Repository**:
   ```bash
   helm repo add hashicorp https://helm.releases.hashicorp.com
   helm repo update
   ```

2. **Install Consul**:
   ```bash
   helm install consul hashicorp/consul -f consul-values.yaml -n consul --create-namespace
   ```

3. **Verify**:
   ```bash
   kubectl get pods -n consul
   kubectl get svc -n consul
   ```

4. **Access UI**:
   ```bash
   kubectl port-forward -n consul svc/consul-ui 8500:80
   # Open http://localhost:8500
   ```

## Consul Components

- **Server**: Manages cluster state
- **Client**: Runs on each node
- **UI**: Web interface
- **Connect**: Service mesh (optional)

