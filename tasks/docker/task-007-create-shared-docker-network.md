# Task: Docker - Create Shared Docker Network

**Related Issue:** #37  
**Prerequisites:** task-003 (Docker Compose)  
**Estimated Time:** 1 hour  
**Notes App Context:** Create a shared Docker network so Notes App containers (frontend, backend, database) can communicate with each other using service names

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand Docker networks
- Create custom Docker networks
- Connect containers to networks
- Use service names for inter-container communication
- Understand network isolation

---

## Theory Section

### What are Docker Networks?

**Docker networks** enable containers to communicate. Types:
- **Bridge**: Default network for containers on same host
- **Host**: Uses host's network directly
- **Overlay**: For multi-host communication (Swarm)
- **Macvlan**: Containers appear as physical devices

**Why This Matters for Notes App:**

Containers need to communicate:
- Frontend → Backend: `http://backend:5000`
- Backend → Database: `db:5432`
- All services on same network can use service names

**Service Discovery:**
Docker provides DNS resolution:
- Service name `backend` resolves to backend container IP
- No need to know container IPs
- Automatic when on same network

---

## Prerequisites Check

- [ ] Completed task-003 (Docker Compose)
- [ ] Understanding of networking basics

---

## Step-by-Step Instructions

### Step 1: Understand Current Network Setup

**Docker Compose automatically creates a network:**
```bash
# Check existing networks
docker network ls

# Inspect default network
docker network inspect <project>_notes-network
```

### Step 2: Define Custom Network in docker-compose.yml

**Add network definition:**
```yaml
services:
  # ... services ...

networks:
  notes-network:
    driver: bridge
    name: notes-app-network
```

### Step 3: Connect Services to Network

**Update each service:**
```yaml
services:
  db:
    networks:
      - notes-network

  backend:
    networks:
      - notes-network

  frontend:
    networks:
      - notes-network

  nginx:
    networks:
      - notes-network
```

### Step 4: Use Service Names for Communication

**Backend connects to database:**
```yaml
backend:
  environment:
    DATABASE_URL: postgresql://user:pass@db:5432/notesapp
    # 'db' is the service name, resolves to database container
```

**Frontend connects to backend (server-side):**
```javascript
// In Next.js API routes or server-side code
const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://backend:5000';
// 'backend' is the service name
```

**Note**: Browser requests use `localhost` (from host), server-side uses service names.

### Step 5: Test Network Communication

**Test from container:**
```bash
# Test backend can reach database
docker-compose exec backend ping db

# Test frontend can reach backend
docker-compose exec frontend ping backend

# Test DNS resolution
docker-compose exec backend nslookup db
```

### Step 6: Verify Network Isolation

**Check network details:**
```bash
# Inspect network
docker network inspect notes-app-network

# Should show all connected containers
# Each container has an IP on this network
```

---

## Notes App Specifics

- All Notes App services on `notes-network`
- Backend uses `db:5432` to connect to database
- Frontend server-side uses `backend:5000` for API calls
- Browser uses `localhost:5000` (from host perspective)
- NGINX routes to `frontend:3000` and `backend:5000`

---

## Verification

- [ ] Network defined in docker-compose.yml
- [ ] All services connected to network
- [ ] Backend can ping database: `docker-compose exec backend ping db`
- [ ] Backend connects to database using `db:5432`
- [ ] Network visible: `docker network ls | grep notes`
- [ ] Notes App works (services communicate)

---

## Troubleshooting

**Issue: Cannot resolve service name**
- Verify services on same network
- Check service names match exactly
- Restart containers: `docker-compose restart`

**Issue: Connection refused**
- Verify target service is running
- Check port numbers are correct
- Verify network configuration

---

## Best Practices

1. **Named Networks**: Use descriptive names
2. **Network Isolation**: Separate networks for different apps
3. **Service Names**: Use consistent naming
4. **Documentation**: Document network architecture

---

## Next Steps

- Task 008: Add Persistent Volumes for Database
- Task 009: Configure Container Logging
- Phase 2: Kubernetes networking (Services, Ingress)

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

