# Task: Docker - Create Notes App Backend Dockerfile

**Related Issue:** #32 (Backend variant)  
**Prerequisites:** task-001 (Understanding Dockerfile basics)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Containerize the Notes App backend (Express API) so it can run consistently and connect to the database

---

## Learning Objectives

By the end of this task, you will be able to:

- Create a Dockerfile for Node.js/Express backend applications
- Understand production vs development dependencies
- Configure environment variables in Docker
- Optimize backend Docker images
- Connect containerized backend to database

---

## Theory Section

### What is a Backend Dockerfile?

A **backend Dockerfile** containerizes your API server (Express in this case). Unlike frontend, the backend needs:
- Database connection configuration
- Environment variables for secrets
- API endpoints exposed
- Health check endpoints
- Proper logging configuration

**Key Concepts:**

- **Production Dependencies**: Only install what's needed to run (not dev dependencies)
- **Environment Variables**: Pass configuration at runtime (database URLs, secrets)
- **Health Checks**: Endpoints to verify backend is healthy
- **Logging**: Ensure logs go to stdout/stderr for Docker logging
- **Database Connections**: Backend must connect to database (may be in separate container)

**Why This Matters for Notes App:**

The Notes App backend:
- Handles user authentication (JWT)
- Manages notes CRUD operations
- Connects to PostgreSQL/MongoDB database
- Serves REST API endpoints
- Needs environment variables for database connection, JWT secrets, etc.

**Real-World Context:**

In production:
- Backend containers scale independently
- Database connection pooling is important
- Environment variables manage configuration
- Health checks enable orchestration (Kubernetes, Docker Swarm)

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed task-001 (frontend Dockerfile)
- [ ] Notes App backend codebase available (Express application)
- [ ] Understanding of Express.js structure
- [ ] Docker installed and running
- [ ] Basic understanding of database connections

**Verify Backend Structure:**
```bash
cd backend
ls -la
# Should see: package.json, src/, server.js or index.js
```

---

## Step-by-Step Instructions

### Step 1: Understand Express Backend Structure

**Objective:** Understand what the backend needs to run

**Backend Requirements:**
1. **Dependencies**: `node_modules` (from `npm install`)
2. **Source Code**: Application code (usually in `src/` or root)
3. **Environment Variables**: Database URL, JWT secret, port, etc.
4. **Runtime**: Node.js to run Express server

**Express Backend Structure:**
```
backend/
├── src/
│   ├── routes/      # API routes
│   ├── models/      # Database models
│   ├── middleware/  # Express middleware
│   └── config/      # Configuration files
├── package.json     # Dependencies and scripts
├── server.js        # Entry point (or index.js)
└── .env.example     # Environment variable template
```

**Backend Scripts (package.json):**
- `npm start`: Runs production server
- `npm run dev`: Runs development server (with nodemon)
- `npm test`: Runs tests

---

### Step 2: Choose Base Image

**Objective:** Select appropriate Node.js base image for backend

**Same as Frontend:**
- Use `node:18-alpine` for production (small, secure)
- Or `node:18-slim` if Alpine causes issues

**For This Task:** We'll use `node:18-alpine`

**Note:** Backend typically needs fewer build tools than frontend, so Alpine works well.

---

### Step 3: Create Backend Dockerfile

**Objective:** Create Dockerfile for Notes App backend

**Location:** Create `Dockerfile` in the `backend/` directory

**Backend Dockerfile:**
```dockerfile
# Stage 1: Build (if needed) or just install dependencies
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies for building)
# If backend doesn't need build step, use: npm ci --only=production
RUN npm ci

# Copy source code
COPY . .

# If backend has TypeScript or needs compilation:
# RUN npm run build

# Stage 2: Production image
FROM node:18-alpine AS runner

WORKDIR /app

# Create non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nodejs

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application code from builder (or directly if no build step)
COPY --from=builder --chown=nodejs:nodejs /app/src ./src
COPY --from=builder --chown=nodejs:nodejs /app/server.js ./server.js
# Or if no build stage:
# COPY --chown=nodejs:nodejs . .

# Switch to non-root user
USER nodejs

# Set environment
ENV NODE_ENV=production
ENV PORT=5000

# Expose port (adjust to match your backend port)
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the application
CMD ["node", "server.js"]
```

**Simplified Version (if no build step needed):**
```dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Copy application code
COPY --chown=node:node . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs

ENV NODE_ENV=production
ENV PORT=5000

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD node -e "require('http').get('http://localhost:5000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

CMD ["node", "server.js"]
```

**Create the File:**
```bash
cd backend
touch Dockerfile
```

---

### Step 4: Create .dockerignore for Backend

**Objective:** Exclude unnecessary files from backend build

