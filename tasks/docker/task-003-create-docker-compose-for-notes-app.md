# Task: Docker - Create Docker Compose for Notes App

**Related Issue:** #33  
**Prerequisites:** task-001, task-002 (Frontend and Backend Dockerfiles)  
**Estimated Time:** 3-4 hours  
**Notes App Context:** Orchestrate all Notes App services (frontend, backend, database) to run together with a single command

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand Docker Compose and its purpose
- Create docker-compose.yml files
- Configure multiple services to work together
- Set up Docker networks for service communication
- Configure volumes for data persistence
- Manage multi-container applications

---

## Theory Section

### What is Docker Compose?

**Docker Compose** is a tool for defining and running multi-container Docker applications. Instead of running multiple `docker run` commands, you define all services in a YAML file and start them with one command.

**Key Concepts:**

- **Services**: Each container is defined as a service
- **Networks**: Services can communicate via Docker networks
- **Volumes**: Persistent data storage across container restarts
- **Environment Variables**: Configuration for each service
- **Dependencies**: Services can depend on other services starting first

**Why This Matters for Notes App:**

The Notes App consists of:
- **Frontend**: Next.js application (port 3000)
- **Backend**: Express API (port 5000)
- **Database**: PostgreSQL or MongoDB (port 5432 or 27017)
- **Redis** (optional): For caching/sessions (port 6379)

Docker Compose allows you to:
- Start all services with one command
- Configure networking between services
- Manage environment variables
- Persist database data

**Real-World Context:**

In production:
- Docker Compose is great for development and testing
- Production often uses Kubernetes or Docker Swarm
- But Compose helps understand orchestration concepts
- Many production setups use Compose for local development

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed task-001 (Frontend Dockerfile)
- [ ] Completed task-002 (Backend Dockerfile)
- [ ] Docker Compose installed (usually comes with Docker Desktop)
- [ ] Notes App codebase with frontend and backend
- [ ] Understanding of YAML syntax

**Verify Docker Compose:**
```bash
docker-compose --version
# Should show: docker-compose version 2.x.x
# Or: Docker Compose version v2.x.x
```

---

## Step-by-Step Instructions

### Step 1: Understand Notes App Architecture

**Objective:** Understand what services need to run

**Services Required:**
1. **Frontend**: Next.js app (needs backend API URL)
2. **Backend**: Express API (needs database connection)
3. **Database**: PostgreSQL or MongoDB (stores data)
4. **Redis** (optional): For caching or sessions

**Service Dependencies:**
- Frontend depends on Backend (API calls)
- Backend depends on Database (data storage)
- Backend may depend on Redis (caching)

**Ports:**
- Frontend: 3000
- Backend: 5000
- Database: 5432 (PostgreSQL) or 27017 (MongoDB)
- Redis: 6379

---

### Step 2: Create docker-compose.yml

**Objective:** Create Docker Compose configuration file

**Location:** Create `docker-compose.yml` in project root (or create `docker/` folder)

**Basic Structure:**
```yaml
version: '3.8'

services:
  # Database service
  db:
    image: postgres:15-alpine
    container_name: notes-app-db
    environment:
      POSTGRES_USER: notesuser
      POSTGRES_PASSWORD: notespassword
      POSTGRES_DB: notesapp
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - notes-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U notesuser"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Backend service
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: notes-app-backend
    environment:
      NODE_ENV: production
      PORT: 5000
      DATABASE_URL: postgresql://notesuser:notespassword@db:5432/notesapp
      JWT_SECRET: your-jwt-secret-key-change-in-production
      JWT_EXPIRES_IN: 7d
    ports:
      - "5000:5000"
    depends_on:
      db:
        condition: service_healthy
    networks:
      - notes-network
    healthcheck:
      test: ["CMD", "node", "-e", "require('http').get('http://localhost:5000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  # Frontend service
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: notes-app-frontend
    environment:
      NODE_ENV: production
      NEXT_PUBLIC_API_URL: http://localhost:5000
    ports:
      - "3000:3000"
    depends_on:
      - backend
    networks:
      - notes-network
    healthcheck:
      test: ["CMD", "node", "-e", "require('http').get('http://localhost:3000', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Redis (optional)
  redis:
    image: redis:7-alpine
    container_name: notes-app-redis
    ports:
      - "6379:6379"
    networks:
      - notes-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

# Networks
networks:
  notes-network:
    driver: bridge

# Volumes
volumes:
  postgres_data:
    driver: local
```

