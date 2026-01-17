# Task: Docker - Add Dockerfile for Backend

**Issue:** #31  
**Category:** Docker  
**Priority:** High  
**Effort:** 3 days  
**Status:** Not Started

## Objective
Containerize the backend API using Docker with best practices for Node.js applications.

## Description
Create production-ready Dockerfile for the Node.js/Express backend with multi-stage builds, optimized layers, and minimal image size.

## Sub-Tasks
- [ ] Create `Dockerfile` in backend directory
- [ ] Select appropriate Node.js base image
- [ ] Set working directory in container
- [ ] Copy `package.json` and `package-lock.json`
- [ ] Install production dependencies
- [ ] Copy application source code
- [ ] Set environment variables
- [ ] Expose application port
- [ ] Set health check
- [ ] Build and test Docker image locally
- [ ] Test image functionality

## Acceptance Criteria
- [ ] Docker image builds successfully
- [ ] Image size optimized (< 200MB)
- [ ] Application starts correctly in container
- [ ] Health checks passing
- [ ] No security vulnerabilities in base image
- [ ] Image runs on Docker Desktop

## Docker Best Practices
- Use multi-stage builds to reduce image size
- Leverage layer caching
- Run as non-root user
- Use `.dockerignore` to exclude unnecessary files
- Minimize number of layers

## Testing
```bash
docker build -t backend:latest .
docker run -p 3000:3000 backend:latest
```

## References
- Docker Documentation: https://docs.docker.com/
- Node.js Docker Best Practices: https://github.com/nodejs/docker-node
- Dockerfile Reference: https://docs.docker.com/engine/reference/builder/
