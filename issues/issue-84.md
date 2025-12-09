# Issue #84: 84 – Configure load balancing with NGINX

**State:** Open  
**Created:** 2025-12-02T13:45:40Z  
**Updated:** 2025-12-02T13:45:40Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/84

**Labels:** nginx+load-balancing+high-availability

---

## Objective
Distribute requests across multiple backend instances.

## Tasks
- Define `upstream` block with multiple backend servers  
- Set load balancing method (round-robin, least_conn, ip_hash)  
- Test with multiple backend instances  
- Verify requests are distributed

