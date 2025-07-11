#!/bin/bash
set -e

# Load environment variables from .env file
if [ -f .env ]; then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

ACTION=$1
BACKUP_FILE=$2
BACKUP_DIR="prisma/backups"
DB_CONTAINER="textbin-db"
DB_USER=${POSTGRES_USER}
DB_NAME=${POSTGRES_DB}
LATEST_BACKUP=""

# Function to display usage
usage() {
    echo "Usage: $0 {backup|restore [filename]}"
    exit 1
}

# Find the latest backup file
if [ -d "$BACKUP_DIR" ]; then
    LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.dump 2>/dev/null | head -n 1)
fi

case "$ACTION" in
    backup)
        echo "Backing up database..."
        FILENAME="$BACKUP_DIR/backup_$(date +%Y-%m-%d_%H-%M-%S).dump"
        docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" -F c > "$FILENAME"
        echo "Backup created at $FILENAME"
        ;;
    restore)
        TARGET_BACKUP=${BACKUP_FILE:-$LATEST_BACKUP}
        if [ -z "$TARGET_BACKUP" ]; then
            echo "No backup file found to restore."
            exit 1
        fi
        if [ ! -f "$TARGET_BACKUP" ]; then
            echo "Backup file not found: $TARGET_BACKUP"
            exit 1
        fi
        echo "Restoring database from $TARGET_BACKUP..."
        docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d postgres -c "DROP DATABASE IF EXISTS \"$DB_NAME\" WITH (FORCE);"
        docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d postgres -c "CREATE DATABASE \"$DB_NAME\";"
        cat "$TARGET_BACKUP" | docker exec -i "$DB_CONTAINER" pg_restore -U "$DB_USER" -d "$DB_NAME"
        echo "Restore complete."
        ;;
    *)
        usage
        ;;
esac 