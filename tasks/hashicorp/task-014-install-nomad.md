# Task: HashiCorp - Install and Configure Nomad

**Related Issue:** #144  
**Prerequisites:** Infrastructure knowledge, container basics  
**Estimated Time:** 3-4 hours  
**Notes App Context:** Install HashiCorp Nomad as an alternative orchestration platform to Kubernetes for running Notes App workloads

---

## Learning Objectives

- Understand Nomad architecture
- Install Nomad cluster
- Deploy applications to Nomad
- Compare Nomad vs Kubernetes
- Run Notes App on Nomad

---

## Theory Section

### What is Nomad?

**Nomad** is a workload orchestrator that:
- Runs containers and non-container workloads
- Simpler than Kubernetes
- Works with Consul and Vault
- Good for mixed workloads

**Nomad vs Kubernetes:**
- **Nomad**: Simpler, lighter, mixed workloads
- **Kubernetes**: More features, larger ecosystem

---

## Prerequisites Check

- [ ] Linux servers or VMs
- [ ] Network access
- [ ] Understanding of orchestration

---

## Step-by-Step Instructions

### Step 1: Install Nomad

**Objective:** Set up Nomad cluster

**Instructions:**

1. **Install Nomad:**
```bash
# Download and install
wget https://releases.hashicorp.com/nomad/1.6.0/nomad_1.6.0_linux_amd64.zip
unzip nomad_1.6.0_linux_amd64.zip
sudo mv nomad /usr/local/bin/
```

2. **Configure Nomad:**
```hcl
datacenter = "dc1"
data_dir = "/opt/nomad/data"
```

3. **Start Nomad:**
```bash
nomad agent -dev
```

### Step 2: Deploy Notes App

**Objective:** Run Notes App on Nomad

**Instructions:**
1. Create Nomad job file
2. Deploy application
3. Verify running

### Step 3: Compare with Kubernetes

**Objective:** Understand differences

**Instructions:**
1. Compare features
2. Understand use cases
3. Document trade-offs

---

## Verification

1. Nomad installed
2. Notes App deployed
3. Comparison documented

---

## Task Checklist

- [ ] Installed Nomad
- [ ] Deployed Notes App
- [ ] Compared with Kubernetes

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

