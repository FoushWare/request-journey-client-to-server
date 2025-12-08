# Implementation: NGINX Reverse Proxy

This directory contains the NGINX configuration for the Notes App reverse proxy.

## Files

- `nginx.conf` - NGINX configuration file
- `docker-compose.nginx.yml` - Example docker-compose addition

## Usage

1. Create `nginx/` directory in project root
2. Copy `nginx.conf` to `nginx/nginx.conf`
3. Add NGINX service to `docker-compose.yml` (see task documentation)
4. Start services: `docker-compose up -d`

## Configuration

- Frontend accessible at `http://localhost/`
- Backend API at `http://localhost/api/*`
- Health check at `http://localhost/health`

