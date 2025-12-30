#!/bin/bash
# Helm Installation Script

echo "Installing Helm..."

# macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install helm
fi

# Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Verify installation
helm version

# Add repositories
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable
helm repo update

echo "Helm installed successfully!"

