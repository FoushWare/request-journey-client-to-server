# Task: Microservices - Service Discovery in Kubernetes

**Related Issue:** #136 (Service Discovery)  
**Prerequisites:** task-001 (Microservices architecture), Kubernetes basics  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Implement service discovery in Kubernetes so Notes App microservices can locate and communicate with each other reliably using DNS-based discovery

---

## Learning Objectives

- Understand service discovery concepts
- Use Kubernetes Services for discovery
- Configure DNS-based service discovery
- Implement service-to-service communication
- Understand headless services

---

## Theory Section

### Service Discovery in Kubernetes

**Why Service Discovery:**
- Pods have dynamic IPs
- Services need to find each other
- DNS provides stable names

**Kubernetes Service Discovery:**
- Services provide stable DNS names
- Format: `<service-name>.<namespace>.svc.cluster.local`
- Automatic DNS resolution

---

## Step-by-Step Instructions

### Step 1: Understand Service Discovery

**Objective:** Learn DNS-based discovery

**Instructions:**
1. Learn how Kubernetes Services work
2. Understand DNS resolution
3. Review service selectors

### Step 2: Create Kubernetes Services

**Objective:** Expose services via DNS

**Instructions:**
1. Create Service for auth-service
2. Create Service for notes-service
3. Create Service for user-service
4. Verify DNS names

### Step 3: Configure Service Communication

**Objective:** Enable services to find each other

**Instructions:**
1. Use service names in code: `http://auth-service:3001`
2. Test DNS resolution
3. Verify service-to-service calls

### Step 4: Test Service Discovery

**Objective:** Verify discovery works

**Instructions:**
1. Test from pod: `nslookup auth-service`
2. Test service calls
3. Verify communication

---

## Verification

1. Services have DNS names
2. Services can resolve each other
3. Service-to-service communication works

---

## Task Checklist

- [ ] Understood service discovery
- [ ] Created Kubernetes Services
- [ ] Configured service communication
- [ ] Tested discovery

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

