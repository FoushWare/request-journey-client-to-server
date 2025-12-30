# Final Solution: Install and Configure Helm

This directory contains Helm installation and setup.

## Files

### `install-helm.sh`
- Automated Helm installation script
- Adds common repositories

## Manual Installation

### macOS
```bash
brew install helm
```

### Linux
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

## Verify

```bash
helm version
helm repo list
```

## Common Repositories

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

