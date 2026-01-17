# Issue #147: AWS Free Tier Safe Labs with Terraform (Create and Destroy Per Task)

**Status**: open  
**Created**: 2026-01-05T09:53:23Z  
**Updated**: 2026-01-05T09:53:23Z  
**Author**: @FoushWare  
**URL**: [https://github.com/FoushWare/request-journey-client-to-server/issues/147](https://github.com/FoushWare/request-journey-client-to-server/issues/147)

## Details

**Labels**:   
**Assignees**:   
**Milestone**: None  

## Description


## 🟥 GitHub Issue

### **Title**

```
145- AWS Free Tier Safe Labs with Terraform (Create and Destroy Per Task)
```

---

### **Body**

## 🚨 Priority: IMPORTANT

## 🎯 Objective

Ensure **every AWS-related task in the project can be executed safely using AWS Free Tier**, without requiring a powerful local machine or incurring unexpected costs.

Each AWS lab must:

* Be provisioned using **Terraform**
* Clearly state **Free Tier limits**
* Be **fully destroyable** after completion
* Serve as a **temporary learning environment**

This issue introduces a **mandatory AWS Free Tier appendix** for all AWS tasks.

---

## 🧩 Scope

### 1️⃣ AWS Free Tier Learning Philosophy

* No long-lived cloud resources
* No manual AWS Console dependency
* Everything created via Infrastructure as Code
* Everything destroyed after task completion
* Costs must remain within AWS Free Tier limits

---

### 2️⃣ Terraform-First Infrastructure

For every AWS-related task:

* Create a **Terraform module**
* Use:

  * `terraform init`
  * `terraform apply`
  * `terraform destroy`
* No hardcoded credentials
* Use AWS IAM roles or environment variables

---

### 3️⃣ AWS Free Tier Constraints (Must Be Documented)

Each task must explicitly document:

* EC2 instance type (e.g. `t2.micro`, `t3.micro`)
* Storage limits (EBS ≤ 30GB)
* Database limits (RDS micro)
* Data transfer considerations
* Duration limits (e.g. “Run for < 12 hours”)

---

### 4️⃣ Required Folder Structure

Each AWS task must include:

```
/infra/aws/<task-name>/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars.example
├── README.md
```

---

### 5️⃣ Terraform Safety Practices

* Use `count = 1` or conditional creation
* Avoid NAT Gateway (not Free Tier)
* Prefer:

  * Security Groups over NACLs
  * ALB only when strictly required
* Use `lifecycle { prevent_destroy = false }`

---

### 6️⃣ Task-Level Appendix (Mandatory)

Each AWS-related GitHub issue must include an appendix like:

```
## AWS Free Tier Appendix

- Services used: EC2, S3
- Instance type: t3.micro
- Estimated runtime: 1–3 hours
- Estimated cost: $0 (Free Tier)
- Cleanup command: terraform destroy
```

---

### 7️⃣ Automated Cleanup Discipline

* Every lab must end with:

  * `terraform destroy`
* No task is considered “done” without cleanup
* Add checklist confirmation:

  * [ ] Resources destroyed successfully

---

### 8️⃣ Local Machine Friendly

* No heavy local dependencies
* Terraform + AWS CLI only
* No need for Kubernetes locally unless explicitly required
* Labs should run on:

  * Low-RAM laptops
  * Basic CPUs

---

## 📌 Deliverables

* AWS Free Tier guidelines document
* Terraform templates for AWS labs
* README appendix template
* Example Free Tier lab (EC2 + S3)
* Cost-safe learning workflow

---

## ✅ Acceptance Criteria

* All AWS tasks reference Free Tier usage
* Terraform is used exclusively
* No persistent AWS resources remain
* Learning can be done without financial risk
* Repo is safe for beginners and learners

---

### 🏷 Labels

```
important+aws
terraform+iac
free-tier+learning
cost-optimization
devops+best-practices
```

---

## 🧠 Why This Issue Matters

* Prevents surprise AWS bills
* Makes the project accessible to everyone
* Encourages professional DevOps habits
* Aligns with real-world infrastructure hygiene
* Increases trust in the learning project

---

