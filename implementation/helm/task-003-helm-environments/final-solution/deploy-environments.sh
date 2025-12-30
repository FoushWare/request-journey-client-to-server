#!/bin/bash
# Deploy Notes App to Multiple Environments

CHART_PATH="./notes-app"

echo "Deploying to environments..."

# Deploy to Dev
echo "Deploying to DEV..."
helm upgrade --install notes-app-dev $CHART_PATH \
  -f values-dev.yaml \
  --namespace notes-app-dev \
  --create-namespace

# Deploy to Staging
echo "Deploying to STAGING..."
helm upgrade --install notes-app-staging $CHART_PATH \
  -f values-staging.yaml \
  --namespace notes-app-staging \
  --create-namespace

# Deploy to Prod
echo "Deploying to PROD..."
helm upgrade --install notes-app-prod $CHART_PATH \
  -f values-prod.yaml \
  --namespace notes-app-prod \
  --create-namespace

echo "Deployments complete!"
helm list --all-namespaces

