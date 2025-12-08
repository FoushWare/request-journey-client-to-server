# Task: Docker - Create Notes App Frontend Dockerfile

**Related Issue:** #32  
**Prerequisites:** None (This is the first Docker task)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Containerize the Notes App frontend (Next.js) so it can run consistently across different environments

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand what Dockerfiles are and how they work
- Create a multi-stage Dockerfile for Next.js applications
- Optimize Docker images for production use
- Use .dockerignore to reduce build context size
- Build and run Docker containers for the Notes App frontend

---

## Theory Section

### What is a Dockerfile?

A **Dockerfile** is a text file that contains instructions for building a Docker image. Think of it as a recipe that tells Docker:
- What base image to start from
- What files to copy
- What commands to run
- What ports to expose
- What environment variables to set

**Key Concepts:**

- **Base Image**: The starting point (e.g., `node:18-alpine`). Contains the operating system and runtime.
- **Layers**: Each instruction in a Dockerfile creates a layer. Layers are cached, so unchanged layers don't need to be rebuilt.
- **Build Context**: The directory and files sent to Docker when building. Use `.dockerignore` to exclude unnecessary files.
- **Multi-stage Builds**: Use multiple stages to keep final image small. Build in one stage, copy only what's needed to final stage.
- **Layer Caching**: Docker caches layers. Order instructions from least to most frequently changing to maximize cache hits.

**Why This Matters for Notes App:**

The Notes App frontend is a Next.js application that needs:
- Node.js runtime to build and run
- Dependencies installed (`npm install`)
- Application built (`npm run build`)
- Production server running (`npm start`)

A Dockerfile ensures the frontend runs the same way on your laptop, CI/CD server, and production servers.

**Real-World Context:**

In production, Dockerfiles enable:
- Consistent deployments across environments
- Easy scaling (run multiple containers)
- Version control for your application environment
- Isolation from host system

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Notes App frontend codebase available (Next.js application)
- [ ] Docker installed and running (verify with `docker --version`)
- [ ] Basic understanding of Next.js build process
- [ ] Terminal/command line access

**Verify Docker Installation:**
```bash
docker --version
# Should show: Docker version 20.x.x or higher

docker ps
# Should show running containers (may be empty, that's OK)
```

---

## Step-by-Step Instructions

### Step 1: Understand Next.js Build Process

**Objective:** Understand what Next.js needs to build and run

**What Next.js Needs:**
1. **Dependencies**: `node_modules` folder (from `npm install`)
2. **Build Output**: `.next` folder (from `npm run build`)
3. **Static Files**: `public` folder (images, fonts, etc.)
4. **Runtime**: Node.js to run the production server

**Next.js Build Commands:**
- `npm install`: Installs dependencies
- `npm run build`: Creates optimized production build
- `npm start`: Runs production server (default port 3000)

**Notes App Frontend Structure:**
```
frontend/
├── pages/          # Next.js pages
├── components/     # React components
├── public/         # Static assets
├── package.json    # Dependencies and scripts
└── next.config.js  # Next.js configuration
```

---

### Step 2: Choose Base Image

**Objective:** Select appropriate Node.js base image

**Image Options:**

1. **`node:18`** (Full image)
   - Pros: Complete, includes all tools
   - Cons: Large (~900MB), slower downloads

2. **`node:18-alpine`** (Alpine Linux - Recommended)
   - Pros: Small (~170MB), secure, fast
   - Cons: May need additional packages for some tools

3. **`node:18-slim`** (Debian slim)
   - Pros: Smaller than full, more packages than Alpine
   - Cons: Medium size (~200MB)

**Recommendation:** Use `node:18-alpine` for production - it's small and secure.

**For This Task:** We'll use `node:18-alpine` as the base image.

---

### Step 3: Create Basic Dockerfile

**Objective:** Create initial Dockerfile for Notes App frontend

**Location:** Create `Dockerfile` in the `frontend/` directory

**Basic Dockerfile Structure:**
```dockerfile
# Stage 1: Build the application
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production=false

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production image
FROM node:18-alpine AS runner

WORKDIR /app

# Copy built application from builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules

# Set environment to production
ENV NODE_ENV=production

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
```

**Create the File:**
```bash
cd frontend
touch Dockerfile
# Or create it in your editor
```

**Explanation of Each Instruction:**

- `FROM node:18-alpine AS builder`: Start with Node.js Alpine image, name this stage "builder"
- `WORKDIR /app`: Set working directory inside container
- `COPY package*.json ./`: Copy package files (for dependency installation)
- `RUN npm ci`: Install dependencies (faster and more reliable than `npm install`)
- `COPY . .`: Copy all application code
- `RUN npm run build`: Build Next.js application
- `FROM node:18-alpine AS runner`: Start new stage for production
- `COPY --from=builder`: Copy only necessary files from builder stage
- `EXPOSE 3000`: Document that container listens on port 3000
- `CMD ["npm", "start"]`: Command to run when container starts

