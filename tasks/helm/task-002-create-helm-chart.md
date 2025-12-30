# Task: Helm - Create Helm Chart for Notes App

**Related Issue:** #139  
**Prerequisites:** task-001 (Install Helm)  
**Estimated Time:** 4-5 hours  
**Notes App Context:** Convert Notes App Kubernetes manifests into a Helm chart, making deployments configurable and reusable

---

## Learning Objectives

- Convert YAML manifests to Helm templates
- Use values.yaml for configuration
- Parameterize deployments
- Create reusable charts
- Understand template syntax

---

## Step-by-Step Instructions

### Step 1: Convert Existing Manifests

**Objective:** Transform Notes App YAML to Helm templates

**Instructions:**
1. Copy existing Kubernetes manifests
2. Convert to Helm templates
3. Replace hardcoded values with template variables

### Step 2: Create values.yaml

**Objective:** Define configurable values

**Instructions:**
1. Identify parameters (replicas, image tags, resources)
2. Create values.yaml
3. Set default values

### Step 3: Template Deployment

**Objective:** Create templated deployment

**Instructions:**
1. Use `{{ .Values.replicas }}` for replicas
2. Use `{{ .Values.image.tag }}` for image tags
3. Use conditionals for optional features

### Step 4: Test Chart

**Objective:** Validate chart

**Instructions:**
1. Run `helm lint`
2. Test with `helm template`
3. Install and verify

---

## Verification

1. Chart created with templates
2. Values.yaml configured
3. Chart installs successfully
4. Notes App deployed via Helm

---

## Task Checklist

- [ ] Converted manifests to templates
- [ ] Created values.yaml
- [ ] Templated deployments
- [ ] Tested chart

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