**Create the File:**
```bash
# In project root
touch docker-compose.yml
# Or
mkdir -p docker
touch docker/docker-compose.yml
```

---

### Step 3: Configure Database Service

**Objective:** Set up PostgreSQL database service

**For PostgreSQL:**
```yaml
db:
  image: postgres:15-alpine
  container_name: notes-app-db
  environment:
    POSTGRES_USER: notesuser
    POSTGRES_PASSWORD: notespassword
    POSTGRES_DB: notesapp
  ports:
    - "5432:5432"
  volumes:
    - postgres_data:/var/lib/postgresql/data
  networks:
    - notes-network
  restart: unless-stopped
  healthcheck:
    test: ["CMD-SHELL", "pg_isready -U notesuser -d notesapp"]
    interval: 10s
    timeout: 5s
    retries: 5
```

**For MongoDB (alternative):**
```yaml
db:
  image: mongo:6
  container_name: notes-app-db
  environment:
    MONGO_INITDB_ROOT_USERNAME: notesuser
    MONGO_INITDB_ROOT_PASSWORD: notespassword
    MONGO_INITDB_DATABASE: notesapp
  ports:
    - "27017:27017"
  volumes:
    - mongo_data:/data/db
  networks:
    - notes-network
  restart: unless-stopped
  healthcheck:
    test: ["CMD", "mongosh", "--eval", "db.adminCommand('ping')"]
    interval: 10s
    timeout: 5s
    retries: 5
```

**Key Points:**
- Use Alpine images for smaller size
- Set environment variables for database credentials
- Create named volume for data persistence
- Add health check for dependency management

---

### Step 4: Configure Backend Service

**Objective:** Set up backend service with database connection

**Backend Service Configuration:**
```yaml
backend:
  build:
    context: ./backend
    dockerfile: Dockerfile
  container_name: notes-app-backend
  environment:
    NODE_ENV: production
    PORT: 5000
    DATABASE_URL: postgresql://notesuser:notespassword@db:5432/notesapp
    # Or for MongoDB:
    # DATABASE_URL: mongodb://notesuser:notespassword@db:27017/notesapp?authSource=admin
    JWT_SECRET: your-jwt-secret-key-change-in-production
    JWT_EXPIRES_IN: 7d
    CORS_ORIGIN: http://localhost:3000
  ports:
    - "5000:5000"
  depends_on:
    db:
      condition: service_healthy
  networks:
    - notes-network
  restart: unless-stopped
  healthcheck:
    test: ["CMD", "node", "-e", "require('http').get('http://localhost:5000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"]
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 40s
```

**Key Points:**
- Use `build` to build from Dockerfile
- `depends_on` ensures database starts first
- Use service name `db` in DATABASE_URL (Docker DNS)
- Health check waits for backend to be ready

---

### Step 5: Configure Frontend Service

**Objective:** Set up frontend service

**Frontend Service Configuration:**
```yaml
frontend:
  build:
    context: ./frontend
    dockerfile: Dockerfile
  container_name: notes-app-frontend
  environment:
    NODE_ENV: production
    NEXT_PUBLIC_API_URL: http://localhost:5000
    # For production, use backend service name:
    # NEXT_PUBLIC_API_URL: http://backend:5000
  ports:
    - "3000:3000"
  depends_on:
    - backend
  networks:
    - notes-network
  restart: unless-stopped
  healthcheck:
    test: ["CMD", "node", "-e", "require('http').get('http://localhost:3000', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"]
    interval: 30s
    timeout: 10s
    retries: 3
```

**Key Points:**
- Frontend depends on backend
- API URL can use `localhost` (browser) or service name (server-side)
- Health check verifies frontend is serving

---

### Step 6: Configure Networks

**Objective:** Set up Docker network for service communication

**Network Configuration:**
```yaml
networks:
  notes-network:
    driver: bridge
    name: notes-app-network
```

**Why Networks Matter:**
- Services can communicate using service names (e.g., `db`, `backend`)
- Isolated from other Docker networks
- Bridge driver is default (good for single host)

