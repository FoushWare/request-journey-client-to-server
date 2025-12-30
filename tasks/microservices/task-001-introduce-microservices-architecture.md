# Task: Microservices - Introduce Microservices Architecture

**Related Issue:** #134  
**Prerequisites:** task-001 through task-010 (Kubernetes basics), Docker knowledge, networking basics  
**Estimated Time:** 6-8 hours  
**Notes App Context:** Refactor the monolithic Notes App backend into a microservices-based architecture with separate services for authentication, notes, and users, improving scalability and maintainability

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand microservices architecture and when to use it
- Identify service boundaries for Notes App
- Create separate microservices (Auth, Notes, Users)
- Implement inter-service communication (gRPC/REST)
- Set up API Gateway (NGINX)
- Deploy microservices to Kubernetes
- Understand microservices vs monolith trade-offs

---

## Theory Section

### What are Microservices?

**Microservices** is an architectural approach where applications are built as a collection of small, independent services that:
- Communicate over well-defined APIs
- Own their data
- Are deployed independently
- Can be developed by different teams
- Use different technologies if needed

**Why Microservices for Notes App:**

**Current Monolith:**
- Single backend handles everything
- All features in one codebase
- Single database
- Deploy everything together

**Microservices Architecture:**
- **Auth Service**: Handles authentication and authorization
- **Notes Service**: Manages notes CRUD operations
- **User Service**: Manages user profiles
- Each service independent
- Each service has its own database

**Benefits:**
- **Scalability**: Scale services independently
- **Maintainability**: Smaller, focused codebases
- **Technology Flexibility**: Use different tech per service
- **Fault Isolation**: One service failure doesn't break all
- **Team Autonomy**: Teams work independently

**Challenges:**
- **Complexity**: More moving parts
- **Network Latency**: Service-to-service calls
- **Data Consistency**: Distributed data challenges
- **Deployment**: More services to deploy

**Key Concepts:**
- **Service Boundaries**: How to split functionality
- **Inter-Service Communication**: gRPC, REST, messaging
- **API Gateway**: Single entry point
- **Service Discovery**: Finding services
- **Data Isolation**: Database per service

---

## Prerequisites Check

Before starting, ensure you have:

- [ ] Completed Kubernetes tasks (task-001 through task-010)
- [ ] Notes App monolith working
- [ ] Understanding of REST APIs
- [ ] Basic gRPC knowledge (helpful)
- [ ] Docker and Kubernetes experience

**Verify Prerequisites:**
```bash
kubectl cluster-info
docker --version
# Verify Notes App monolith works
```

---

## Step-by-Step Instructions

### Step 1: Define Microservice Boundaries

**Objective:** Identify how to split Notes App into services

**Instructions:**

1. **Analyze current monolith:**
   - List all features
   - Identify data domains
   - Find service boundaries

2. **Define services for Notes App:**
   - **Auth Service**: Login, registration, JWT tokens
   - **Notes Service**: Create, read, update, delete notes
   - **User Service**: User profiles, user management

3. **Document service boundaries:**
```markdown
## Service Boundaries

### Auth Service
- Owns: Authentication, authorization, JWT tokens
- Data: Users table (auth-related fields only)
- APIs: /auth/login, /auth/register, /auth/validate

### Notes Service
- Owns: Notes CRUD operations
- Data: Notes table
- APIs: /notes/create, /notes/list, /notes/update, /notes/delete

### User Service
- Owns: User profiles, user information
- Data: Users table (profile fields)
- APIs: /users/profile, /users/update
```

4. **Create service ownership document**

---

### Step 2: Create Service Structure

**Objective:** Set up directory structure for microservices

**Instructions:**

1. **Create services directory:**
```bash
mkdir -p services/{auth-service,notes-service,user-service}
```

2. **Create structure for each service:**
```
services/auth-service/
├── src/
│   ├── server.js
│   ├── routes/
│   ├── controllers/
│   └── models/
├── Dockerfile
├── package.json
└── .env.example

services/notes-service/
├── src/
│   ├── server.js
│   ├── routes/
│   ├── controllers/
│   └── models/
├── Dockerfile
├── package.json
└── .env.example

services/user-service/
├── src/
│   ├── server.js
│   ├── routes/
│   ├── controllers/
│   └── models/
├── Dockerfile
├── package.json
└── .env.example
```

3. **Initialize each service:**
```bash
cd services/auth-service
npm init -y
npm install express jsonwebtoken bcryptjs
# Repeat for other services
```

---

### Step 3: Implement Auth Service

**Objective:** Create authentication microservice

**Instructions:**

1. **Create `services/auth-service/src/server.js`:**
```javascript
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const app = express();

app.use(express.json());

// Login endpoint
app.post('/auth/login', async (req, res) => {
  // Implementation
});

// Register endpoint
app.post('/auth/register', async (req, res) => {
  // Implementation
});

// Validate token endpoint
app.post('/auth/validate', (req, res) => {
  // Implementation
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Auth Service running on port ${PORT}`);
});
```

2. **Create Dockerfile:**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3001
CMD ["node", "src/server.js"]
```

3. **Test locally:**
```bash
npm start
curl http://localhost:3001/auth/login
```

---

### Step 4: Implement Notes Service

**Objective:** Create notes management microservice

**Instructions:**

1. **Create Notes Service similar to Auth Service**

