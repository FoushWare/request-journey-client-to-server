# Task: HashiCorp - Consul Configuration Management

**Related Issue:** #144  
**Prerequisites:** task-011 (Install Consul)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Use Consul KV store for centralized configuration management for Notes App services

---

## Learning Objectives

- Use Consul KV store
- Store configuration in Consul
- Read configuration from services
- Update configuration dynamically

---

## Step-by-Step Instructions

### Step 1: Store Configuration

**Objective:** Put Notes App config in Consul

**Instructions:**
1. Use Consul KV API
2. Store configuration values
3. Organize by service

### Step 2: Read Configuration

**Objective:** Services read from Consul

**Instructions:**
1. Integrate Consul client
2. Read config on startup
3. Watch for changes

### Step 3: Dynamic Updates

**Objective:** Update config without restart

**Instructions:**
1. Watch Consul KV changes
2. Reload configuration
3. Test dynamic updates

---

## Verification

1. Configuration stored in Consul
2. Services reading config
3. Dynamic updates working

---

## Task Checklist

- [ ] Stored configuration
- [ ] Services reading config
- [ ] Dynamic updates working

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

