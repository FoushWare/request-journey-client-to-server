# Issue #83: 83 – Setup reverse proxy for backend API

**State:** Open  
**Created:** 2025-12-02T13:45:15Z  
**Updated:** 2025-12-02T13:45:15Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/83

**Labels:** nginx+reverse-proxy+api

---

## Objective
Proxy backend API requests through NGINX.

## Tasks
- Configure `proxy_pass` to backend service  
- Set proxy headers (`X-Real-IP`, `X-Forwarded-For`)  
- Test API calls through NGINX  
- Verify backend receives correct requests

