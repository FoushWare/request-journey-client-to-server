#!/bin/bash
# Install NGINX Ingress Controller

echo "Installing NGINX Ingress Controller..."

# Add Helm repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install Ingress Controller
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer

# Wait for installation
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

# Get external IP
echo "Ingress Controller installed!"
echo "External IP:"
kubectl get svc -n ingress-nginx ingress-nginx-controller