**Create `.dockerignore` in `backend/` directory:**
```
# Dependencies
node_modules
npm-debug.log*

# Environment files
.env
.env.local
.env*.local

# IDE files
.vscode
.idea
*.swp
*.swo

# Git
.git
.gitignore

# OS files
.DS_Store
Thumbs.db

# Testing
coverage
.nyc_output
test/
tests/
*.test.js
*.spec.js

# Logs
logs/
*.log

# Misc
*.md
README.md
.dockerignore
Dockerfile
```

---

### Step 5: Add Health Check Endpoint

**Objective:** Create health check endpoint for Docker healthcheck

**Add to backend (server.js or routes):**
```javascript
// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});
```

**Or more comprehensive:**
```javascript
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    await db.authenticate(); // or your DB connection check
    
    res.status(200).json({
      status: 'healthy',
      database: 'connected',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: error.message
    });
  }
});
```

---

### Step 6: Build Backend Docker Image

**Objective:** Build Docker image for Notes App backend

**Build Command:**
```bash
cd backend
docker build -t notes-app-backend:latest .
```

**Verify Image:**
```bash
docker images | grep notes-app-backend
```

**Expected Output:**
```
notes-app-backend   latest   def456ghi789   1 minute ago   180MB
```

---

### Step 7: Run Backend Container

**Objective:** Test backend container (without database first)

**Run Command:**
```bash
docker run -d \
  -p 5000:5000 \
  -e NODE_ENV=production \
  -e PORT=5000 \
  --name notes-app-backend \
  notes-app-backend:latest
```

**Check Status:**
```bash
docker ps | grep notes-app-backend
docker logs notes-app-backend
```

**Test Health Endpoint:**
```bash
curl http://localhost:5000/health
```

**Expected Response:**
```json
{"status":"healthy","timestamp":"2025-01-15T10:30:00.000Z"}
```

---

### Step 8: Configure Environment Variables

**Objective:** Pass environment variables to container

**Create `.env` file (for reference, not copied to container):**
```env
NODE_ENV=production
PORT=5000
DATABASE_URL=postgresql://user:password@db:5432/notesapp
JWT_SECRET=your-secret-key-here
JWT_EXPIRES_IN=7d
```

**Run with Environment Variables:**
```bash
docker run -d \
  -p 5000:5000 \
  -e NODE_ENV=production \
  -e PORT=5000 \
  -e DATABASE_URL=postgresql://user:password@host.docker.internal:5432/notesapp \
  -e JWT_SECRET=your-secret-key \
  --name notes-app-backend \
  notes-app-backend:latest
```

**Or use .env file:**
```bash
docker run -d \
  -p 5000:5000 \
  --env-file .env \
  --name notes-app-backend \
  notes-app-backend:latest
```

**Note:** Database connection will be configured in Docker Compose (next task).

---

### Step 9: Test Backend API

**Objective:** Verify backend API works

**Test Endpoints:**
```bash
# Health check
curl http://localhost:5000/health

# API endpoint (if available)
curl http://localhost:5000/api/notes

# Should return appropriate response or error (if DB not connected)
```

**Check Logs:**
```bash
docker logs notes-app-backend
# Should show Express server started
# May show database connection errors (expected if DB not running)
```

**Stop Container:**
```bash
docker stop notes-app-backend
docker rm notes-app-backend
```

---

## Notes App Specifics

### Backend Structure

The Notes App backend is an Express API with:
- **Routes**: `/api/auth/*` (login, signup), `/api/notes/*` (CRUD)
- **Middleware**: JWT authentication, error handling
- **Database**: PostgreSQL or MongoDB connection
- **Models**: User model, Note model

### Environment Variables Needed

**Required:**
- `DATABASE_URL`: Database connection string
- `JWT_SECRET`: Secret for JWT token signing
- `PORT`: Server port (default 5000)
- `NODE_ENV`: Environment (production, development)

**Optional:**
- `JWT_EXPIRES_IN`: Token expiration (default: 7d)
- `CORS_ORIGIN`: Allowed CORS origins
- `LOG_LEVEL`: Logging level

### Database Connection

The backend connects to database. In Docker:
- Database may be in separate container
- Use service name for connection (e.g., `db:5432`)
- Connection string format: `postgresql://user:password@db:5432/dbname`

### API Endpoints

**Authentication:**
- `POST /api/auth/signup` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout

**Notes:**
- `GET /api/notes` - Get all notes (authenticated)
- `POST /api/notes` - Create note (authenticated)
- `GET /api/notes/:id` - Get note by ID (authenticated)
- `PUT /api/notes/:id` - Update note (authenticated)
- `DELETE /api/notes/:id` - Delete note (authenticated)

