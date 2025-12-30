# Starter: Flux CD Setup

This directory contains the starting point for setting up Flux CD.

## What You'll Need

- Kubernetes cluster access
- Git repository with Notes App manifests
- Flux CLI installed

## Directory Structure

```
starter/
├── README.md (this file)
└── clusters/
    └── dev/
        └── apps/
            └── notes-app/
                └── (empty - you'll create manifests here)
```

## Your Task

1. Bootstrap Flux CD in your cluster
2. Create GitRepository source
3. Create Kustomization for Notes App
4. Verify Flux is managing deployments

## Next Steps

After completing the task, compare your solution with `../final-solution/`.

