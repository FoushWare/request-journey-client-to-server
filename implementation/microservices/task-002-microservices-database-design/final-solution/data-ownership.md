# Data Ownership Matrix

## Auth Service → auth_db

**Owns:**
- User authentication data (email, password_hash)
- Auth audit logs

**Can Access:**
- Only its own database (auth_db)

**Cannot Access:**
- notes_db
- user_db

## Notes Service → notes_db

**Owns:**
- Notes (id, user_id, title, content)
- Notes audit logs

**Can Access:**
- Only its own database (notes_db)
- Auth Service API (for token validation)

**Cannot Access:**
- auth_db (directly)
- user_db (directly)

## User Service → user_db

**Owns:**
- User profiles (name, profile_data)
- Profile change history

**Can Access:**
- Only its own database (user_db)
- Auth Service API (for token validation)

**Cannot Access:**
- auth_db (directly)
- notes_db (directly)

## Cross-Service Data Access

- **No direct database access** between services
- **API-based access only**:
  - Notes Service validates tokens via Auth Service API
  - User Service validates tokens via Auth Service API
  - Frontend fetches user profile via User Service API

## Data Consistency

- **Eventual consistency** between services
- No distributed transactions
- Use Saga pattern for complex operations (see task-006)

