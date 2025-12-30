# Task: Microservices - Database Design & Data Ownership

**Related Issue:** #135  
**Prerequisites:** task-001 (Microservices architecture)  
**Estimated Time:** 4-5 hours  
**Notes App Context:** Design and implement database strategy for Notes App microservices, implementing database-per-service pattern, data ownership boundaries, and handling mutable vs immutable data

---

## Learning Objectives

- Understand database-per-service pattern
- Design data ownership boundaries
- Implement separate databases per service
- Handle mutable vs immutable data
- Understand eventual consistency
- Design schema evolution strategies

---

## Theory Section

### Database Strategy for Microservices

**Database Per Service (Recommended):**
- Each service owns its database
- Full data isolation
- Independent schema evolution
- No cross-service database access

**Why This Matters:**
- Services can't break each other's data
- Independent scaling
- Technology flexibility per service
- Clear ownership

**Data Ownership:**
- Auth Service → auth_db (users table for auth)
- Notes Service → notes_db (notes table)
- User Service → user_db (users table for profiles)

**Mutable vs Immutable Data:**
- **Mutable**: User profiles, note content (can change)
- **Immutable**: Audit logs, events (append-only)

---

## Step-by-Step Instructions

### Step 1: Define Data Ownership

**Objective:** Document which service owns which data

**Instructions:**
1. Create data ownership matrix
2. Document ownership rules
3. Forbid cross-service DB access

### Step 2: Create Separate Databases

**Objective:** Set up database per service

**Instructions:**
1. Create auth_db for Auth Service
2. Create notes_db for Notes Service
3. Create user_db for User Service
4. Configure connection strings per service

### Step 3: Design Schemas

**Objective:** Design tables per service

**Instructions:**
1. Design auth_db schema (users: id, email, password_hash)
2. Design notes_db schema (notes: id, user_id, content, created_at)
3. Design user_db schema (users: id, name, profile_data)
4. Avoid foreign keys across services

### Step 4: Implement Mutable Data Handling

**Objective:** Handle data that can change

**Instructions:**
1. Add version fields for optimistic locking
2. Handle concurrent updates
3. Add update timestamps

### Step 5: Implement Immutable Data

**Objective:** Create append-only data structures

**Instructions:**
1. Create audit_logs table (append-only)
2. Create events table (append-only)
3. Prevent UPDATE/DELETE operations

---

## Verification

1. Three separate databases created
2. Each service connects to own database
3. No cross-service database access
4. Mutable and immutable data handled correctly

---

## Task Checklist

- [ ] Defined data ownership
- [ ] Created separate databases
- [ ] Designed schemas per service
- [ ] Implemented mutable data handling
- [ ] Implemented immutable data
- [ ] Verified isolation

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

