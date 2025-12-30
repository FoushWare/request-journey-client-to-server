#!/bin/bash
# Script to register additional clusters with Argo CD

# Get cluster context
CONTEXT_NAME=$(kubectl config current-context)
CLUSTER_NAME="staging-cluster"

# Register cluster
argocd cluster add "$CONTEXT_NAME" --name "$CLUSTER_NAME"

# Verify
argocd cluster list

echo "Cluster registered successfully!"
echo "You can now deploy applications to this cluster by specifying it in the Application destination."

