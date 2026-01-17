# API Specifications

Contains API contracts and interface definitions for the Notes App microservices.

## Organization

- **microservices/** - Individual service APIs
- **grpc/** - gRPC service definitions
- **rest/** - REST API specifications

## Contents

### REST APIs

#### Notes Service
- Path: `/api/notes`
- Methods: GET (list), POST (create), GET (by ID), PUT (update), DELETE

#### User Service
- Path: `/api/users`
- Methods: GET (list), POST (create), GET (profile), PUT (update)

#### Auth Service
- Path: `/api/auth`
- Methods: POST (login), POST (signup), POST (refresh), POST (logout)

## Specifications Format

Each API specification includes:
- Endpoint paths
- HTTP methods
- Request/response schemas
- Authentication requirements
- Error responses
- Rate limiting

---

See parent [README.md](../README.md) for project overview.
