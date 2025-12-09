# Issue #67: 67 – Implement input validation and sanitization

**State:** Open  
**Created:** 2025-12-02T13:38:35Z  
**Updated:** 2025-12-02T13:38:35Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/67

**Labels:** security+validation+input

---

## Objective
Prevent injection attacks and malformed requests.

## Tasks
- Use library like `express-validator` for validation  
- Validate and sanitize all user inputs  
- Test with malicious input (SQL injection, XSS)  
- Verify requests are rejected or sanitized

