#!/bin/bash
set -e

# Clean build function
clean_build() {
    echo "Performing a clean build..."
    echo "Stopping and removing Docker containers, volumes, and images..."
    docker-compose down --volumes --rmi local
    
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
docker-compose up --build -d

echo "Build and Docker startup complete."
echo "Application is running in the background."
echo "View logs with: docker-compose logs -f"
echo "Stop services with: docker-compose down" 