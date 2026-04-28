# Phase 07 — NGINX & Reverse Proxy

## Overview

NGINX sits at the entry point of the Notes App, handling SSL termination, routing, load balancing, rate limiting, and caching. Phase 02 introduced a basic NGINX container; this phase goes deep — covering every NGINX directive that matters in production, and then configuring NGINX as the Kubernetes Ingress Controller.

## Prerequisites

- **Phase 02 complete** — Docker Compose stack with NGINX container running
- **Phase 03 complete** — NGINX Ingress Controller already installed in Kubernetes
- **Phase 05 complete** — TLS certificate in place (this phase will configure NGINX SSL directives properly)

## Learning Objectives

- Understand NGINX server blocks (`server {}`) and the request-processing lifecycle
- Configure reverse proxy (`proxy_pass`) for the backend and the MFE Shell App
- Implement load balancing strategies: Round Robin, Least Connections, IP Hash, Weighted Round Robin
- Terminate SSL/TLS at NGINX with proper cipher suites and HSTS
- Enable Gzip compression to reduce payload size
- Configure proxy response caching to reduce backend load for static assets
- Apply NGINX-level rate limiting (`limit_req_zone`) per IP and per user
- Set security headers (HSTS, CSP, X-Frame-Options) in NGINX (complementary to helmet in the app)
- Configure NGINX health checks for upstream pool management
- Use NGINX as the Kubernetes Ingress Controller and manage Ingress resources

## Task Sequence

Complete the following tasks **in order**:

1. `tasks/nginx/task-001-install-nginx.md`
   > Install NGINX on a VM or run it in Docker. Verify the default page appears on port 80. Understand the main config file (`/etc/nginx/nginx.conf`) and the `sites-enabled/` pattern.

2. `tasks/nginx/task-002-configure-basic-server-block.md`
   > Write a `server {}` block that serves a static HTML page. Understand `listen`, `server_name`, `root`, `index`, and `location` directives.

3. `tasks/nginx/task-003-setup-reverse-proxy.md`
   > Configure `proxy_pass` to forward requests to the Notes App backend. Add `proxy_set_header` directives to forward `Host`, `X-Real-IP`, and `X-Forwarded-For`.

4. `tasks/nginx/task-004-configure-load-balancing.md`
   > Add an `upstream {}` block with three backend instances. Switch between Round Robin (default), `least_conn`, `ip_hash`, and weighted Round Robin. Observe traffic distribution.

5. `tasks/nginx/task-005-add-ssl-tls.md`
   > Configure `ssl_certificate` and `ssl_certificate_key`. Enable only TLSv1.2 and TLSv1.3. Set modern cipher suites. Test with `openssl s_client` and Qualys SSL Labs (A+ rating target).

6. `tasks/nginx/task-006-enable-caching.md`
   > Configure `proxy_cache_path` and `proxy_cache` directives. Cache `GET /api/notes` responses for 60 seconds. Verify cache hits via the `X-Cache-Status` response header.

7. `tasks/nginx/task-007-configure-gzip-compression.md`
   > Enable `gzip on` for `text/html`, `application/javascript`, `application/json`. Verify response `Content-Encoding: gzip` with `curl -H "Accept-Encoding: gzip"`.

8. `tasks/nginx/task-008-configure-logging.md`
   > Define a custom `log_format` in JSON. Set `access_log` and `error_log` paths. Rotate logs with `logrotate`. Forward access logs to the ELK stack (Phase 06).

9. `tasks/nginx/task-009-configure-rate-limiting.md`
   > Add `limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m` to throttle the `/api/auth/login` endpoint. Return `429` status when exceeded.

10. `tasks/nginx/task-010-configure-health-checks.md`
    > Enable NGINX `upstream` active health checks (`health_check` directive in NGINX Plus, or passive checks via `proxy_next_upstream`). Mark a failing upstream as down automatically.

## NGINX as Kubernetes Ingress Controller

After completing the 10 standalone NGINX tasks, apply this knowledge to the Kubernetes setup from Phase 03:

- Review the NGINX Ingress Controller annotations on your Ingress resource
- Add rate-limiting annotations (`nginx.ingress.kubernetes.io/limit-rps`)
- Configure SSL passthrough vs SSL termination at the Ingress
- Tune NGINX `proxy-buffer-size` for large JWT payloads

## Success Criteria

Before moving to Phase 08, verify:

- [ ] NGINX proxies `/api/*` to the backend and `/` to the Shell App MFE
- [ ] SSL/TLS configured with TLSv1.2 + TLSv1.3 only (SSLv3, TLSv1.0, TLSv1.1 disabled)
- [ ] Gzip compression is active — JS bundle size reported by browser devtools is smaller
- [ ] NGINX rate-limits the login endpoint: 5th request in under a minute returns `429`
- [ ] Cache hits on `GET /api/notes` visible via `X-Cache-Status: HIT`
- [ ] NGINX access logs appear in Kibana within 30 seconds
- [ ] Load balancer distributes requests across two backend instances (check upstream metrics)

---

## ➡️ Next Phase

**[Phase 08 — Ansible Automation](./phase-08-ansible-automation.md)**

Phase 08 uses Ansible to automate everything you have configured manually so far — installing Docker, deploying the Notes App, configuring NGINX, and provisioning monitoring — so the entire stack can be reproduced on any new server with a single `ansible-playbook` command.
