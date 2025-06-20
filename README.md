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

2. **Create a `.env` file:**
   Create a `.env` file in the project root with the following content (edit the password as needed):
   ```env
   POSTGRES_USER=textbin
   POSTGRES_PASSWORD=yourStrongPasswordHere
   POSTGRES_DB=textbin
   DATABASE_URL=postgres://textbin:yourStrongPasswordHere@db:5432/textbin
   ```
   > **Note:** Do not commit your `.env` file. It is already included in `.gitignore`.

3. **Run Prisma migrations:**
   ```sh
   npx prisma migrate dev --name init
   ```
   Or, if using Docker Compose:
   ```sh
   docker-compose run --rm app npx prisma migrate dev --name init --skip-seed
   ```

4. **Build for production:**
   ```sh
   ./build.sh
   ```
   This will generate the Prisma client and install only production dependencies.

5. **Start with Docker Compose:**
   ```sh
   docker-compose up --build
   ```

6. **Visit the app:**
   Open [http://localhost:3000](http://localhost:3000)

## Development
- App code is in `src/`
- Prisma schema is in `prisma/schema.prisma`
- Views are in `src/views/`
- Static files are in `src/public/`

## Environment Variables
- All secrets and DB credentials are managed in the `.env` file (not committed).
- Example `.env`:
  ```env
  POSTGRES_USER=textbin
  POSTGRES_PASSWORD=yourStrongPasswordHere
  POSTGRES_DB=textbin
  DATABASE_URL=postgres://textbin:yourStrongPasswordHere@db:5432/textbin
  ```

---

## License

This project is released under [The Unlicense](./UNLICENSE). See the UNLICENSE file for details. 