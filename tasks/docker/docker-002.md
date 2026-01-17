# Task: Docker - Add Dockerfile for Frontend

**Issue:** #32  
**Category:** Docker  
**Priority:** High  
**Effort:** 3 days  
**Status:** Not Started

## Objective
Containerize the Next.js frontend application using Docker with multi-stage builds for optimization.

## Description
Create production-ready Dockerfile for Next.js application with efficient caching, minimal image size, and proper health checks.

## Sub-Tasks
- [ ] Create multi-stage Dockerfile
- [ ] First stage: Build Next.js app
- [ ] Second stage: Runtime environment
- [ ] Optimize image size (< 150MB)
- [ ] Configure health checks
- [ ] Set proper working directory
- [ ] Copy built application
- [ ] Configure environment variables
- [ ] Expose port for Next.js
- [ ] Build and test locally
- [ ] Test image in container

## Acceptance Criteria
- [ ] Image builds successfully
- [ ] Image size optimized
- [ ] Application starts in container
- [ ] Health checks passing
- [ ] No security vulnerabilities
- [ ] Next.js works correctly
- [ ] Static files served properly

## Multi-Stage Dockerfile
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Runtime stage
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js
CMD ["node", "server.js"]
```

## Build Command
```bash
docker build -t frontend:latest .
docker run -p 3000:3000 frontend:latest
```

## References
- Next.js Docker: https://nextjs.org/docs/deployment/docker
- Multi-stage Builds: https://docs.docker.com/build/building/multi-stage/
- Dockerfile Best Practices: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
