// Read configuration from Consul KV
const axios = require('axios');
const consul = require('consul')({
  host: process.env.CONSUL_HOST || 'consul-server.consul.svc.cluster.local',
  port: process.env.CONSUL_PORT || 8500
});

// Read configuration
async function getConfig(key) {
  try {
    const result = await consul.kv.get(key);
    if (result && result.Value) {
      return JSON.parse(result.Value);
    }
    return null;
  } catch (error) {
    console.error('Error reading config:', error);
    return null;
  }
}

// Watch for configuration changes
function watchConfig(key, callback) {
  const watch = consul.watch({
    method: consul.kv.get,
    options: { key: key },
    backoffFactor: 1000
  });

  watch.on('change', (data) => {
    if (data && data.Value) {
      const config = JSON.parse(data.Value);
      callback(config);
    }
  });

  watch.on('error', (err) => {
    console.error('Watch error:', err);
  });
}

// Example usage
async function loadAppConfig() {
  const backendConfig = await getConfig('notes-app/backend/config');
  const frontendConfig = await getConfig('notes-app/frontend/config');
  const envConfig = await getConfig(`notes-app/env/${process.env.ENV || 'dev'}`);

  return {
    backend: backendConfig,
    frontend: frontendConfig,
    environment: envConfig
  };
}

// Watch for changes
watchConfig('notes-app/backend/config', (newConfig) => {
  console.log('Backend config updated:', newConfig);
  // Reload configuration
  loadAppConfig().then(config => {
    // Apply new configuration
    console.log('Configuration reloaded');
  });
});

module.exports = { getConfig, watchConfig, loadAppConfig };