2. **Implement endpoints:**
   - POST /notes/create
   - GET /notes/list
   - PUT /notes/:id
   - DELETE /notes/:id

3. **Add database connection:**
   - Connect to notes_db
   - Implement CRUD operations

---

### Step 5: Implement User Service

**Objective:** Create user management microservice

**Instructions:**

1. **Create User Service**

2. **Implement endpoints:**
   - GET /users/profile/:userId
   - PUT /users/profile/:userId

---

### Step 6: Set Up Inter-Service Communication

**Objective:** Enable services to communicate

**Instructions:**

1. **Option A: REST Communication:**
   - Services call each other via HTTP
   - Use service names in Kubernetes
   - Example: `http://auth-service:3001/auth/validate`

2. **Option B: gRPC Communication (Advanced):**
   - Define .proto files
   - Implement gRPC servers
   - Use gRPC clients

3. **For Notes App, start with REST:**
```javascript
// In notes-service, call auth-service
const axios = require('axios');

async function validateToken(token) {
  const response = await axios.post(
    'http://auth-service:3001/auth/validate',
    { token }
  );
  return response.data;
}
```

---

### Step 7: Configure NGINX as API Gateway

**Objective:** Set up single entry point

**Instructions:**

1. **Create NGINX configuration:**
```nginx
upstream auth_service {
    server auth-service:3001;
}

upstream notes_service {
    server notes-service:3002;
}

upstream user_service {
    server user-service:3003;
}

server {
    listen 80;
    
    location /auth/ {
        proxy_pass http://auth_service/;
    }
    
    location /notes/ {
        proxy_pass http://notes_service/;
    }
    
    location /users/ {
        proxy_pass http://user_service/;
    }
}
```

2. **Deploy NGINX as API Gateway**

---

### Step 8: Deploy to Kubernetes

**Objective:** Deploy all microservices to Kubernetes

**Instructions:**

1. **Create Deployments for each service:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auth-service
  namespace: notes-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: auth-service
  template:
    metadata:
      labels:
        app: auth-service
    spec:
      containers:
      - name: auth-service
        image: notes-app-auth:latest
        ports:
        - containerPort: 3001
```

2. **Create Services:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: auth-service
  namespace: notes-app
spec:
  selector:
    app: auth-service
  ports:
  - port: 3001
    targetPort: 3001
  type: ClusterIP
```

3. **Deploy all services:**
```bash
kubectl apply -f services/auth-service/k8s/
kubectl apply -f services/notes-service/k8s/
kubectl apply -f services/user-service/k8s/
```

---

## Notes App Specifics

### How This Applies to Notes App

**Service Split:**
- **Auth Service**: Handles login, register, token validation
- **Notes Service**: Handles all note operations
- **User Service**: Handles user profiles

**Communication:**
- Frontend → API Gateway → Services
- Services communicate via REST (or gRPC)
- Each service has own database

**Deployment:**
- Each service deployed independently
- Can scale services separately
- Services discover each other via Kubernetes DNS

---

## Verification

### How to Verify the Task is Complete

**Functional Verification:**
1. Three separate services created
2. Each service runs independently
3. Services can communicate
4. API Gateway routes requests correctly
5. Notes App functionality works with microservices

**Technical Verification:**
1. Services deployed to Kubernetes
2. Each service has own Deployment and Service
3. API Gateway configured
4. Services accessible via service names

**Commands to Run:**
```bash
# Check services
kubectl get pods -n notes-app
kubectl get svc -n notes-app

# Test service communication
kubectl exec -n notes-app <pod-name> -- curl http://auth-service:3001/health
```

**Expected Results:**
- Three microservices running
- API Gateway routing correctly
- Notes App works with microservices
- Services can communicate

---

## Troubleshooting

### Common Issues and Solutions

**Issue 1: Services Cannot Communicate**

**Symptoms:**
- Service calls fail
- Connection refused errors

**Solutions:**
1. Verify Kubernetes Services exist
2. Check service names match
3. Verify network policies allow communication
4. Test DNS resolution: `nslookup auth-service`

---

**Issue 2: API Gateway Not Routing**

**Symptoms:**
- Requests not reaching services
- 502 errors

**Solutions:**
1. Check NGINX configuration
2. Verify upstream services are accessible
3. Check service endpoints
4. Review NGINX logs

---

## Best Practices

### Architecture Best Practices
- Keep services focused (single responsibility)
- Use API Gateway for external access
- Implement proper error handling
- Use service discovery

### Communication Best Practices
- Use REST for simplicity initially
- Consider gRPC for performance
- Implement retries and timeouts
- Handle service failures gracefully

---

## Additional Resources

### Documentation
- [Microservices Patterns](https://microservices.io/patterns/)
- [gRPC Documentation](https://grpc.io/docs/)

---

## Next Steps

1. **Immediate Next Task**: `task-002-microservices-database-design.md` - Database strategy
2. **Related Tasks**: Service discovery, resilience patterns

---

## Task Checklist

- [ ] Defined service boundaries
- [ ] Created service structure
- [ ] Implemented Auth Service
- [ ] Implemented Notes Service
- [ ] Implemented User Service
- [ ] Set up inter-service communication
- [ ] Configured API Gateway
- [ ] Deployed to Kubernetes
- [ ] Verified functionality
- [ ] Ready to move to next task

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

