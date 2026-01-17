# Spec-Kit: Specifications Repository

This directory contains all specifications extracted from GitHub issues, organized by category.

## Directory Structure

- **api-specs/** - API specifications (OpenAPI, gRPC, REST contracts)
- **architecture/** - Architecture diagrams, ADRs, design patterns
- **database-schemas/** - Database schema definitions and migrations
- **security-specs/** - Security configurations and best practices
- **deployment-specs/** - Deployment manifests (Kubernetes, Helm, Terraform, etc.)
- **observability-specs/** - Monitoring, logging, and tracing configurations

## Workflow

1. **Extract Specs from Issues** - When a GitHub issue is closed/resolved, relevant specifications are extracted and organized here
2. **Reference in Implementation** - Code implementations reference these specifications for consistency
3. **Version Control** - Specifications are version-controlled alongside code
4. **Documentation** - Specs serve as living documentation for the project architecture

## How to Use

Each category has a README that explains the organization within that folder. Start by reading the category README, then explore specific specifications.

### Example Workflows

**For API Development:**
→ Check `api-specs/` for REST/gRPC contracts before implementing

**For Deployment:**
→ Check `deployment-specs/` for Kubernetes manifests and Terraform configurations

**For Security:**
→ Check `security-specs/` for mTLS, RBAC, and JWT strategies

## Last Sync

- **Date:** January 17, 2026
- **Total GitHub Issues:** 149
- **Local Issues:** 149 (All synced)
- **Issues in spec-kit:** Categories setup, specifications to be populated as projects progress

---

See root [README.md](../README.md) for full project overview.
