# Issue #65: 65 – Add rate limiting to API

**State:** Open  
**Created:** 2025-12-02T13:37:45Z  
**Updated:** 2025-12-02T13:37:45Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/65

**Labels:** security+rate-limiting+api

---

## Objective
Prevent brute-force attacks and API abuse.

## Tasks
- Install and configure `express-rate-limit` middleware  
- Set rate limits per IP (e.g., 100 requests per 15 minutes)  
- Test with multiple rapid requests  
- Verify rate limiting works correctly

