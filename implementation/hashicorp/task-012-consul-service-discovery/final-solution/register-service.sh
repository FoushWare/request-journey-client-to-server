#!/bin/bash
# Register Notes App services with Consul

CONSUL_ADDR="consul-server.consul.svc.cluster.local:8500"

# Register backend service
curl --request PUT \
  --data @service-registration.json \
  http://${CONSUL_ADDR}/v1/agent/service/register

# Register frontend service
curl --request PUT \
  --data '{
    "ID": "notes-app-frontend-1",
    "Name": "notes-app-frontend",
    "Tags": ["frontend", "ui"],
    "Address": "notes-app-frontend",
    "Port": 3000,
    "Check": {
      "HTTP": "http://notes-app-frontend:3000/health",
      "Interval": "10s"
    }
  }' \
  http://${CONSUL_ADDR}/v1/agent/service/register

echo "Services registered with Consul"