---

## Verification

### How to Verify the Task is Complete

**1. Image Built:**
```bash
docker images notes-app-backend
# Should show the image
```

**2. Container Runs:**
```bash
docker run -d -p 5000:5000 --name test-backend notes-app-backend:latest
docker ps | grep test-backend
# Should show running container
```

**3. Health Check Works:**
```bash
curl http://localhost:5000/health
# Should return: {"status":"healthy",...}
```

**4. Logs Show Server Started:**
```bash
docker logs test-backend
# Should show: "Server running on port 5000" or similar
```

**5. API Responds:**
```bash
curl http://localhost:5000/api/notes
# May show error (DB not connected) but should respond
```

**Cleanup:**
```bash
docker stop test-backend
docker rm test-backend
```

---

## Troubleshooting

### Issue 1: "Cannot find module" Error

**Symptoms:**
```
Error: Cannot find module 'express'
```

**Causes:**
- node_modules not installed
- Using `--only=production` but missing dependencies
- Package.json out of sync

**Solutions:**
1. Check package.json has all dependencies
2. Use `npm ci` instead of `npm install`
3. Verify .dockerignore doesn't exclude node_modules incorrectly

---

### Issue 2: Database Connection Fails

**Symptoms:**
```
Error: connect ECONNREFUSED
```

**Causes:**
- Database not running
- Wrong connection string
- Network not configured

**Solutions:**
1. Verify database is running
2. Check DATABASE_URL environment variable
3. Use service name in Docker network (e.g., `db:5432`)

**Note:** This is expected if running backend alone. Will be fixed in Docker Compose task.

---

### Issue 3: Port Already in Use

**Symptoms:**
```
Error: listen EADDRINUSE: address already in use :::5000
```

**Causes:**
- Port 5000 already used by another process
- Previous container still running

**Solutions:**
1. Find and stop process using port:
   ```bash
   lsof -i :5000
   kill -9 <PID>
   ```

2. Or use different port:
   ```bash
   docker run -p 5001:5000 ...
   ```

---

### Issue 4: Health Check Fails

**Symptoms:**
```
HEALTHCHECK unhealthy
```

**Causes:**
- Health endpoint not implemented
- Wrong health check command
- Application not responding

**Solutions:**
1. Verify `/health` endpoint exists
2. Test manually: `curl http://localhost:5000/health`
3. Adjust health check command in Dockerfile

---

## Best Practices

### Security Best Practices

1. **Non-root User:**
   ```dockerfile
   RUN adduser -S nodejs -u 1001
   USER nodejs
   ```

2. **Don't Copy .env:**
   - Use .dockerignore
   - Pass secrets as environment variables at runtime

3. **Minimal Base Image:**
   - Use Alpine for smaller attack surface

4. **Production Dependencies Only:**
   ```dockerfile
   RUN npm ci --only=production
   ```

### Performance Best Practices

1. **Layer Caching:**
   - Copy package.json first
   - Install dependencies
   - Then copy code

2. **Multi-stage Build:**
   - Separate build and runtime stages
   - Only copy necessary files

3. **Clean npm Cache:**
   ```dockerfile
   RUN npm ci --only=production && npm cache clean --force
   ```

### Operational Best Practices

1. **Health Checks:**
   ```dockerfile
   HEALTHCHECK --interval=30s --timeout=3s \
     CMD node -e "..."
   ```

2. **Logging:**
   - Log to stdout/stderr
   - Use structured logging (JSON)

3. **Environment Variables:**
   - Document required variables
   - Use .env.example as template

---

## Additional Resources

### Documentation
- [Express.js Documentation](https://expressjs.com/)
- [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)
- [Docker Health Checks](https://docs.docker.com/engine/reference/builder/#healthcheck)

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-003-create-docker-compose-for-notes-app.md` (will connect backend to database)
2. **Related Tasks**: 
   - Task 005: Add Environment Variables (will enhance this)
   - Task 006: Add Docker Healthchecks (will improve this)
3. **Future Learning**: 
   - Learn about Docker networking (Task 007)
   - Learn about container logging (Task 009)

---

## Reflection Questions

1. What's the difference between production and development dependencies?
2. Why is it important to run containers as non-root users?
3. How do health checks help with container orchestration?
4. What environment variables does your backend need?

---

## Task Checklist

- [ ] Read and understood the theory section
- [ ] Created backend Dockerfile
- [ ] Created .dockerignore for backend
- [ ] Added health check endpoint
- [ ] Built Docker image successfully
- [ ] Ran container and verified it works
- [ ] Tested health endpoint
- [ ] Configured environment variables
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours]  
**Mentor Notes:** [Space for mentor feedback]

