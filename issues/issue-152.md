# Issue #152: Add Email Service to Microservices

**State:** Open  
**Created:** 2026-03-20T21:50:45Z  
**Updated:** 2026-03-20T21:50:45Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/152

**Labels:** None

---

## Description

Add a dedicated **Email Service** to the microservices architecture of the Notes App.

Two goals:
1. Set up a self-hosted email server (or use SMTP/Mailhog for local dev)
2. Integrate the email service into the microservices cycle to study distributed failures and resilience

---

## Why This Matters

Email is one of the most common async operations in any real system:
- Welcome emails on sign-up
- Notification emails when notes are shared
- Password reset flows

An email service is a great example of:
- **Async communication** via message queues (Kafka/RabbitMQ)
- **Distributed failure** — what happens when the email service is down?
- **Idempotency** — ensuring the same email is not sent twice
- **Dead Letter Queues (DLQ)** — handling undeliverable messages
- **Retry patterns** — exponential backoff for email delivery

---

## Learning Objectives

- [ ] Understand SMTP protocol and email delivery
- [ ] Set up Mailhog locally for email testing
- [ ] Build an Email Service (Go or Python) that listens to a Kafka topic
- [ ] Publish email events from the Notes Service to Kafka
- [ ] Handle failures: retry, DLQ, circuit breaker
- [ ] Test failure scenarios: email service down, malformed email, duplicates
- [ ] Observe email events in Grafana/Prometheus

---

## Tasks to Create

- `tasks/microservices/task-007-email-service.md`
- `tasks/microservices/task-008-async-email-with-kafka.md`

---

## Notes App Integration

The Notes App will trigger email events through Kafka:
- User registers → welcome email
- Note is shared → notification email
- Password changed → security alert email

The Email Service subscribes to the `email-events` Kafka topic and delivers emails.
