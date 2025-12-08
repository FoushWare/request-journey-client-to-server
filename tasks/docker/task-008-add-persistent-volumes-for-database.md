# Task: Docker - Add Persistent Volumes for Database

**Related Issue:** #38  
**Prerequisites:** task-003 (Docker Compose)  
**Estimated Time:** 1-2 hours  
**Notes App Context:** Configure persistent volumes for Notes App database so data survives container restarts and deletions

---

## Learning Objectives

By the end of this task, you will be able to:

- Understand Docker volumes
- Create named volumes for data persistence
- Configure volumes in docker-compose.yml
- Understand volume lifecycle
- Backup and restore volumes

---

## Theory Section

### What are Docker Volumes?

**Docker volumes** provide persistent storage for containers. Types:
- **Named volumes**: Managed by Docker (recommended)
- **Bind mounts**: Map to host directory
- **Anonymous volumes**: Temporary, removed with container

**Why This Matters for Notes App:**

Without volumes:
- Database data lost when container stops
- Users and notes disappear on restart
- No data persistence

With volumes:
- Data persists across container restarts
- Data survives `docker-compose down`
- Can backup and restore data
- Production-ready data management

---

## Prerequisites Check

- [ ] Completed task-003 (Docker Compose)
- [ ] Database service configured

---

## Step-by-Step Instructions

### Step 1: Understand Volume Requirements

**Database needs persistent storage:**
- PostgreSQL: `/var/lib/postgresql/data`
- MongoDB: `/data/db`

**Data to persist:**
- User accounts
- Notes
- Database schema
- Indexes

### Step 2: Create Named Volume in docker-compose.yml

**Add volumes section:**
```yaml
services:
  db:
    volumes:
      - postgres_data:/var/lib/postgresql/data
    # For MongoDB:
    # - mongo_data:/data/db

volumes:
  postgres_data:
    driver: local
    name: notes-app-postgres-data
```

### Step 3: Verify Volume Creation

**Check volumes:**
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect notes-app-postgres-data

# Check volume location
# Linux: /var/lib/docker/volumes/notes-app-postgres-data/_data
# Mac/Windows: Managed by Docker Desktop
```

### Step 4: Test Data Persistence

**Test persistence:**
```bash
# Start services
docker-compose up -d

# Create test data (register user, create note)
# Via Notes App UI

# Stop and remove containers (but keep volumes)
docker-compose down

# Start again
docker-compose up -d

# Verify data still exists
# User and notes should still be there
```

### Step 5: Backup Volume Data

**Backup PostgreSQL:**
```bash
# Create backup
docker-compose exec db pg_dump -U notesuser notesapp > backup.sql

# Or backup volume directly
docker run --rm -v notes-app-postgres-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/postgres-backup.tar.gz /data
```

**Restore:**
```bash
# Restore from SQL dump
docker-compose exec -T db psql -U notesuser notesapp < backup.sql
```

### Step 6: Use Bind Mounts (Alternative)

**For development (bind mount):**
```yaml
services:
  db:
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
      # Maps host directory to container
```

**Pros**: Easy access from host
**Cons**: Path issues on different OS, permissions

**Recommendation**: Use named volumes for production

---

## Notes App Specifics

- Database volume: `postgres_data` or `mongo_data`
- Stores all Notes App data
- Persists across deployments
- Can be backed up and restored
- Essential for production

---

## Verification

- [ ] Volume defined in docker-compose.yml
- [ ] Volume created: `docker volume ls | grep postgres`
- [ ] Data persists after `docker-compose down`
- [ ] Data persists after container restart
- [ ] Can backup volume data
- [ ] Notes App data survives restarts

---

## Troubleshooting

**Issue: Data lost after restart**
- Verify volume is mounted correctly
- Check volume exists: `docker volume ls`
- Verify mount path in container: `docker-compose exec db ls -la /var/lib/postgresql/data`

**Issue: Permission denied**
- Named volumes handle permissions automatically
- Bind mounts may need: `chown` or user mapping

**Issue: Volume not found**
- Create volume manually: `docker volume create notes-app-postgres-data`
- Or let docker-compose create it

---

## Best Practices

1. **Named Volumes**: Use for production (managed by Docker)
2. **Backup Regularly**: Set up backup strategy
3. **Volume Naming**: Use descriptive names
4. **Separate Volumes**: One volume per database/service
5. **Documentation**: Document backup/restore procedures

---

## Next Steps

- Task 009: Configure Container Logging
- Phase 2: Kubernetes PersistentVolumes
- Phase 6: Terraform for volume provisioning

---

**Task Status:** [ ] Not Started | [ ] In Progress | [ ] Completed

