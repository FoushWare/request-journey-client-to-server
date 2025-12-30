# Final Solution: Install and Configure Nomad

This directory contains Nomad installation and configuration.

## Files

### `nomad-config.hcl`
- Nomad server and client configuration
- Consul integration (optional)
- Vault integration (optional)

### `install-nomad.sh`
- Automated Nomad installation script
- Sets up systemd service

## Installation

1. **Run Installation Script**:
   ```bash
   chmod +x install-nomad.sh
   ./install-nomad.sh
   ```

2. **Verify**:
   ```bash
   nomad version
   nomad node status
   ```

3. **Access UI** (if enabled):
   ```bash
   nomad ui
   # Opens browser to http://localhost:4646
   ```

## Nomad vs Kubernetes

### Nomad Advantages
- Simpler to learn and operate
- Lighter weight
- Works with mixed workloads
- Good for small teams

### Kubernetes Advantages
- Larger ecosystem
- More features
- Industry standard
- Better for complex apps

## Next Steps

See `task-015-nomad-job-scheduling` for deploying applications.

