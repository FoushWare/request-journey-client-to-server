# Issue #90: 90 – Configure health checks for upstream servers

**State:** Open  
**Created:** 2025-12-02T13:48:10Z  
**Updated:** 2025-12-02T13:48:10Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/90

**Labels:** nginx+health-checks+load-balancing

---

## Objective
Automatically detect unhealthy backend servers.

## Tasks
- Configure `health_check` or `proxy_next_upstream` in NGINX  
- Test with failing backend instance  
- Verify NGINX routes traffic only to healthy servers

