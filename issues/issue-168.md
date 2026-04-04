# Issue #168: Serverless Deployment for Microservices

**State:** Open  
**Created:** 2026-04-01  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/168

---

## Description

Deploy parts of the Notes App microservices as **serverless functions** (Function as a Service — FaaS) across the three major cloud providers. Serverless removes the need to manage VMs or containers — you deploy code, the cloud runs it on demand, and you pay only for invocations.

---

## FaaS Services Covered

| Provider | Service | Key Notes |
|----------|---------|-----------|
| **AWS** | AWS Lambda | Event-driven; 200+ integrations (API GW, S3, DynamoDB, Kafka, SQS, SNS); pay per invocation |
| **GCP** | Cloud Functions | Pay-as-you-go; fully managed; integrates with GCP Pub/Sub, Cloud Storage, Firestore |
| **Azure** | Azure Functions | On-demand; fully managed; integrates with Azure Event Grid, Service Bus, Blob Storage |

---

## When to Use Serverless vs. Kubernetes

| Factor | Serverless (FaaS) | Kubernetes (EKS/GKE/AKS) |
|--------|------------------|--------------------------|
| Operational overhead | ✅ Near zero | ⚠️ Cluster mgmt required |
| Cold start latency | ⚠️ 50ms–5s | ✅ Always warm |
| Persistent connections | ❌ Not ideal | ✅ Supported |
| Cost at low traffic | ✅ Very cheap (pay-per-call) | ⚠️ Fixed node cost |
| Cost at high traffic | ⚠️ Can exceed containers | ✅ Predictable |
| Stateful workloads | ❌ Not suited | ✅ Full support |
| Long-running jobs | ❌ 15-min limit (Lambda) | ✅ No limit |
| Event-driven tasks | ✅ Perfect fit | ⚠️ Requires event loop |

---

## Notes App Serverless Candidates

These microservice functions are good candidates for Lambda/FaaS:

1. **Email Notification** — Triggered by SNS/SQS/Kafka when a note is created; sends an email via SES
2. **Image Resize / Attachment Processing** — Triggered by S3 upload; resize and store thumbnails
3. **Scheduled Cleanup** — CloudWatch Events / cron trigger; purge expired notes/sessions
4. **Auth Token Validation** — Lambda@Edge for near-edge JWT validation at CloudFront

---

## Learning Objectives

- [ ] Understand FaaS vs. Containers vs. VMs (when to use each)
- [ ] Deploy the Notes App Email Service as an AWS Lambda function
- [ ] Trigger the Lambda from an SNS topic or SQS queue
- [ ] Understand cold starts and how to mitigate them (provisioned concurrency, keep-warm)
- [ ] Compare AWS Lambda vs. GCP Cloud Functions vs. Azure Functions
- [ ] Understand Lambda@Edge for near-edge authentication
- [ ] Integrate Lambda with existing EKS-based services via event bridge

---

## Tasks to Create

- `tasks/aws/task-016-serverless-lambda.md`
