#!/bin/bash
# Store configuration in Consul KV

CONSUL_ADDR="consul-server.consul.svc.cluster.local:8500"

# Store backend configuration
curl --request PUT \
  --data '{"db_host":"postgresql","db_port":5432,"log_level":"info"}' \
  http://${CONSUL_ADDR}/v1/kv/notes-app/backend/config

# Store frontend configuration
curl --request PUT \
  --data '{"api_url":"http://api-gateway","theme":"light"}' \
  http://${CONSUL_ADDR}/v1/kv/notes-app/frontend/config

# Store environment-specific config
curl --request PUT \
  --data '{"environment":"dev","debug":true}' \
  http://${CONSUL_ADDR}/v1/kv/notes-app/env/dev

echo "Configuration stored in Consul KV"

