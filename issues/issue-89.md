# Issue #89: 89 – Configure rate limiting in NGINX

**State:** Open  
**Created:** 2025-12-02T13:47:45Z  
**Updated:** 2025-12-02T13:47:45Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/89

**Labels:** nginx+rate-limiting+security

---

## Objective
Prevent abuse of server resources.

## Tasks
- Enable `limit_req_zone` and `limit_req` in NGINX  
- Set rate limits per IP (e.g., 10 requests/second)  
- Test with multiple requests and verify blocking  
- Configure error pages for rate limit exceeded

