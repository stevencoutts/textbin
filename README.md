# textbin

A Docker-hosted pastebin webapp with search, built with Node.js, Express, Prisma, and PostgreSQL.

## Features
- Submit and view text pastes
- Search pastes by title or content
- All data stored in PostgreSQL

## Quick Start

1. **Clone the repo and install dependencies:**
   ```sh
   npm install
   ```

2. **Run Prisma migrations:**
   ```sh
   npx prisma migrate dev --name init
   ```

3. **Start with Docker Compose:**
   ```sh
   docker-compose up --build
   ```

4. **Visit the app:**
   Open [http://localhost:3000](http://localhost:3000)

## Development
- App code is in `src/`
- Prisma schema is in `prisma/schema.prisma`
- Views are in `src/views/`
- Static files are in `src/public/`

## Environment Variables
- `DATABASE_URL` is set in `docker-compose.yml` for local development.

---
MIT License 