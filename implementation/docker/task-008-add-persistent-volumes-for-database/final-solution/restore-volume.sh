#!/bin/bash
# Restore PostgreSQL from backup

if [ -z "$1" ]; then
    echo "Usage: $0 <backup_file.sql>"
    exit 1
fi

BACKUP_FILE=$1

echo "Restoring from backup: $BACKUP_FILE"

# Restore database
docker exec -i notes-postgres psql -U notes_user notes_db < "$BACKUP_FILE"

echo "Restore complete!"

