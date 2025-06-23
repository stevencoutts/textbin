# textbin

A Docker-hosted pastebin webapp with search, file attachments, and security best practices. Built with Node.js, Express, Prisma, and PostgreSQL.

---

## Features

- Submit and view text pastes
- Attach up to 10 files (max 200MB each) per paste (files stored on disk)
- Download attachments from paste view
- Search pastes by title or content (full-text search, PostgreSQL)
- Delete pastes (with attachments cleaned up)
- Rate limiting on paste creation and search
- CSRF protection on all forms
- All data stored in PostgreSQL
- Backup and restore scripts for the database
- Dockerized for easy deployment

---

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
   docker-compose run --rm app npx prisma migrate deploy
   ```
   This will apply all schema changes to your database.

4. **Build and start the app:**
   ```sh
   ./build.sh
   ```
   This will generate the Prisma client, install production dependencies, and start the app in the background.

   - For a completely clean build (removes DB, volumes, and node_modules):
     ```sh
     ./build.sh clean
     ```

5. **Visit the app:**
   Open [http://localhost:3000](http://localhost:3000)

---

## File Attachments

- You can attach up to 10 files (max 200MB each) to any paste.
- Files are stored in the `uploads/` directory (not committed to git).
- Attachments are shown and downloadable on the paste view page.

---

## Backup and Restore

A helper script `backup.sh` is provided to backup and restore the PostgreSQL database.

**Create a backup:**
```sh
./backup.sh backup
```
This will create a new `.dump` file in the `prisma/backups/` directory.

**Restore from the latest backup:**
```sh
./backup.sh restore
```

**Restore from a specific file:**
```sh
./backup.sh restore prisma/backups/backup_YYYY-MM-DD_HH-MM-SS.dump
```

---

## Development

- App code: `src/`
- Prisma schema: `prisma/schema.prisma`
- Views: `src/views/`
- Static files: `src/public/`
- File uploads: `uploads/`
- Database backups: `prisma/backups/`

---

## Environment Variables

All secrets and DB credentials are managed in the `.env` file (not committed).

Example `.env`:
```env
POSTGRES_USER=textbin
POSTGRES_PASSWORD=yourStrongPasswordHere
POSTGRES_DB=textbin
DATABASE_URL=postgres://textbin:yourStrongPasswordHere@db:5432/textbin
```

---

## Database Schema

The main models are:

```prisma
model Paste {
  id          String       @id @default(uuid())
  title       String
  content     String
  createdAt   DateTime     @default(now())
  attachments Attachment[]
}

model Attachment {
  id         String   @id @default(uuid())
  filename   String
  mimetype   String
  size       Int
  path       String
  paste      Paste    @relation(fields: [pasteId], references: [id], onDelete: Cascade)
  pasteId    String
  uploadedAt DateTime @default(now())
}
```

---

## Security

- **CSRF protection** on all forms (including file uploads)
- **Rate limiting** on paste creation and search
- **Input validation and sanitization** using `express-validator`
- **Secrets** are never committed to git

---

## Build Script

- `./build.sh` — Build and start the app in the background
- `./build.sh clean` — Remove all containers, volumes, and node_modules for a fresh build

---

## License

This project is released under [The Unlicense](./UNLICENSE). See the UNLICENSE file for details. 
