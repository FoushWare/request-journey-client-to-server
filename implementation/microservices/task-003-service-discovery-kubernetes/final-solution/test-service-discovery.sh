#!/bin/bash
# Test service discovery in Kubernetes

echo "Testing service discovery..."

# Test DNS resolution from a pod
echo "1. Testing DNS resolution:"
kubectl run -it --rm test-pod --image=busybox --restart=Never -- nslookup auth-service.notes-app.svc.cluster.local

# Test service communication
echo "2. Testing service communication:"
kubectl exec -n notes-app <pod-name> -- curl http://auth-service:3001/health

# Test from different namespace
echo "3. Testing cross-namespace:"
kubectl exec -n default <pod-name> -- curl http://auth-service.notes-app.svc.cluster.local:3001/health

echo "Service discovery test complete!"

