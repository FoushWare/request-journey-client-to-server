# Task: Docker - Add Docker Healthchecks

**Related Issue:** #36  
**Prerequisites:** task-001, task-002 (Frontend and Backend Dockerfiles)  
**Estimated Time:** 1-2 hours  
**Notes App Context:** Add health checks to Notes App containers to monitor service health and enable automatic recovery

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand Docker health checks
- Add HEALTHCHECK instructions to Dockerfiles
- Configure health checks in docker-compose.yml
- Use health checks for service dependencies
- Monitor container health

---

## Theory Section

### What are Docker Health Checks?

**Health checks** are commands Docker runs periodically to verify a container is healthy. Benefits:
- Automatic unhealthy container detection
- Service dependency management (wait for healthy)
- Integration with orchestration (Kubernetes, Docker Swarm)
- Better monitoring and alerting

**Health Check States:**
- **starting**: Initial grace period
- **healthy**: Health check passing
- **unhealthy**: Health check failing

**Why This Matters for Notes App:**

- Backend must be healthy before frontend depends on it
- Database must be ready before backend starts
- Enables automatic restart of unhealthy containers
- Better visibility into service status

---

## Prerequisites Check

- [ ] Completed task-001 (Frontend Dockerfile)
- [ ] Completed task-002 (Backend Dockerfile)
- [ ] Understanding of HTTP endpoints

---

## Step-by-Step Instructions

### Step 1: Add Health Check Endpoint to Backend

**Add to backend (server.js or routes):**
```javascript
// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'healthy',
    service: 'notes-app-backend',
    timestamp: new Date().toISOString()
  });
});
```

**Enhanced version with database check:**
```javascript
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    await db.authenticate();
    
    res.status(200).json({
      status: 'healthy',
      service: 'notes-app-backend',
      database: 'connected',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      service: 'notes-app-backend',
      database: 'disconnected',
      error: error.message
    });
  }
});
```

### Step 2: Add HEALTHCHECK to Backend Dockerfile

**Update `backend/Dockerfile`:**
```dockerfile
# Add after CMD instruction
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"
```

**Or using curl (if available in image):**
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1
```

### Step 3: Add HEALTHCHECK to Frontend Dockerfile

**Update `frontend/Dockerfile`:**
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"
```

### Step 4: Add Health Checks to docker-compose.yml

**Update services:**
```yaml
services:
  db:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U notesuser -d notesapp"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

  backend:
    healthcheck:
      test: ["CMD", "node", "-e", "require('http').get('http://localhost:5000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  frontend:
    healthcheck:
      test: ["CMD", "node", "-e", "require('http').get('http://localhost:3000', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
```

### Step 5: Use Health Checks for Dependencies

**Update depends_on to use health checks:**
```yaml
services:
  backend:
    depends_on:
      db:
        condition: service_healthy  # Wait for DB to be healthy

  frontend:
    depends_on:
      backend:
        condition: service_healthy  # Wait for backend to be healthy
```

### Step 6: Test Health Checks

**Check container health:**
```bash
# Start services
docker-compose up -d

# Check health status
docker ps
# Look for "(healthy)" status

# Check specific container
docker inspect notes-app-backend | grep -A 10 Health

# Test health endpoint manually
curl http://localhost:5000/health
```

---

## Notes App Specifics

- Backend health check verifies API is responding
- Database health check ensures DB is ready
- Frontend health check verifies Next.js server is up
- Health checks enable proper startup order

---

## Verification

- [ ] Health check endpoints added to backend
- [ ] HEALTHCHECK added to Dockerfiles
- [ ] Health checks configured in docker-compose.yml
- [ ] Dependencies use service_healthy condition
- [ ] Containers show healthy status: `docker ps`
- [ ] Health checks work: `docker inspect <container> | grep Health`

---

## Troubleshooting

**Issue: Health check always unhealthy**
- Verify endpoint exists and responds
- Check port number matches
- Increase start_period if service takes time to start
- Test endpoint manually: `curl http://localhost:PORT/health`

**Issue: Health check command not found**
- Use node-based health check (works in Node images)
- Or install curl in Dockerfile: `RUN apk add --no-cache curl`

**Issue: Dependencies not waiting**
- Use `condition: service_healthy` in depends_on
- Not just `depends_on: [service]`

---

## Best Practices

1. **Start Period**: Give services time to start (30-40s for Node apps)
2. **Interval**: Check every 30s (balance between responsiveness and load)
3. **Timeout**: 10s is usually sufficient
4. **Retries**: 3 retries before marking unhealthy
5. **Database Checks**: Include DB connectivity in backend health check

---

## Next Steps

- Task 007: Create Shared Docker Network
- Task 009: Configure Container Logging
- Phase 2: Kubernetes health checks (liveness/readiness probes)

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

