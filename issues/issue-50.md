# Issue #50: 50 – Setup backend rolling updates

**State:** Open  
**Created:** 2025-12-02T13:31:30Z  
**Updated:** 2025-12-02T13:31:30Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/50

**Labels:** kubernetes+rolling-updates+deployment

---

## Objective
Deploy updates with zero downtime.

## Tasks
- Configure `strategy: RollingUpdate` in deployment  
- Set `maxSurge` and `maxUnavailable`  
- Test rolling update with new image  
- Verify zero-downtime during update

