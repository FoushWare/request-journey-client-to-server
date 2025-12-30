# Final Solution: GitOps Best Practices

This directory contains examples and documentation of GitOps best practices.

## Best Practices

### 1. Repository Organization

```
clusters/
├── dev/
│   ├── flux-system/     # Flux configuration
│   └── apps/            # Applications
├── staging/
│   └── apps/
└── prod/
    └── apps/

base/                    # Base manifests (reusable)
├── backend/
├── frontend/
└── database/
```

### 2. Security

- Use read-only Git credentials
- Restrict cluster access (no manual kubectl)
- Use RBAC in Argo CD
- Audit all changes via Git history

### 3. Operations

- Monitor reconciliation status
- Set appropriate sync intervals
- Use health checks
- Document workflows

### 4. Git Workflow

- All changes via pull requests
- Review before merge
- Use semantic versioning
- Tag releases

### 5. Environment Management

- Separate branches or paths per environment
- Promote via Git (merge branches)
- Use Kustomize overlays for differences
- Keep base manifests DRY

## Example: Secure Repository Setup

```yaml
# Use read-only token
apiVersion: v1
kind: Secret
metadata:
  name: git-repo-readonly
stringData:
  url: https://github.com/org/repo
  username: git-readonly
  password: ghp_readonly_token
```

## Example: Monitoring

```bash
# Flux
flux get all
flux events --kind Kustomization

# Argo CD
argocd app list
argocd app get notes-app
```

