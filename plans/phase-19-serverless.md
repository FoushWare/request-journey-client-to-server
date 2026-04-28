# Phase 19 — Serverless (Lambda & Cloud Functions)

## Overview

Not every workload needs a long-running server. **Serverless functions** are perfect for event-driven, short-lived tasks: send an email when a note is created, resize an image uploaded to S3, run a nightly database cleanup, or validate a JWT at the CloudFront edge. AWS Lambda — and its equivalents on GCP (Cloud Functions) and Azure (Azure Functions) — run code on demand with zero server management and billing per invocation.

## Prerequisites

- **Phase 10 complete** — AWS infrastructure is set up (SQS, SES, S3, CloudFront provisioned by Terraform)
- **Phase 17 complete** — Kafka publishes `note.created` events; Lambda will consume them via SQS (Kafka → SQS bridge)

## Learning Objectives

- Understand the serverless execution model: function deployment, event triggers, cold starts, and billing model
- Write and deploy an AWS Lambda function in Node.js
- Trigger Lambda from SQS (email notification), S3 events (image resize), and CloudWatch Events (cron)
- Configure Lambda environment variables and retrieve secrets from Vault / AWS Secrets Manager at cold start
- Deploy Lambda functions with Terraform (from Phase 09 `aws_lambda_function` resource)
- Understand Lambda@Edge for JWT validation at CloudFront (before the request reaches the origin)
- Compare serverless across clouds: AWS Lambda vs GCP Cloud Functions vs Azure Functions
- Understand cold-start optimisation: provisioned concurrency, function bundling, runtime selection
- Monitor Lambda with CloudWatch Logs and X-Ray distributed tracing

## Task Sequence

1. `tasks/aws/task-016-serverless-lambda.md`
   > This comprehensive task covers all five Lambda use cases for the Notes App:

   **Part A — Email Notification Lambda**
   > Write a Node.js Lambda function that receives an SQS message containing `{ userId, noteId, noteTitle }` and sends an email via AWS SES. Deploy with `terraform apply`. Test by creating a note and watching the email arrive.

   **Part B — Image Resize Lambda**
   > Write a Python Lambda function triggered by an `s3:ObjectCreated` event. Resize uploaded images to 800 × 600 px and store the thumbnail back in S3. Test by uploading an image attachment to a note.

   **Part C — Scheduled Cleanup Lambda**
   > Write a Node.js Lambda on a CloudWatch Events cron schedule (`rate(1 day)`). It deletes soft-deleted notes older than 30 days from MongoDB and removes expired S3 attachments.

   **Part D — Lambda@Edge for JWT Validation**
   > Write a Node.js Lambda@Edge function attached to the CloudFront distribution viewer-request event. It validates the JWT in the `Authorization` header and returns `401` before the request reaches NGINX — protecting all API routes at the edge.

   **Part E — Multi-Cloud Comparison**
   > Re-implement the email notification function as a GCP Cloud Function (Pub/Sub trigger) and an Azure Function (Service Bus trigger). Compare deployment complexity, cold-start times, and pricing models.

## Lambda Architecture in the Notes App

```
Kafka (note.created)
       │
       ▼
  Kafka → SQS Bridge (Kafka Connect or custom consumer)
       │
       ▼
  SQS Queue  ──────────►  email-notification Lambda
                               │
                               ▼
                          AWS SES  ──►  User inbox ✉️

S3 ObjectCreated event  ──►  image-resize Lambda
                               │
                               ▼
                          S3 thumbnail/ prefix 🖼️

CloudWatch cron  ──────►  cleanup Lambda
                               │
                               ▼
                          MongoDB (purge expired docs) 🗑️

CloudFront viewer request  ──►  auth-edge Lambda@Edge
                               │
                               ▼
                          401 Unauthorized (if JWT invalid) 🔒
```

## Success Criteria

Before moving to Phase 20, verify:

- [ ] Creating a note in the Notes App triggers an email delivery to the registered user's inbox
- [ ] Uploading an image attachment creates a thumbnail in the `thumbnails/` S3 prefix
- [ ] Lambda function logs appear in CloudWatch Logs within 10 seconds of invocation
- [ ] X-Ray trace shows the Lambda invocation duration and SES call latency
- [ ] Lambda@Edge returns `401` for requests without a valid JWT before they reach NGINX
- [ ] Cleanup Lambda shows `deleted: 0` on first run (no expired data) and `deleted: N` after seeding expired records
- [ ] Terraform provisions all Lambda functions — no manual console clicks

---

## ➡️ Next Phase

**[Phase 20 — System Design](./phase-20-system-design.md)**

Phase 20 steps back and looks at the Notes App as a complete system. You will design load-testing strategies, analyse scaling bottlenecks, build architecture diagrams, and apply system design interview techniques to the project you have built.
