-- User Service Database Schema
-- Database: user_db
-- Owner: User Service

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL, -- Denormalized from auth service
    profile_data JSONB, -- Flexible profile fields
    version INTEGER DEFAULT 1, -- Optimistic locking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for email lookup
CREATE INDEX idx_users_email ON users(email);

-- Profile change history (immutable)
CREATE TABLE profile_history (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    changed_field VARCHAR(100),
    old_value TEXT,
    new_value TEXT,
    changed_by INTEGER, -- User who made the change
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prevent updates/deletes
CREATE RULE prevent_history_update AS ON UPDATE TO profile_history DO INSTEAD NOTHING;
CREATE RULE prevent_history_delete AS ON DELETE TO profile_history DO INSTEAD NOTHING;

