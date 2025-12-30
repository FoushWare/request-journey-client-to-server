# Task: HashiCorp - Nomad Job Scheduling

**Related Issue:** #144  
**Prerequisites:** task-014 (Install Nomad)  
**Estimated Time:** 2-3 hours  
**Notes App Context:** Learn Nomad job scheduling, resource allocation, and deployment strategies for Notes App

---

## Learning Objectives

- Create Nomad job specifications
- Schedule container workloads
- Configure resource constraints
- Handle job updates and scaling

---

## Step-by-Step Instructions

### Step 1: Create Job Spec

**Objective:** Define Notes App job

**Instructions:**
1. Create job file (HCL format)
2. Define task groups
3. Configure resources

### Step 2: Deploy Job

**Objective:** Run job on Nomad

**Instructions:**
1. Submit job: `nomad job run notes-app.nomad`
2. Monitor status
3. Check logs

### Step 3: Update and Scale

**Objective:** Manage job lifecycle

**Instructions:**
1. Update job configuration
2. Scale job
3. Handle updates

---

## Verification

1. Job created
2. Job running
3. Updates working

---

## Task Checklist

- [ ] Created job spec
- [ ] Deployed job
- [ ] Tested updates

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

