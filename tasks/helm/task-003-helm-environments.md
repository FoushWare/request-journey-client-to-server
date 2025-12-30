# Task: Helm - Multi-Environment Configuration

**Related Issue:** #139  
**Prerequisites:** task-002 (Create Helm chart)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Configure Helm to deploy Notes App to different environments (dev, staging, prod) using environment-specific values files

---

## Learning Objectives

- Create environment-specific values files
- Deploy to multiple environments
- Manage environment differences
- Use Helm for environment promotion

---

## Step-by-Step Instructions

### Step 1: Create Values Files

**Objective:** Create per-environment values

**Instructions:**
1. Create `values-dev.yaml`
2. Create `values-staging.yaml`
3. Create `values-prod.yaml`
4. Configure environment-specific settings

### Step 2: Deploy to Environments

**Objective:** Deploy using environment values

**Instructions:**
1. Deploy to dev: `helm install notes-app ./notes-app -f values-dev.yaml`
2. Deploy to staging: `helm install notes-app-staging ./notes-app -f values-staging.yaml`
3. Deploy to prod: `helm install notes-app-prod ./notes-app -f values-prod.yaml`

### Step 3: Manage Environment Differences

**Objective:** Handle environment variations

**Instructions:**
1. Different replica counts
2. Different resource limits
3. Different ingress domains
4. Different database sizes

---

## Verification

1. Values files created
2. Deployed to multiple environments
3. Environment differences configured

---

## Task Checklist

- [ ] Created values files
- [ ] Deployed to environments
- [ ] Configured environment differences

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

