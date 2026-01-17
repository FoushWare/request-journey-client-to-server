# Task: Docker - Set up Docker Registry (ECR/Hub)

**Issue:** #34  
**Category:** Docker  
**Priority:** High  
**Effort:** 3 days  
**Status:** Not Started

## Objective
Configure Docker registry for storing and managing container images in production.

## Description
Set up AWS Elastic Container Registry (ECR) or Docker Hub for pushing, storing, and pulling container images across environments.

## Sub-Tasks
- [ ] Create AWS ECR repository (or Docker Hub account)
- [ ] Configure AWS credentials
- [ ] Set up authentication
- [ ] Create naming convention for images
- [ ] Configure image tagging strategy
- [ ] Set up image lifecycle policies
- [ ] Implement image scanning
- [ ] Configure access permissions
- [ ] Test pushing images
- [ ] Test pulling images
- [ ] Document registry setup
- [ ] Set up CI/CD integration

## Acceptance Criteria
- [ ] Registry accessible and authenticated
- [ ] Can push images successfully
- [ ] Can pull images successfully
- [ ] Images scanned for vulnerabilities
- [ ] Lifecycle policies working
- [ ] Access control configured
- [ ] CI/CD integration ready

## ECR Setup
```bash
# Create ECR repository
aws ecr create-repository --repository-name request-journey/backend

# Get authentication token
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin [REGISTRY_URL]

# Tag image
docker tag backend:latest [REGISTRY_URL]/request-journey/backend:latest

# Push image
docker push [REGISTRY_URL]/request-journey/backend:latest
```

## Image Naming Convention
```
[registry]/[project]/[service]:[tag]

Example:
123456789.dkr.ecr.us-east-1.amazonaws.com/request-journey/backend:v1.2.3
123456789.dkr.ecr.us-east-1.amazonaws.com/request-journey/frontend:v1.2.3
```

## Image Tagging Strategy
- Latest: latest stable version
- Version: semantic versioning (v1.2.3)
- Git SHA: commit hash (abc123def)
- Branch: branch name (main, develop)

## References
- AWS ECR Documentation: https://docs.aws.amazon.com/ecr/
- Docker Hub: https://hub.docker.com/
- Container Registry Best Practices: https://docs.docker.com/docker-cloud/builds/push-images/
