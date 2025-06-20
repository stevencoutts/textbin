#!/bin/bash
set -e

# Wait for the database to be ready
echo "Waiting for database to be ready..."
while ! nc -z textbin-db 5432; do
  sleep 1
done
echo "Database is ready."

# Run migrations
echo "Running database migrations..."
npx prisma migrate deploy

# Start the main process
echo "Starting application..."
exec "$@" 