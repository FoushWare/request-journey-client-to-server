# Task: Database - Design Database Schema

**Issue:** #16  
**Category:** Database  
**Priority:** Critical  
**Effort:** 5 days  
**Status:** Not Started

## Objective
Design normalized database schema supporting all microservices with proper relationships, indexes, and constraints.

## Description
Create comprehensive database schema with tables for users, roles, services, deployments, configurations, and audit logs.

## Sub-Tasks
- [ ] Design users table with roles
- [ ] Design services table
- [ ] Design deployments table
- [ ] Design configurations table
- [ ] Design audit_logs table
- [ ] Design monitoring metrics table
- [ ] Create proper relationships (foreign keys)
- [ ] Add constraints (unique, check)
- [ ] Create indexes for performance
- [ ] Add timestamp columns (created_at, updated_at)
- [ ] Create migration scripts
- [ ] Document schema in ERD

## Acceptance Criteria
- [ ] All tables normalized (3NF minimum)
- [ ] Foreign keys establish relationships
- [ ] Indexes created for frequently queried columns
- [ ] Migrations reversible
- [ ] Schema documented with ERD
- [ ] No data redundancy
- [ ] Performance tested

## Core Tables
```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR UNIQUE NOT NULL,
  password_hash VARCHAR NOT NULL,
  roles TEXT[] NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Services table
CREATE TABLE services (
  id UUID PRIMARY KEY,
  name VARCHAR UNIQUE NOT NULL,
  description TEXT,
  status VARCHAR,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Deployments table
CREATE TABLE deployments (
  id UUID PRIMARY KEY,
  service_id UUID REFERENCES services(id),
  version VARCHAR NOT NULL,
  status VARCHAR,
  deployed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## Indexing Strategy
```sql
-- Frequently searched columns
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_services_name ON services(name);
CREATE INDEX idx_deployments_service_id ON deployments(service_id);
CREATE INDEX idx_deployments_status ON deployments(status);
```

## References
- Database Normalization: https://en.wikipedia.org/wiki/Database_normalization
- PostgreSQL Indexing: https://www.postgresql.org/docs/current/indexes.html
- ER Diagram Tools: https://www.lucidchart.com/
