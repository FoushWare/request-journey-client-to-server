# Issue #132: 123 – Create Kubernetes Pods with Probes, Resources, and Volumes (Including NFS)

**Status**: open  
**Created**: 2025-12-09T10:24:55Z  
**Updated**: 2025-12-09T10:24:55Z  
**Author**: @FoushWare  
**URL**: [https://github.com/FoushWare/request-journey-client-to-server/issues/132](https://github.com/FoushWare/request-journey-client-to-server/issues/132)

## Details

**Labels**: devops+kubernetes  
**Assignees**:   
**Milestone**: None  

## Description



#  Kubernetes Pods With Probes, Resources & Volumes


### **Issue Body (copy/paste)**

```md
## Objective
Learn how to create robust Kubernetes Pods using production-ready features such as:
- Liveness & Readiness Probes
- Resource Requests & Limits
- Environment variables
- ConfigMaps & Secrets
- Persistent Volumes (PVC)
- NFS volumes
- Pod best practices

This will help build a strong foundation for container orchestration and reliability.

---

## Tasks / Sub-Issues

### 1. Understand Pod Fundamentals
- [ ] What is a Pod?
- [ ] Explanation: one or more containers inside a Pod
- [ ] Why Pods are ephemeral  
- [ ] Learn pod restart policies

### 2. Create a Basic Pod
- [ ] Write a manifest: `pod-basic.yaml`
- [ ] Use simple container: nginx or busybox
- [ ] Deploy via: `kubectl apply -f pod-basic.yaml`
- [ ] Verify: `kubectl get pods`

---

### 3. Add Liveness & Readiness Probes
- [ ] Learn probe types:
  - HTTP probe
  - TCP probe
  - Exec probe
- [ ] Add **readinessProbe** to Pod
- [ ] Add **livenessProbe** to Pod
- [ ] Test failure scenario (e.g., wrong port)
- [ ] Observe Pod restart behavior

---

### 4. Add Resource Requests & Limits
- [ ] Add CPU/MEM request
- [ ] Add CPU/MEM limits
- [ ] Learn: what happens if container exceeds limits?
- [ ] Run: `kubectl describe pod` and observe scheduling

---

### 5. Add Environment Variables, ConfigMaps, & Secrets
- [ ] Create ConfigMap for application configuration
- [ ] Mount via:
  - env variables  
  - volume mount  
- [ ] Create Secret for sensitive values (passwords, tokens)
- [ ] Mount Secret in Pod

---

### 6. Add Persistent Volume (PVC)
- [ ] Create PersistentVolumeClaim
- [ ] Add PVC to Pod manifest
- [ ] Test writing a file inside container
- [ ] Delete Pod → verify persistence

---

### 7. Configure NFS Volume
- [ ] Install NFS server (local VM or remote NAS)
- [ ] Create NFS share directory
- [ ] Configure NFS export
- [ ] Create PersistentVolume (type: NFS)
- [ ] Create PVC bound to NFS PV
- [ ] Mount into Pod
- [ ] Test:
  - Write file from container A  
  - Confirm visible in another Pod  

---

### 8. Pod Security & Best Practices
- [ ] Add securityContext (runAsUser, runAsNonRoot)
- [ ] Add Pod-level security context
- [ ] Learn capabilities, privilege escalation, readonlyRootFS
- [ ] Add labels & annotations

---

### 9. Documentation
- [ ] Create file: `docs/kubernetes/pods.md`
- [ ] Add examples for each component
- [ ] Add mermaid diagram for:
  - Pod  
  - Probes  
  - NFS Volume  
  - PVC → PV → Storage  
- [ ] Add troubleshooting section (CrashLoopBackOff, ImagePullBackOff)

---

## Labels
`devops+kubernetes`
`k8s+pods`
`probes+healthchecks`
`resources+limits`
`volumes+pvc`
`nfs+storage`
`learning+kubernetes`
`phase4+infrastructure`
```

