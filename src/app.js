const express = require('express');
const bodyParser = require('body-parser');
const { PrismaClient } = require('@prisma/client');
const path = require('path');
const { body, validationResult } = require('express-validator');
const rateLimit = require('express-rate-limit');
const csrf = require('csurf');
const cookieParser = require('cookie-parser');

const prisma = new PrismaClient();
const app = express();

// Rate limiting
const createPasteLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 10, // limit each IP to 10 create requests per minute
  message: 'Too many pastes created from this IP, please try again later.'
});
const searchLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 30, // limit each IP to 30 searches per minute
  message: 'Too many searches from this IP, please try again later.'
});

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(csrf({ cookie: true }));

// Home - show form and recent pastes
app.get('/', async (req, res) => {
  const pastes = await prisma.paste.findMany({
    orderBy: { createdAt: 'desc' },
    take: 10,
  });
  res.render('index', { pastes, csrfToken: req.csrfToken(), errors: [], old: {} });
});

// Create paste
app.post('/paste', createPasteLimiter, [
  body('title')
    .trim()
    .isLength({ min: 1, max: 100 }).withMessage('Title is required and must be at most 100 characters.')
    .escape(),
  body('content')
    .trim()
    .isLength({ min: 1, max: 10000 }).withMessage('Content is required and must be at most 10,000 characters.')
    .escape()
], async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    // Re-render with errors
    const pastes = await prisma.paste.findMany({ orderBy: { createdAt: 'desc' }, take: 10 });
    return res.status(400).render('index', {
      pastes,
      csrfToken: req.csrfToken(),
      errors: errors.array(),
      old: req.body
    });
  }
  const { title, content } = req.body;
  const paste = await prisma.paste.create({ data: { title, content } });
  res.redirect(`/paste/${paste.id}`);
});

// View paste
app.get('/paste/:id', async (req, res) => {
  const paste = await prisma.paste.findUnique({ where: { id: req.params.id } });
  if (!paste) return res.status(404).send('Paste not found');
  res.render('paste', { paste, csrfToken: req.csrfToken() });
});

// Delete paste
app.post('/paste/:id/delete', async (req, res) => {
  try {
    await prisma.paste.delete({
      where: { id: req.params.id },
    });
    res.redirect('/');
  } catch (error) {
    // P2025 is Prisma's code for "Record to delete does not exist."
    if (error.code === 'P2025') {
      return res.status(404).send('Paste not found.');
    }
    // Handle other potential errors
    res.status(500).send('Error deleting paste.');
  }
});

// Search pastes
app.get('/search', searchLimiter, async (req, res) => {
  const { q } = req.query;
  let results = [];
  if (q) {
    // Use full-text search in PostgreSQL
    const searchTerm = q.trim().split(/\s+/).join(' & '); // AND all terms
    results = await prisma.$queryRaw`
      SELECT * FROM "Paste"
      WHERE to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, '')) @@ to_tsquery('english', ${searchTerm})
      ORDER BY "createdAt" DESC
      LIMIT 20;
    `;
  }
  res.render('search', { q, results, csrfToken: req.csrfToken() });
});

// Error handler for CSRF
app.use((err, req, res, next) => {
  if (err.code === 'EBADCSRFTOKEN') {
    return res.status(403).send('Form tampered with.');
  }
  next(err);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`textbin running on http://localhost:${PORT}`);
}); 