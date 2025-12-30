# Final Solution: Add Persistent Volumes for Database

This directory contains the complete solution for persistent volumes.

## Files

### `docker-compose.yml`
- Defines named volume `postgres_data`
- Mounts volume to `/var/lib/postgresql/data`
- Data persists across container restarts

### `backup-volume.sh`
- Script to backup database
- Creates timestamped SQL dumps

### `restore-volume.sh`
- Script to restore from backup

## Usage

1. **Start services**:
   ```bash
   docker-compose up -d
   ```

2. **Create some data** (add notes via app)

3. **Stop and remove container**:
   ```bash
   docker-compose down
   ```

4. **Start again**:
   ```bash
   docker-compose up -d
   ```

5. **Verify data persisted** (check notes are still there)

## Volume Management

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect notes-app_postgres_data

# Remove volume (WARNING: deletes data)
docker volume rm notes-app_postgres_data
```

## Backup

```bash
chmod +x backup-volume.sh
./backup-volume.sh
```

## Benefits

- Data survives container restarts
- Easy backups
- Volume management
- Data isolation

