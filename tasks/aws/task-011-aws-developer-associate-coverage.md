# Task: AWS - Developer Associate Coverage Checklist

**Related Issue:** #145, #146  
**Prerequisites:** All previous AWS tasks  
**Estimated Time:** Reference/Checklist task  
**Notes App Context:** Comprehensive checklist to ensure all AWS Certified Developer Associate exam topics are covered, with emphasis on using AWS Free Tier resources

---

## Learning Objectives

- Verify coverage of all AWS Developer Associate domains
- Ensure all tasks use AWS Free Tier
- Use as reference for AWS certification prep
- Map AWS services to Notes App implementation

---

## Theory Section

This task serves as a **comprehensive coverage checklist** for AWS Certified Developer Associate exam topics. All implementations should use **AWS Free Tier** to minimize costs.

**AWS Free Tier Notes:**
- Most services have free tier limits
- Free tier valid for 12 months for new accounts
- Some services have always-free tier
- Monitor usage to avoid charges

---

## AWS Developer Associate Coverage Checklist

### Domain 1: AWS Core Services (Compute, Storage, Networking)

#### EC2 (Elastic Compute Cloud)
- [ ] Deploy Notes App backend on EC2
- [ ] Configure Security Groups
- [ ] Use IAM Role attached to EC2 (not static credentials)
- [ ] Practice user-data bootstrap scripts
- [ ] **Free Tier**: 750 hours/month of t2.micro or t3.micro

#### Elastic Load Balancer (ALB)
- [ ] Place ALB in front of EC2 services
- [ ] Configure target groups
- [ ] Enable health checks
- [ ] **Free Tier**: 750 hours/month for first 12 months

#### VPC (Virtual Private Cloud)
- [ ] Use custom VPC
- [ ] Configure public vs private subnets
- [ ] Set up Internet Gateway & Route Tables
- [ ] **Free Tier**: Always free (with usage limits)

---

### Domain 2: AWS Storage Services

#### S3 (Simple Storage Service)
- [ ] Store user-uploaded files (notes attachments)
- [ ] Enable versioning
- [ ] Configure lifecycle rules
- [ ] Use pre-signed URLs
- [ ] Apply bucket policies
- [ ] **Free Tier**: 5 GB storage, 20,000 GET requests, 2,000 PUT requests

#### EBS (Elastic Block Store)
- [ ] Attach EBS volume to EC2
- [ ] Persist application logs or DB data
- [ ] **Free Tier**: 30 GB of General Purpose (SSD) or Magnetic storage

---

### Domain 3: AWS Databases

#### RDS (Relational Database Service)
- [ ] Use RDS (PostgreSQL or MySQL)
- [ ] Configure multi-AZ (for learning, use single-AZ in free tier)
- [ ] Use parameter groups
- [ ] Secure access using security groups
- [ ] **Free Tier**: 750 hours/month of db.t2.micro, 20 GB storage

#### DynamoDB
- [ ] Implement DynamoDB table for session or metadata storage
- [ ] Use partition + sort keys
- [ ] Practice TTL
- [ ] Enable streams (optional)
- [ ] **Free Tier**: 25 GB storage, 25 provisioned Write Capacity Units, 25 Read Capacity Units

---

### Domain 4: IAM & Security

- [ ] Create IAM users, roles, and policies
- [ ] Apply least-privilege principle
- [ ] Use IAM Roles instead of static credentials
- [ ] Use AWS Secrets Manager for DB credentials
- [ ] Rotate secrets
- [ ] **Free Tier**: IAM is always free

---

### Domain 5: Application Integration & Messaging

#### SQS (Simple Queue Service)
- [ ] Send background jobs (email, notifications)
- [ ] Configure DLQ (Dead Letter Queue)
- [ ] Practice visibility timeout
- [ ] **Free Tier**: 1 million requests/month

#### SNS (Simple Notification Service)
- [ ] Publish notifications
- [ ] Implement fan-out pattern (SNS → SQS)
- [ ] **Free Tier**: 1 million publishes, 100,000 HTTP/S deliveries

---

### Domain 6: Serverless & Event-Driven Architecture

#### Lambda
- [ ] Create Lambda functions for async tasks
- [ ] Integrate Lambda with API Gateway
- [ ] Integrate Lambda with S3 events
- [ ] Integrate Lambda with DynamoDB streams
- [ ] **Free Tier**: 1 million requests/month, 400,000 GB-seconds compute

#### API Gateway
- [ ] Expose REST API
- [ ] Enable request validation
- [ ] Use stages (dev / prod)
- [ ] Secure with IAM or Lambda authorizer
- [ ] **Free Tier**: 1 million API calls/month for first 12 months

---

### Domain 7: CI/CD on AWS

- [ ] Use CodeBuild OR integrate existing CI with AWS
- [ ] Push Docker images to ECR
- [ ] Deploy services using AWS credentials securely
- [ ] Practice environment-based deployments
- [ ] **Free Tier**: 
  - CodeBuild: 100 build minutes/month
  - ECR: 500 MB storage/month

---

### Domain 8: Observability & Monitoring

#### CloudWatch
- [ ] Application logs
- [ ] Custom metrics
- [ ] Alarms
- [ ] **Free Tier**: 10 custom metrics, 1 million API requests, 5 GB log ingestion

#### X-Ray
- [ ] Enable distributed tracing
- [ ] Trace request flow across services
- [ ] **Free Tier**: 100,000 traces/month

---

### Domain 9: Configuration & Environment Management

- [ ] Use Parameter Store (Systems Manager)
- [ ] Separate config per environment
- [ ] Secure secrets handling
- [ ] **Free Tier**: 10,000 parameters (Standard), 10,000 API calls

---

### Domain 10: Cost Awareness (Exam-Critical)

- [ ] Enable AWS Budgets
- [ ] Tag resources properly
- [ ] Understand cost drivers (EC2, NAT Gateway, ALB)
- [ ] Monitor free tier usage
- [ ] **Free Tier**: AWS Budgets free tier available

---

## Mapping to Existing Tasks

This checklist maps to existing AWS tasks:
- EC2: Covered in existing EC2 tasks
- S3: Covered in S3 tasks
- RDS: Covered in RDS tasks
- Lambda: Covered in serverless tasks
- IAM: Covered in security tasks

**New Tasks Needed:**
- ALB setup
- DynamoDB implementation
- SQS/SNS integration
- API Gateway setup
- X-Ray tracing
- Parameter Store usage

---

## Free Tier Best Practices

1. **Monitor Usage**: Set up billing alerts
2. **Use Free Tier Limits**: Stay within free tier limits
3. **Clean Up**: Delete resources when done
4. **Tag Resources**: Tag with "free-tier" for tracking
5. **Document Limits**: Note free tier limits in each task

---

## How to Use This Checklist

1. **Track Progress**: Check off items as you complete them
2. **Identify Gaps**: Find areas not covered in tasks
3. **Reference**: Use as quick reference for AWS services
4. **Certification Prep**: Use for exam preparation
5. **Cost Management**: Ensure free tier compliance

---

## Task Checklist

- [ ] Reviewed all domains
- [ ] Identified gaps in coverage
- [ ] Ensured free tier usage
- [ ] Mapped to Notes App implementation
- [ ] Ready for certification prep

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

**Note:** This is a reference/checklist task. Use it to track your AWS Developer Associate learning journey and ensure comprehensive coverage while staying within AWS Free Tier limits.