**Service Communication:**
- Backend connects to database: `db:5432`
- Frontend calls backend: `backend:5000` (server-side) or `localhost:5000` (browser)

---

### Step 7: Configure Volumes

**Objective:** Set up persistent storage for database

**Volume Configuration:**
```yaml
volumes:
  postgres_data:
    driver: local
    name: notes-app-postgres-data
```

**Why Volumes Matter:**
- Database data persists across container restarts
- Data survives `docker-compose down`
- Only removed with `docker-compose down -v`

**Volume Types:**
- **Named volumes** (recommended): Managed by Docker
- **Bind mounts**: Map to host directory
- **Anonymous volumes**: Temporary

---

### Step 8: Start All Services

**Objective:** Start the entire Notes App stack

**Start Command:**
```bash
docker-compose up -d
```

**Command Breakdown:**
- `docker-compose up`: Start services
- `-d`: Detached mode (run in background)

**Expected Output:**
```
[+] Running 4/4
 ✔ Network notes-app-network    Created
 ✔ Volume "notes-app-postgres-data"  Created
 ✔ Container notes-app-db        Started
 ✔ Container notes-app-backend   Started
 ✔ Container notes-app-frontend  Started
```

**Check Status:**
```bash
docker-compose ps
```

**Expected Output:**
```
NAME                  IMAGE                    STATUS
notes-app-db          postgres:15-alpine       Up (healthy)
notes-app-backend     notes-app-backend:latest Up (healthy)
notes-app-frontend    notes-app-frontend:latest Up (healthy)
```

---

### Step 9: Verify All Services

**Objective:** Test that all services are working

**Check Logs:**
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs backend
docker-compose logs frontend
docker-compose logs db
```

**Test Database:**
```bash
# Connect to PostgreSQL
docker-compose exec db psql -U notesuser -d notesapp

# Or for MongoDB
docker-compose exec db mongosh -u notesuser -p notespassword
```

**Test Backend:**
```bash
curl http://localhost:5000/health
# Should return: {"status":"healthy",...}
```

**Test Frontend:**
```bash
curl http://localhost:3000
# Should return HTML
```

**Open in Browser:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000/health

---

### Step 10: Test Notes App Functionality

**Objective:** Verify complete Notes App works

**Test Flow:**
1. Open http://localhost:3000
2. Register a new user
3. Login with credentials
4. Create a note
5. View notes list
6. Verify note is saved in database

**Check Database:**
```bash
docker-compose exec db psql -U notesuser -d notesapp -c "SELECT * FROM users;"
docker-compose exec db psql -U notesuser -d notesapp -c "SELECT * FROM notes;"
```

---

## Notes App Specifics

### Service Communication

**Frontend → Backend:**
- Browser makes requests to `http://localhost:5000` (from host)
- Server-side rendering uses `http://backend:5000` (from container)

**Backend → Database:**
- Uses service name: `db:5432` (PostgreSQL) or `db:27017` (MongoDB)
- Docker DNS resolves service names automatically

### Environment Variables

**Database Connection String:**
- PostgreSQL: `postgresql://user:password@db:5432/dbname`
- MongoDB: `mongodb://user:password@db:27017/dbname?authSource=admin`

**Frontend API URL:**
- For browser: `http://localhost:5000` (accessible from host)
- For SSR: `http://backend:5000` (internal container communication)

### Data Persistence

**Database Data:**
- Stored in named volume: `postgres_data` or `mongo_data`
- Persists across container restarts
- Survives `docker-compose down`
- Removed only with `docker-compose down -v`

---

## Verification

### How to Verify the Task is Complete

**1. All Services Running:**
```bash
docker-compose ps
# All services should show "Up (healthy)"
```

**2. Services Accessible:**
- Frontend: http://localhost:3000 loads
- Backend: http://localhost:5000/health returns healthy
- Database: Can connect via docker-compose exec

**3. Services Communicate:**
- Frontend can call backend API
- Backend can connect to database
- Database has persistent storage

**4. Notes App Works:**
- Can register user
- Can login
- Can create notes
- Notes persist after container restart

**5. Data Persists:**
```bash
docker-compose down
docker-compose up -d
# Data should still be there
```

---

## Troubleshooting

### Issue 1: Services Can't Connect

