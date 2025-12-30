# Final Solution: Consul Configuration Management

This directory contains Consul KV store usage for configuration management.

## Files

### `store-config.sh`
- Script to store configuration in Consul KV
- Organizes config by service and environment

### `read-config.js`
- Node.js code to read from Consul KV
- Watches for configuration changes
- Reloads configuration dynamically

## Usage

1. **Store Configuration**:
   ```bash
   ./store-config.sh
   ```

2. **Read Configuration** (in service):
   ```javascript
   const { loadAppConfig } = require('./read-config');
   const config = await loadAppConfig();
   ```

3. **Watch for Changes**:
   ```javascript
   watchConfig('notes-app/backend/config', (newConfig) => {
     // Reload configuration
   });
   ```

## Benefits

- Centralized configuration
- Dynamic updates without restart
- Environment-specific config
- Version history (Consul KV supports versioning)

