# Final Solution: Multi-Cluster Argo CD

This directory contains solutions for multi-environment and multi-cluster Argo CD setups.

## Structure

```
final-solution/
├── clusters/
│   ├── dev/argocd-app.yaml      # Dev environment
│   ├── staging/argocd-app.yaml  # Staging environment
│   └── prod/argocd-app.yaml     # Production environment
├── multi-cluster/
│   └── cluster-registration.sh  # Script to register clusters
└── README.md
```

## Multi-Environment Setup

### Dev Environment
- Auto-sync enabled
- Self-heal enabled
- Uses `main` branch
- Fast iteration

### Staging Environment
- Auto-sync enabled
- Self-heal disabled (manual control)
- Uses `staging` branch
- Testing before production

### Production Environment
- Manual sync only
- No auto-sync
- Uses `prod` branch
- Maximum control

## Multi-Cluster Setup

1. **Register Additional Cluster**:
   ```bash
   chmod +x multi-cluster/cluster-registration.sh
   ./multi-cluster/cluster-registration.sh
   ```

2. **Deploy to Specific Cluster**:
   Update `destination.server` in Application to point to registered cluster.

## Environment Promotion

1. **Dev → Staging**: Merge `main` to `staging` branch
2. **Staging → Prod**: Merge `staging` to `prod` branch
3. Argo CD automatically syncs (or manually sync for prod)

## Load Balancing (Multi-Cluster)

Use external load balancer (ALB, NGINX) to distribute traffic across clusters.

