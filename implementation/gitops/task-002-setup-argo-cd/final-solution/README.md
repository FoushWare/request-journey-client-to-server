# Final Solution: Argo CD Setup

This directory contains the complete solution for setting up Argo CD.

## Files

### `argocd-application.yaml`
- Argo CD Application resource
- Defines source (Git repo) and destination (cluster/namespace)
- Configures auto-sync with prune and self-heal

### `argocd-repository.yaml`
- Git repository secret for Argo CD
- Supports both private and public repositories

## Installation Steps

1. **Install Argo CD**:
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

2. **Get Admin Password**:
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
   ```

3. **Port Forward to Access UI**:
   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   Access: https://localhost:8080 (username: admin)

4. **Connect Repository** (if private):
   ```bash
   kubectl apply -f argocd-repository.yaml
   ```

5. **Create Application**:
   ```bash
   kubectl apply -f argocd-application.yaml
   ```

6. **Verify in UI**:
   - Open Argo CD UI
   - Click "Applications"
   - See "notes-app" application
   - Click "Sync" to deploy

## Key Features

- **Auto-sync**: Automatically syncs when Git changes
- **Self-heal**: Reverts manual cluster changes
- **Prune**: Removes resources not in Git
- **Health Checks**: Monitors application health