---

### Step 4: Create .dockerignore File

**Objective:** Exclude unnecessary files from build context

**Why .dockerignore Matters:**
- Reduces build context size (faster builds)
- Prevents copying sensitive files
- Avoids copying build artifacts
- Excludes node_modules (will be installed in container)

**Create `.dockerignore` in `frontend/` directory:**
```
# Dependencies
node_modules
npm-debug.log*

# Build output
.next
out
dist

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

# Misc
*.log
*.md
```

**Verify .dockerignore:**
```bash
# Check what will be sent to Docker
docker build --no-cache -t test-image . 2>&1 | grep "Sending build context"
```

---

### Step 5: Build Notes App Frontend Image

**Objective:** Build Docker image for Notes App frontend

**Build Command:**
```bash
cd frontend
docker build -t notes-app-frontend:latest .
```

**Command Breakdown:**
- `docker build`: Build command
- `-t notes-app-frontend:latest`: Tag the image with name and version
- `.`: Build context (current directory)

**Expected Output:**
```
[+] Building 45.2s (15/15) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load .dockerignore
 => [internal] load metadata for docker.io/library/node:18-alpine
 => [builder 1/6] FROM docker.io/library/node:18-alpine
 => [builder 2/6] WORKDIR /app
 => [builder 3/6] COPY package*.json ./
 => [builder 4/6] RUN npm ci --only=production=false
 => [builder 5/6] COPY . .
 => [builder 6/6] RUN npm run build
 => [runner 1/6] FROM docker.io/library/node:18-alpine
 => [runner 2/6] WORKDIR /app
 => [runner 3/6] COPY --from=builder /app/.next ./.next
 => [runner 4/6] COPY --from=builder /app/public ./public
 => [runner 5/6] COPY --from=builder /app/package*.json ./
 => [runner 6/6] COPY --from=builder /app/node_modules ./node_modules
 => exporting to image
 => => exporting layers
 => => writing image sha256:...
 => => naming to docker.io/library/notes-app-frontend:latest
```

**Verify Image Created:**
```bash
docker images | grep notes-app-frontend
```

**Expected Output:**
```
notes-app-frontend   latest   abc123def456   2 minutes ago   250MB
```

---

### Step 6: Run Notes App Frontend Container

**Objective:** Test the container by running it

**Run Command:**
```bash
docker run -d -p 3000:3000 --name notes-app-frontend notes-app-frontend:latest
```

**Command Breakdown:**
- `docker run`: Run a container
- `-d`: Run in detached mode (background)
- `-p 3000:3000`: Map host port 3000 to container port 3000
- `--name notes-app-frontend`: Name the container
- `notes-app-frontend:latest`: Image to run

**Check Container Status:**
```bash
docker ps
```

**Expected Output:**
```
CONTAINER ID   IMAGE                      STATUS         PORTS                    NAMES
abc123def456   notes-app-frontend:latest  Up 2 minutes   0.0.0.0:3000->3000/tcp  notes-app-frontend
```

**View Container Logs:**
```bash
docker logs notes-app-frontend
```

**Expected Output:**
```
> notes-app@1.0.0 start
> next start

- ready started server on 0.0.0.0:3000
- info Loaded env from .env.production
```

---

### Step 7: Test Notes App Functionality

**Objective:** Verify Notes App frontend works in container

**Test in Browser:**
1. Open browser: `http://localhost:3000`
2. Verify Notes App loads
3. Test login functionality
4. Test creating a note
5. Test viewing notes

**Test with curl:**
```bash
curl http://localhost:3000
# Should return HTML content
```

**Check Container Health:**
```bash
docker exec notes-app-frontend ps aux
# Should show Node.js process running
```

**Stop Container:**
```bash
docker stop notes-app-frontend
docker rm notes-app-frontend
```

---

### Step 8: Optimize Dockerfile

**Objective:** Improve Dockerfile for better caching and smaller image

**Optimized Dockerfile:**
```dockerfile
# Stage 1: Build the application
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files first (for better layer caching)
COPY package*.json ./

# Install dependencies (this layer will be cached if package.json doesn't change)
RUN npm ci --only=production=false

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Production image
FROM node:18-alpine AS runner

WORKDIR /app

# Don't run as root (security best practice)
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy only necessary files
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Switch to non-root user
USER nextjs

# Set environment
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
```

