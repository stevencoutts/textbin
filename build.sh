#!/bin/bash
set -e

# Resolve Docker Compose command (prefer v2: `docker compose`)
COMPOSE="docker compose"
if ! docker compose version >/dev/null 2>&1; then
    if command -v docker-compose >/dev/null 2>&1; then
        COMPOSE="docker-compose"
    else
        echo "Error: Docker Compose not found. Install docker compose plugin or docker-compose."
        exit 1
    fi
fi

echo "Using Compose command: $COMPOSE"

# Clean build function
clean_build() {
    echo "Performing a clean build..."
    echo "Stopping and removing Docker containers, volumes, and images..."
    $COMPOSE down --volumes --rmi local
    
    echo "Removing node_modules..."
    rm -rf node_modules
    
    echo "Clean build complete. Ready to build fresh."
}

# Check for 'clean' argument
if [ "$1" = "clean" ]; then
    clean_build
fi

echo "Generating Prisma client..."
npx prisma generate

echo "Installing production dependencies..."
npm install --omit=dev # Use --omit=dev for modern npm

echo "Building and starting Docker containers in detached mode..."
$COMPOSE up --build -d

echo "Build and Docker startup complete."
echo "Application is running in the background."
echo "View logs with: $COMPOSE logs -f"
echo "Stop services with: $COMPOSE down" 