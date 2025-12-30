#!/bin/bash
# Query services from Consul

CONSUL_ADDR="consul-server.consul.svc.cluster.local:8500"

echo "Listing all services:"
curl http://${CONSUL_ADDR}/v1/catalog/services

echo -e "\n\nService details for notes-app-backend:"
curl http://${CONSUL_ADDR}/v1/catalog/service/notes-app-backend

echo -e "\n\nService health:"
curl http://${CONSUL_ADDR}/v1/health/service/notes-app-backend

echo -e "\n\nDNS query (from pod):"
# From a pod: dig @consul-dns.consul.svc.cluster.local notes-app-backend.service.consul

