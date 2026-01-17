# Database Schemas

Contains database schema definitions, migrations, and data design strategies for microservices.

## Organization

- **auth-service/** - Authentication service schema
- **notes-service/** - Notes service schema
- **user-service/** - User service schema
- **shared-concerns/** - Common patterns and strategies

## Data Ownership

Each service owns its data:
- **Auth Service** owns user credentials and tokens
- **Notes Service** owns note content and metadata
- **User Service** owns user profiles and settings

No cross-service direct database access. Services communicate via APIs.

## Schema Evolution

- Each service manages its own migrations
- Breaking changes require versioning strategy
- Backward compatibility guidelines documented

## Mutable vs Immutable

- **Mutable:** User profiles, note content, settings
- **Immutable:** Audit logs, events, transaction history

---

See parent [README.md](../README.md) for project overview.
