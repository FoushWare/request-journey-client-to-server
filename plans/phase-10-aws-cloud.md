# Phase 10 — AWS Cloud Deployment

## Overview

All previous phases ran locally or in a local Kubernetes cluster. Phase 10 moves the Notes App to **AWS** — the world's most widely used cloud platform. Using the infrastructure provisioned by Terraform (Phase 09), this phase deploys Docker images to ECR, runs microservices on EKS, hosts MFE static assets on S3 + CloudFront, stores data in RDS and ElastiCache, and routes traffic via Route 53.

By the end of this phase the Notes App is running in a real cloud environment, accessible from the internet with a custom domain and a valid TLS certificate.

## Prerequisites

- **Phase 02 complete** — Docker images built and tested
- **Phase 03 complete** — Kubernetes manifests ready
- **Phase 09 complete** — AWS infrastructure provisioned with Terraform (VPC, EKS, RDS, S3, ECR, Route 53)
- AWS CLI installed and configured (`aws configure`)
- An AWS account (Free Tier is sufficient for learning)

## Learning Objectives

- Set up AWS CLI and understand IAM roles and least-privilege access
- Push Docker images to Amazon ECR (Elastic Container Registry)
- Configure `kubectl` to connect to the EKS cluster
- Deploy the Notes App Kubernetes manifests to EKS
- Upload CSR MFE static assets (`remoteEntry.js`, JS chunks) to S3 with correct cache headers
- Configure CloudFront to serve MFE assets globally with low latency
- Connect the backend to RDS (Postgres) and ElastiCache (Redis) running in private subnets
- Configure Route 53 DNS records (A alias to CloudFront and ELB)
- Use AWS Lambda for event-driven tasks (email notification on note creation via SES)
- Monitor the deployment with AWS CloudWatch
- Practice with LocalStack for local cloud development without real AWS costs

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/aws/task-001-setup-aws-free-tier.md`
   > Create an AWS account. Enable MFA on the root account. Understand the Free Tier limits.

2. `tasks/aws/task-002-configure-iam.md`
   > Create IAM users and roles with least-privilege policies. Set up IRSA (IAM Roles for Service Accounts) so EKS pods can assume IAM roles without static credentials.

3. `tasks/aws/task-003-launch-ec2-instance.md`
   > Launch an EC2 instance manually to understand the concepts (AMI, key pair, security group, user data). This is the Terraform-managed alternative — compare manual vs `terraform apply`.

4. `tasks/aws/task-004-configure-s3-bucket.md`
   > Create the S3 bucket for MFE assets. Configure the bucket policy for public read of JS chunks. Upload `remoteEntry.js` with `Cache-Control: no-cache` and JS chunks with `Cache-Control: max-age=31536000`.

5. `tasks/aws/task-005-setup-rds-instance.md`
   > Connect the Notes App backend to the Terraform-provisioned RDS Postgres instance. Run database migrations. Verify user registration and login work against the cloud database.

6. `tasks/aws/task-006-deploy-containers-on-ecs.md`
   > As an alternative to EKS, deploy the backend using ECS Fargate. Compare ECS vs EKS trade-offs. Use this task if you do not have an EKS cluster available.

7. `tasks/aws/task-007-practice-lambda-functions.md`
   > Write a Lambda function (`email-notification`) that receives an SQS message (triggered by `note.created` Kafka event) and sends a confirmation email via AWS SES.

8. `tasks/aws/task-008-setup-api-gateway.md`
   > Create an API Gateway HTTP API in front of the Lambda functions. Understand how API Gateway authenticates requests with JWT authorisers.

9. `tasks/aws/task-009-practice-cloudwatch.md`
   > Create CloudWatch dashboards for EKS pod CPU/memory, RDS connections, and Lambda invocation errors. Set up CloudWatch Alarms on high error rates.

10. `tasks/aws/task-010-practice-route-53.md`
    > Create a Route 53 hosted zone for `notes-app.com`. Add an A alias record pointing to the CloudFront distribution. Verify `dig notes-app.com` resolves correctly.

### Advanced AWS Tasks (11–16)

11. `tasks/aws/task-011-aws-developer-associate-coverage.md`
    > Comprehensive checklist: covers all AWS Developer Associate exam topics as applied to the Notes App (SQS, SNS, DynamoDB, Cognito, CodePipeline, CloudFormation).

12–16. Additional tasks in `tasks/aws/` covering EKS node groups, ECR lifecycle policies, multi-region deployment, cost optimisation, and AWS cost explorer.

## AWS Service Mapping

| Notes App Component | AWS Service |
|--------------------|-------------|
| Container registry | ECR |
| Container orchestration | EKS (or ECS Fargate) |
| SQL database | RDS PostgreSQL (multi-AZ) |
| Cache / session store | ElastiCache Redis |
| MFE static assets | S3 + CloudFront |
| File attachments | S3 (pre-signed URLs) |
| Email notifications | Lambda + SQS + SES |
| Full-text search | Elasticsearch Service (or self-hosted) |
| DNS | Route 53 |
| TLS certificates | ACM (auto-renewed) |
| Secrets | Secrets Manager / Vault (Phase 03) |
| Logs | CloudWatch Logs + ELK (Phase 06) |

## Success Criteria

Before moving to Phase 11, verify:

- [ ] `kubectl get nodes` shows EKS worker nodes in `Ready` state
- [ ] Notes App accessible at `https://notes-app.com` with a valid ACM TLS certificate
- [ ] MFE `remoteEntry.js` served from CloudFront with `Cache-Control: no-cache`
- [ ] Login creates a record in RDS Postgres (verify with `psql` from inside the cluster)
- [ ] Lambda function receives the SQS message after note creation and an email arrives
- [ ] CloudWatch alarm triggers when backend pod error rate exceeds threshold
- [ ] Route 53 DNS resolves `notes-app.com` to the CloudFront IP

---

## ➡️ Next Phase

**[Phase 11 — Networking & Protocols](./phase-11-networking.md)**

With the app live on AWS, Phase 11 deepens your understanding of the network stack: OSI model layers, DNS resolution, TCP handshake, TLS negotiation, HTTP/2 multiplexing, gRPC, and VPC networking.
