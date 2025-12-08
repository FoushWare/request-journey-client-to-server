# Task: Docker - Add Environment Variables

**Related Issue:** #35  
**Prerequisites:** task-003 (Docker Compose)  
**Estimated Time:** 1-2 hours  
**Notes App Context:** Configure environment variables for Notes App services (database URLs, JWT secrets, API URLs) using Docker environment variable handling

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand environment variables in Docker
- Use .env files with Docker Compose
- Pass environment variables to containers
- Manage secrets and configuration securely
- Use environment variables in Notes App services

---

## Theory Section

### What are Environment Variables?

**Environment variables** are key-value pairs that configure applications at runtime. They allow:
- Different configurations for dev/staging/production
- Keeping secrets out of code
- Easy configuration changes without code changes

**Why This Matters for Notes App:**

The Notes App needs:
- **Backend**: Database URL, JWT secret, port
- **Frontend**: API URL, app name
- **Database**: Credentials, database name

Using environment variables makes the app portable and secure.

---

## Prerequisites Check

- [ ] Completed task-003 (Docker Compose)
- [ ] Understanding of environment variables

---

## Step-by-Step Instructions

### Step 1: Create .env File

**Create `.env` in project root:**
```env
# Database
POSTGRES_USER=notesuser
POSTGRES_PASSWORD=notespassword
POSTGRES_DB=notesapp
DATABASE_URL=postgresql://notesuser:notespassword@db:5432/notesapp

# Backend
NODE_ENV=production
BACKEND_PORT=5000
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=7d
CORS_ORIGIN=http://localhost:3000

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:5000
NEXT_PUBLIC_APP_NAME=Notes App

# Redis (optional)
REDIS_URL=redis://redis:6379
```

**Important**: Add `.env` to `.gitignore` (already done)

### Step 2: Update docker-compose.yml

**Use env_file in services:**
```yaml
services:
  db:
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}

  backend:
    env_file:
      - .env
    environment:
      DATABASE_URL: ${DATABASE_URL}
      JWT_SECRET: ${JWT_SECRET}
      PORT: ${BACKEND_PORT}

  frontend:
    env_file:
      - .env
    environment:
      NEXT_PUBLIC_API_URL: ${NEXT_PUBLIC_API_URL}
```

### Step 3: Create .env.example

**Create `.env.example` (committed to git):**
```env
# Database
POSTGRES_USER=notesuser
POSTGRES_PASSWORD=change-me
POSTGRES_DB=notesapp
DATABASE_URL=postgresql://notesuser:change-me@db:5432/notesapp

# Backend
NODE_ENV=production
BACKEND_PORT=5000
JWT_SECRET=change-this-secret-key
JWT_EXPIRES_IN=7d
CORS_ORIGIN=http://localhost:3000

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:5000
NEXT_PUBLIC_APP_NAME=Notes App
```

### Step 4: Test Environment Variables

```bash
# Start services
docker-compose up -d

# Check backend environment
docker-compose exec backend env | grep DATABASE_URL

# Check frontend environment
docker-compose exec frontend env | grep NEXT_PUBLIC
```

### Step 5: Update Application Code

**Backend should read from environment:**
```javascript
const dbUrl = process.env.DATABASE_URL;
const jwtSecret = process.env.JWT_SECRET;
const port = process.env.PORT || 5000;
```

**Frontend should use NEXT_PUBLIC_ variables:**
```javascript
const apiUrl = process.env.NEXT_PUBLIC_API_URL;
```

---

## Notes App Specifics

- Database connection uses DATABASE_URL
- JWT authentication uses JWT_SECRET
- Frontend calls backend using NEXT_PUBLIC_API_URL
- All secrets stored in .env (not in code)

---

## Verification

- [ ] .env file created (not committed)
- [ ] .env.example created (committed)
- [ ] docker-compose.yml uses env_file
- [ ] Environment variables accessible in containers
- [ ] Notes App connects to database using env vars
- [ ] Frontend calls backend using env var URL

---

## Troubleshooting

**Issue: Variables not loading**
- Check .env file location (project root)
- Verify env_file path in docker-compose.yml
- Restart containers: `docker-compose restart`

**Issue: Undefined variables**
- Check variable names match exactly
- Verify .env file syntax (no spaces around =)
- Check for typos in variable names

---

## Best Practices

1. **Never commit .env**: Already in .gitignore
2. **Use .env.example**: Template for others
3. **Use different .env files**: .env.dev, .env.prod
4. **Validate variables**: Check required vars at startup
5. **Use secrets management**: For production, use Vault (Phase 2)

---

## Next Steps

- Task 006: Add Docker Healthchecks
- Task 009: Configure Container Logging (will enhance env var logging)
- Phase 2: Use Vault for secret management

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

