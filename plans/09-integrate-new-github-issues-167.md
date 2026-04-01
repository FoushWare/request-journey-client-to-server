# Plan: Integrate New GitHub Issue #167

**Date**: 2026-04-01  
**Status**: Completed  
**Related Issues**: #167

---

## Overview

This document details the integration of 1 new GitHub issue (#167) into the DevOps learning path. The issue covers deploying microservices to cloud infrastructure — comparing raw VM deployment (EC2 + Docker Compose) against managed Kubernetes (EKS/GKE/AKS), and explaining dedicated/sole-tenant hosting for compliance-sensitive workloads.

---

## Issue Integrated

### Kubernetes / Cloud Deployment (1 issue)

- **#167**: Deploy Microservices to Cloud — covers multi-cloud VM options (AWS EC2, GCP Compute Engine, Azure VMs), dedicated hosting (EC2 Dedicated Hosts, GCP Sole-Tenant Nodes, Azure Dedicated Hosts), and the recommended deployment path for the Notes App microservices using managed Kubernetes (EKS with Terraform + kubectl).

---

## Implementation Summary

### Extended Category: Kubernetes (`tasks/kubernetes/`)

One new task added:

- **task-013-deploy-microservices-to-cloud.md**: Four deployment options (EC2+Docker Compose, EKS, GKE, AKS) with step-by-step commands for each. Covers instance type selection, multi-tenant vs. dedicated hosting trade-offs, ECR image push workflow, Terraform EKS provisioning, and a cloud-provider comparison table. Includes a Mermaid deployment strategy diagram and full Automation Reference section pointing to existing Terraform/Ansible modules.

---

## New Files Created

### Issue Files (1 new file)
- `issues/issue-167.md` — Deploy Microservices to Cloud

### Task Files (1 new task file)
- `tasks/kubernetes/task-013-deploy-microservices-to-cloud.md`

### Implementation Stubs (2 new directories)
- `implementation/kubernetes/task-013-deploy-microservices-to-cloud/starter/.gitkeep`
- `implementation/kubernetes/task-013-deploy-microservices-to-cloud/final-solution/.gitkeep`

### Tracker Updated
- `issues/ISSUE_TRACKER.md` — Added row for #167, updated summary to 167 total / 135 processed

---

## Statistics

| Metric | Value |
|--------|-------|
| Issues processed this session | 1 |
| New task files | 1 |
| New issue spec files | 1 |
| New implementation stubs | 2 |
| Files modified | 1 (ISSUE_TRACKER.md) |
| Total issues processed to date | 135 |
| Last issue number on GitHub | #167 |
