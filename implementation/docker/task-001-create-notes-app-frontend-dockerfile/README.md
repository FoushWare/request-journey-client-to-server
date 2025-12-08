# Implementation: Frontend Dockerfile

This directory contains the implementation code for creating the Notes App frontend Dockerfile.

## Files

- `Dockerfile` - Multi-stage Dockerfile for Next.js frontend
- `.dockerignore` - Files to exclude from build context
- `next.config.js.example` - Example Next.js configuration

## Usage

1. Copy `Dockerfile` to your `frontend/` directory
2. Copy `.dockerignore` to your `frontend/` directory
3. Build the image: `docker build -t notes-app-frontend:latest ./frontend`
4. Run the container: `docker run -p 3000:3000 notes-app-frontend:latest`

## Notes

- Uses Node.js 18 Alpine for smaller image size
- Multi-stage build for optimization
- Production-ready configuration

