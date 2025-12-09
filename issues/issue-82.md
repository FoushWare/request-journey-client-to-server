# Issue #82: 82 – Configure basic NGINX server block

**State:** Open  
**Created:** 2025-12-02T13:44:50Z  
**Updated:** 2025-12-02T13:44:50Z  
**URL:** https://github.com/FoushWare/request-journey-client-to-server/issues/82

**Labels:** nginx+server-block+static-files

---

## Objective
Serve frontend static files with NGINX.

## Tasks
- Create server block config in `/etc/nginx/sites-available/`  
- Set `root` to frontend build directory  
- Configure `index` and `try_files`  
- Test access to frontend via NGINX