**Symptoms:**
- Backend can't connect to database
- Frontend can't reach backend

**Causes:**
- Services not on same network
- Wrong service names in connection strings
- Services starting before dependencies ready

**Solutions:**
1. Verify all services on same network:
   ```bash
   docker network inspect notes-app-network
   ```

2. Use service names (not localhost) for container-to-container:
   ```yaml
   DATABASE_URL: postgresql://user:pass@db:5432/dbname
   ```

3. Use `depends_on` with health checks:
   ```yaml
   depends_on:
     db:
       condition: service_healthy
   ```

---

### Issue 2: Port Already in Use

**Symptoms:**
```
Error: bind: address already in use
```

**Causes:**
- Port already used by another process
- Previous containers still running

**Solutions:**
1. Find and stop process:
   ```bash
   lsof -i :3000
   lsof -i :5000
   ```

2. Stop all compose services:
   ```bash
   docker-compose down
   ```

3. Change ports in docker-compose.yml:
   ```yaml
   ports:
     - "3001:3000"  # Host:Container
   ```

---

### Issue 3: Database Connection Fails

**Symptoms:**
```
Error: connect ECONNREFUSED db:5432
```

**Causes:**
- Database not ready when backend starts
- Wrong connection string
- Network not configured

**Solutions:**
1. Add health check and dependency:
   ```yaml
   depends_on:
     db:
       condition: service_healthy
   ```

2. Verify connection string uses service name:
   ```yaml
   DATABASE_URL: postgresql://user:pass@db:5432/dbname
   ```

3. Check database logs:
   ```bash
   docker-compose logs db
   ```

---

### Issue 4: Data Lost After Restart

**Symptoms:**
- Database empty after `docker-compose down` and `up`

**Causes:**
- Volume not configured
- Using `docker-compose down -v` (removes volumes)

**Solutions:**
1. Verify volume in docker-compose.yml:
   ```yaml
   volumes:
     - postgres_data:/var/lib/postgresql/data
   ```

2. Don't use `-v` flag:
   ```bash
   docker-compose down  # Keeps volumes
   # NOT: docker-compose down -v  # Removes volumes
   ```

---

## Best Practices

### Security Best Practices

1. **Don't Hardcode Secrets:**
   ```yaml
   # Use .env file
   environment:
     JWT_SECRET: ${JWT_SECRET}
   ```

2. **Create .env file:**
   ```env
   JWT_SECRET=your-secret-key
   POSTGRES_PASSWORD=strong-password
   ```

3. **Add .env to .gitignore:**
   ```
   .env
   .env.local
   ```

### Performance Best Practices

1. **Use Health Checks:**
   - Ensures services start in correct order
   - Prevents connection errors

2. **Restart Policies:**
   ```yaml
   restart: unless-stopped
   ```

3. **Resource Limits (optional):**
   ```yaml
   deploy:
     resources:
       limits:
         cpus: '0.5'
         memory: 512M
   ```

### Operational Best Practices

1. **Use Named Volumes:**
   - Easier to manage
   - Better performance

2. **Version Control:**
   - Commit docker-compose.yml
   - Don't commit .env

3. **Documentation:**
   - Add comments in docker-compose.yml
   - Document required environment variables

---

## Additional Resources

### Documentation
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Compose File Reference](https://docs.docker.com/compose/compose-file/)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-004-add-nginx-reverse-proxy-container.md`
2. **Related Tasks**: 
   - Task 005: Add Environment Variables (will enhance this)
   - Task 007: Create Shared Docker Network (already done, but will learn more)
   - Task 008: Add Persistent Volumes (already done, but will learn more)

---

## Reflection Questions

1. How do Docker networks enable service communication?
2. Why are health checks important in docker-compose?
3. What's the difference between named volumes and bind mounts?
4. How does `depends_on` help manage service startup order?

---

## Task Checklist

- [ ] Created docker-compose.yml
- [ ] Configured database service
- [ ] Configured backend service
- [ ] Configured frontend service
- [ ] Configured networks
- [ ] Configured volumes
- [ ] Started all services successfully
- [ ] Verified all services are healthy
- [ ] Tested Notes App functionality
- [ ] Verified data persistence
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours]  
**Mentor Notes:** [Space for mentor feedback]