**Key Optimizations:**
1. **Layer Caching**: Copy package.json first, install dependencies, then copy code
2. **Non-root User**: Run as non-root user for security
3. **Standalone Build**: Use Next.js standalone output (smaller, faster)
4. **Proper Ownership**: Set file ownership correctly

**Note:** For standalone build, update `next.config.js`:
```javascript
module.exports = {
  output: 'standalone',
}
```

**Rebuild with Optimizations:**
```bash
docker build -t notes-app-frontend:optimized .
docker images | grep notes-app-frontend
# Compare sizes
```

---

## Notes App Specifics

### Frontend Structure

The Notes App frontend is a Next.js application with:
- **Pages**: Login, Dashboard (notes list), Create Note, View Note
- **Components**: Reusable React components
- **API Routes**: Next.js API routes for frontend API calls
- **Authentication**: JWT token handling in frontend

### Environment Variables Needed

The frontend may need:
- `NEXT_PUBLIC_API_URL`: Backend API URL
- `NEXT_PUBLIC_APP_NAME`: Application name

**Add to Dockerfile:**
```dockerfile
ENV NEXT_PUBLIC_API_URL=http://backend:5000
ENV NEXT_PUBLIC_APP_NAME="Notes App"
```

Or pass at runtime:
```bash
docker run -d -p 3000:3000 \
  -e NEXT_PUBLIC_API_URL=http://localhost:5000 \
  --name notes-app-frontend \
  notes-app-frontend:latest
```

### Build Configuration

Ensure `next.config.js` is configured for production:
```javascript
module.exports = {
  reactStrictMode: true,
  swcMinify: true, // Use SWC for faster builds
  output: 'standalone', // For optimized Docker builds
}
```

---

## Verification

### How to Verify the Task is Complete

**1. Image Built Successfully:**
```bash
docker images notes-app-frontend
# Should show the image
```

**2. Container Runs:**
```bash
docker run -d -p 3000:3000 --name test-frontend notes-app-frontend:latest
docker ps | grep test-frontend
# Should show running container
```

**3. Notes App Loads:**
- Open `http://localhost:3000` in browser
- Should see Notes App login page

**4. Functionality Works:**
- Login works (if backend connected)
- Can navigate pages
- No console errors

**5. Logs Are Clean:**
```bash
docker logs test-frontend
# Should show Next.js server started, no errors
```

**6. Image Size is Reasonable:**
```bash
docker images notes-app-frontend
# Should be under 300MB for optimized build
```

**Cleanup:**
```bash
docker stop test-frontend
docker rm test-frontend
```

---

## Troubleshooting

### Issue 1: Build Fails with "npm ci" Error

**Symptoms:**
```
npm ERR! cipm can only install packages when your package.json and package-lock.json are in sync
```

**Causes:**
- package-lock.json is out of sync with package.json
- Missing package-lock.json

**Solutions:**
1. Regenerate package-lock.json:
   ```bash
   cd frontend
   rm package-lock.json
   npm install
   ```

2. Or use `npm install` instead of `npm ci` in Dockerfile (less strict)

**Prevention:**
- Always commit package-lock.json
- Keep package.json and package-lock.json in sync

---

### Issue 2: Container Exits Immediately

**Symptoms:**
```bash
docker ps -a
# Shows container with status "Exited"
```

**Causes:**
- Application crashes on startup
- Wrong CMD or ENTRYPOINT
- Missing environment variables
- Port conflicts

**Solutions:**
1. Check logs:
   ```bash
   docker logs notes-app-frontend
   ```

2. Run interactively to see errors:
   ```bash
   docker run -it --rm notes-app-frontend:latest sh
   # Then manually run: npm start
   ```

3. Verify CMD in Dockerfile:
   ```dockerfile
   CMD ["npm", "start"]
   # Should match package.json "start" script
   ```

**Prevention:**
- Test application locally before containerizing
- Check logs immediately after starting container

---

### Issue 3: Build is Very Slow

**Symptoms:**
- Build takes 10+ minutes
- Same layers rebuilt every time

**Causes:**
- Not using layer caching effectively
- Copying too much in build context
- Not using .dockerignore

**Solutions:**
1. Order Dockerfile instructions from least to most frequently changing
2. Use .dockerignore to exclude unnecessary files
3. Use BuildKit for faster builds:
   ```bash
   DOCKER_BUILDKIT=1 docker build -t notes-app-frontend .
   ```

**Prevention:**
- Always use .dockerignore
- Order COPY commands strategically
- Use multi-stage builds

---

### Issue 4: Image Size is Too Large

**Symptoms:**
```bash
docker images notes-app-frontend
# Shows 1GB+ image size
```

**Causes:**
- Including node_modules with dev dependencies
- Not using multi-stage builds
- Including unnecessary files

