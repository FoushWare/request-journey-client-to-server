#!/bin/bash
# Install Consul using Helm

echo "Installing Consul..."

# Add HashiCorp Helm repository
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

# Install Consul
helm install consul hashicorp/consul \
  -f consul-values.yaml \
  --namespace consul \
  --create-namespace \
  --wait

# Verify installation
kubectl get pods -n consul
kubectl get svc -n consul

echo "Consul installed successfully!"
echo "Access UI: kubectl port-forward -n consul svc/consul-ui 8500:80"

