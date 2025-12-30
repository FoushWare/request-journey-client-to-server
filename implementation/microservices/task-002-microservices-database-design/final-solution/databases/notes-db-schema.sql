-- Notes Service Database Schema
-- Database: notes_db
-- Owner: Notes Service

CREATE TABLE notes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL, -- Reference to user (no foreign key - different service)
    title VARCHAR(255) NOT NULL,
    content TEXT,
    version INTEGER DEFAULT 1, -- Optimistic locking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for user's notes
CREATE INDEX idx_notes_user_id ON notes(user_id);

-- Audit log (immutable)
CREATE TABLE notes_audit_log (
    id SERIAL PRIMARY KEY,
    note_id INTEGER,
    user_id INTEGER,
    action VARCHAR(50) NOT NULL, -- 'create', 'update', 'delete'
    old_value JSONB,
    new_value JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prevent updates/deletes
CREATE RULE prevent_audit_update AS ON UPDATE TO notes_audit_log DO INSTEAD NOTHING;
CREATE RULE prevent_audit_delete AS ON DELETE TO notes_audit_log DO INSTEAD NOTHING;

