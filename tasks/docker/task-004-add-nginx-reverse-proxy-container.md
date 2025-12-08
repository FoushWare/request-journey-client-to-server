# Task: Docker - Add NGINX Reverse Proxy Container

**Related Issue:** #34  
**Prerequisites:** task-003 (Docker Compose setup)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Add NGINX reverse proxy container to route Notes App frontend and backend traffic through a single entry point

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand reverse proxy concepts
- Add NGINX container to Docker Compose
- Configure NGINX to proxy frontend and backend
- Route traffic based on paths
- Test routing through NGINX

---

## Theory Section

### What is a Reverse Proxy?

A **reverse proxy** sits between clients and backend servers, forwarding requests and responses. Benefits:
- Single entry point for multiple services
- Load balancing
- SSL/TLS termination
- Caching
- Security (hides backend details)

**Why This Matters for Notes App:**

Instead of accessing:
- Frontend: `http://localhost:3000`
- Backend: `http://localhost:5000`

Users access everything through:
- `http://localhost:80` (or 443 for HTTPS)

NGINX routes:
- `/` → Frontend
- `/api/*` → Backend

---

## Prerequisites Check

- [ ] Completed task-003 (Docker Compose)
- [ ] Notes App running in Docker Compose
- [ ] Understanding of NGINX basics

---

## Step-by-Step Instructions

### Step 1: Create NGINX Configuration File

**Create `nginx/nginx.conf`:**
```nginx
upstream frontend {
    server frontend:3000;
}

upstream backend {
    server backend:5000;
}

server {
    listen 80;
    server_name localhost;

    # Frontend
    location / {
        proxy_pass http://frontend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Backend API
    location /api {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Health check
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
```

### Step 2: Add NGINX to docker-compose.yml

**Update `docker-compose.yml`:**
```yaml
services:
  # ... existing services ...

  nginx:
    image: nginx:alpine
    container_name: notes-app-nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - frontend
      - backend
    networks:
      - notes-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Step 3: Update Frontend API URL

**Update frontend environment:**
```yaml
frontend:
  environment:
    NEXT_PUBLIC_API_URL: http://localhost/api
    # Or for server-side: http://backend:5000
```

### Step 4: Start Services

```bash
docker-compose up -d
```

### Step 5: Test Routing

```bash
# Test frontend
curl http://localhost/

# Test backend API
curl http://localhost/api/health

# Test in browser
# Open http://localhost
```

---

## Notes App Specifics

- Frontend accessible at `http://localhost/`
- Backend API at `http://localhost/api/*`
- Single entry point simplifies deployment
- Ready for SSL/TLS in future tasks

---

## Verification

- [ ] NGINX container running
- [ ] Frontend accessible via `http://localhost/`
- [ ] Backend API accessible via `http://localhost/api/health`
- [ ] Notes App login works through NGINX
- [ ] Can create/view notes through NGINX

---

## Troubleshooting

**Issue: 502 Bad Gateway**
- Check backend/frontend containers are running
- Verify service names in nginx.conf match docker-compose service names
- Check network connectivity: `docker network inspect notes-network`

**Issue: Connection Refused**
- Verify ports are correct (3000 for frontend, 5000 for backend)
- Check containers are on same network

---

## Next Steps

- Task 005: Add Environment Variables
- Task 010 (NGINX phase): Configure SSL/TLS for HTTPS

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