**Solutions:**
1. Use multi-stage build (copy only production files)
2. Use Alpine base image
3. Use Next.js standalone output
4. Remove dev dependencies in production:
   ```dockerfile
   RUN npm ci --only=production
   ```

**Prevention:**
- Always use multi-stage builds for production
- Use .dockerignore
- Choose smaller base images

---

### Issue 5: "Cannot find module" Error

**Symptoms:**
```
Error: Cannot find module 'next'
```

**Causes:**
- node_modules not copied correctly
- Using `--only=production` but Next.js needs dev dependencies to build
- Missing dependencies in package.json

**Solutions:**
1. Install all dependencies for build:
   ```dockerfile
   RUN npm ci --only=production=false
   ```

2. For production stage, copy node_modules:
   ```dockerfile
   COPY --from=builder /app/node_modules ./node_modules
   ```

3. Or use Next.js standalone output (includes dependencies)

**Prevention:**
- Understand which dependencies are needed at build vs runtime
- Test build process locally first

---

## Best Practices

### Security Best Practices

1. **Use Non-root User:**
   ```dockerfile
   RUN adduser --system --uid 1001 nextjs
   USER nextjs
   ```

2. **Don't Copy Secrets:**
   - Use .dockerignore to exclude .env files
   - Pass secrets as environment variables at runtime

3. **Use Specific Base Image Tags:**
   ```dockerfile
   FROM node:18-alpine  # Not node:latest
   ```

4. **Keep Base Images Updated:**
   - Regularly update base images for security patches
   - Use `docker scan` to check for vulnerabilities

### Performance Best Practices

1. **Layer Caching:**
   - Copy package.json first
   - Install dependencies
   - Then copy application code

2. **Multi-stage Builds:**
   - Build in one stage
   - Copy only necessary files to final stage

3. **Use .dockerignore:**
   - Reduces build context size
   - Faster builds

4. **Use BuildKit:**
   ```bash
   DOCKER_BUILDKIT=1 docker build .
   ```

### Operational Best Practices

1. **Tag Images Properly:**
   ```bash
   docker build -t notes-app-frontend:v1.0.0 .
   docker build -t notes-app-frontend:latest .
   ```

2. **Document Ports:**
   ```dockerfile
   EXPOSE 3000
   ```

3. **Use Health Checks:**
   ```dockerfile
   HEALTHCHECK --interval=30s --timeout=3s \
     CMD node -e "require('http').get('http://localhost:3000', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"
   ```

4. **Log to stdout/stderr:**
   - Next.js logs to console by default (good for Docker)

---

## Additional Resources

### Documentation
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Next.js Docker Documentation](https://nextjs.org/docs/deployment#docker-image)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### Learning Resources
- [Docker Official Tutorial](https://docs.docker.com/get-started/)
- [Next.js Deployment Guide](https://nextjs.org/docs/deployment)

### Tools
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Dive](https://github.com/wagoodman/dive) - Analyze Docker image layers

---

## Next Steps

After completing this task:

1. **Immediate Next Task**: `task-002-create-notes-app-backend-dockerfile.md`
2. **Related Tasks**: 
   - Task 003: Create Docker Compose (will use this Dockerfile)
   - Task 006: Add Docker Healthchecks (will improve this Dockerfile)
3. **Future Learning**: 
   - Learn about Docker networking (Task 007)
   - Learn about Docker volumes (Task 008)
   - Learn about container logging (Task 009)

---

## Reflection Questions

Take a moment to reflect on what you learned:

1. What is the purpose of multi-stage builds in Docker?
2. How does layer caching improve build performance?
3. Why is it important to use .dockerignore?
4. What security considerations are important for Docker images?
5. How does the order of Dockerfile instructions affect caching?

**Document Your Learning:**
- Write down key concepts you learned
- Note any challenges you faced
- Document solutions you discovered
- Record questions for your mentor

---

## Task Checklist

Use this checklist to track your progress:

- [ ] Read and understood the theory section
- [ ] Completed all prerequisite checks
- [ ] Created basic Dockerfile
- [ ] Created .dockerignore file
- [ ] Built Docker image successfully
- [ ] Ran container and verified it works
- [ ] Tested Notes App functionality in container
- [ ] Optimized Dockerfile
- [ ] Verified image size is reasonable
- [ ] Reviewed troubleshooting section
- [ ] Applied best practices
- [ ] Documented learnings
- [ ] Ready to move to next task

---

## Notes

[Space for mentee to add their own notes, observations, or questions]

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed  
**Date Started:** [Date]  
**Date Completed:** [Date]  
**Time Spent:** [Hours]  
**Mentor Notes:** [Space for mentor feedback]

