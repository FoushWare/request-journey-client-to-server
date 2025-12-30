# Final Solution: Microservices Database Design

This directory contains database schemas and data ownership documentation.

## Files

### Database Schemas
- `auth-db-schema.sql` - Auth service database
- `notes-db-schema.sql` - Notes service database
- `user-db-schema.sql` - User service database

### Documentation
- `data-ownership.md` - Data ownership matrix

## Key Principles

### Database Per Service
- Each service has its own database
- Full isolation
- Independent schema evolution

### Mutable Data
- User profiles, notes content (can change)
- Use version fields for optimistic locking
- Handle concurrent updates

### Immutable Data
- Audit logs, history tables (append-only)
- Prevent UPDATE/DELETE operations
- Use for debugging and compliance

## Setup

1. **Create Databases**:
   ```sql
   CREATE DATABASE auth_db;
   CREATE DATABASE notes_db;
   CREATE DATABASE user_db;
   ```

2. **Run Schemas**:
   ```bash
   psql -d auth_db -f auth-db-schema.sql
   psql -d notes_db -f notes-db-schema.sql
   psql -d user_db -f user-db-schema.sql
   ```

3. **Configure Services**:
   - Each service connects only to its own database
   - No cross-service database access

## Best Practices

- **No Foreign Keys** across services
- **Use IDs** for references only
- **API-based** data fetching between services
- **Eventual Consistency** for cross-service data

