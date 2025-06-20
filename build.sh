#!/bin/sh
set -e

echo "Generating Prisma client..."
npx prisma generate
echo "Installing production dependencies..."
npm install --production

echo "Building and starting Docker containers..."
docker-compose up --build

echo "Build and Docker startup complete." 