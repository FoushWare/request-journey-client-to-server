# Phase 05 — Security Hardening

## Overview

A working, auto-deploying Notes App is not enough — it must be **secure**. This phase closes the most common attack vectors: forces HTTPS everywhere, hardens JWT token handling, adds Two-Factor Authentication (2FA), enforces rate limiting, configures CORS correctly, validates all inputs, and applies security headers. It also integrates security scanning into the CI/CD pipeline built in Phase 04.

## Prerequisites

- **Phase 02 complete** — Docker stack running
- **Phase 03 complete** — Notes App deployed to Kubernetes
- **Phase 04 complete** — CI/CD pipeline running (security scans will be added here)

## Learning Objectives

- Enable HTTPS / TLS on NGINX with Let's Encrypt (cert-manager)
- Configure TLS Ingress termination in Kubernetes
- Harden JWT: short expiry (15 min access token), HTTPOnly refresh token cookie, CSRF protection
- Implement RBAC (role-based access control) for admin vs regular users
- Add rate limiting at the application level (Express `express-rate-limit`)
- Configure CORS policy: allow only trusted origins
- Implement server-side input validation and sanitisation (prevent SQL injection, XSS)
- Apply security headers with `helmet` (Content-Security-Policy, HSTS, X-Frame-Options)
- Implement TOTP-based 2FA (Google Authenticator)
- Log all authentication events (login success, failure, 2FA bypass attempt)

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/security/task-001-enable-https-on-nginx.md`
   > Install `certbot` / Let's Encrypt. Configure NGINX to redirect HTTP → HTTPS. Test with `curl -I https://notes-app.local`.

2. `tasks/security/task-002-configure-tls-for-kubernetes.md`
   > Install `cert-manager` in the cluster. Annotate the Ingress resource to automatically obtain and renew a TLS certificate via the ACME challenge.

3. `tasks/security/task-003-implement-jwt-authentication.md`
   > Refactor the backend to issue short-lived access tokens (15 min) and long-lived refresh tokens (7 days). Store the refresh token in an `HTTPOnly; Secure; SameSite=Strict` cookie. Rotate refresh tokens on every use.

4. `tasks/security/task-004-implement-rbac.md`
   > Add a `role` field to user accounts (`user` / `admin`). Protect admin-only API routes with a middleware that checks the JWT role claim.

5. `tasks/security/task-005-add-rate-limiting.md`
   > Use `express-rate-limit` to limit login attempts to 5 per minute per IP. Return `429 Too Many Requests` when the limit is exceeded.

6. `tasks/security/task-006-add-cors-policy.md`
   > Configure the `cors` middleware to allow requests only from the trusted frontend origin (e.g., `https://notes-app.com`). Block all other origins.

7. `tasks/security/task-007-implement-input-validation.md`
   > Use `joi` or `zod` to validate every request body, path parameter, and query string on the backend. Return `400 Bad Request` with clear error messages on invalid input.

8. `tasks/security/task-008-enable-helmet.md`
   > Add `helmet()` middleware to the Express app. Verify the response headers include `Strict-Transport-Security`, `X-Content-Type-Options`, `X-Frame-Options`, and `Content-Security-Policy`.

9. `tasks/security/task-009-implement-2fa.md`
   > Add optional TOTP-based 2FA to the Auth Service. On login, if 2FA is enabled, issue a short-lived `pre-auth` token and prompt for the TOTP code before issuing a full JWT.

10. `tasks/security/task-010-setup-security-logging.md`
    > Emit structured security events (login success, login failure, 2FA enrolled, token refresh) to the logging pipeline. Set up alerts for repeated login failures (preview of Phase 06 Observability).

### Additional Security Tasks

11. `tasks/security/task-011-*` — HTTPOnly cookies deep-dive
12. `tasks/security/task-012-*` — CSRF token implementation
13. `tasks/security/task-013-*` — OWASP Top 10 audit checklist

## Security Headers Checklist

After this phase, every Notes App response must include:

| Header | Value | Purpose |
|--------|-------|---------|
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains; preload` | Force HTTPS |
| `Content-Security-Policy` | `default-src 'self'` (tuned per MFE) | Block XSS |
| `X-Frame-Options` | `DENY` | Prevent clickjacking |
| `X-Content-Type-Options` | `nosniff` | Prevent MIME sniffing |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Limit referrer leakage |

## Success Criteria

Before moving to Phase 06, verify:

- [ ] `curl -I http://notes-app.local` returns `301 → https://`
- [ ] TLS certificate is valid and auto-renews via cert-manager
- [ ] JWT refresh token is stored in an `HTTPOnly` cookie (not accessible via `document.cookie` in the browser)
- [ ] Login endpoint returns `429` after 5 failed attempts in under a minute
- [ ] CORS blocks a request from `http://evil.com` (test in browser devtools)
- [ ] Sending `'; DROP TABLE users; --` as a note title returns `400` (not `500`)
- [ ] 2FA setup and login flow works with Google Authenticator
- [ ] Security events appear in structured logs

---

## ➡️ Next Phase

**[Phase 06 — Observability](./phase-06-observability.md)**

With a secure app running, Phase 06 adds visibility: centralised logging (ELK Stack), metrics and dashboards (Prometheus + Grafana), and distributed tracing (Jaeger). You will be able to see every request, every error, and every slow query.
