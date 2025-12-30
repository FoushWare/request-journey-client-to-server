#!/bin/bash
# Backup PostgreSQL volume

BACKUP_DIR="./backups"
BACKUP_FILE="postgres_backup_$(date +%Y%m%d_%H%M%S).sql"

echo "Creating backup..."

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup database
docker exec notes-postgres pg_dump -U notes_user notes_db > "$BACKUP_DIR/$BACKUP_FILE"

echo "Backup created: $BACKUP_DIR/$BACKUP_FILE"

# Optional: Compress backup
gzip "$BACKUP_DIR/$BACKUP_FILE"
echo "Backup compressed: $BACKUP_DIR/$BACKUP_FILE.gz"

