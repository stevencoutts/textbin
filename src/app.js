const express = require('express');
const bodyParser = require('body-parser');
const { PrismaClient } = require('@prisma/client');
const path = require('path');

const prisma = new PrismaClient();
const app = express();

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.urlencoded({ extended: false }));

// Home - show form and recent pastes
app.get('/', async (req, res) => {
  const pastes = await prisma.paste.findMany({
    orderBy: { createdAt: 'desc' },
    take: 10,
  });
  res.render('index', { pastes });
});

// Create paste
app.post('/paste', async (req, res) => {
  const { title, content } = req.body;
  if (!title || !content) {
    return res.status(400).send('Title and content required');
  }
  const paste = await prisma.paste.create({ data: { title, content } });
  res.redirect(`/paste/${paste.id}`);
});

// View paste
app.get('/paste/:id', async (req, res) => {
  const paste = await prisma.paste.findUnique({ where: { id: req.params.id } });
  if (!paste) return res.status(404).send('Paste not found');
  res.render('paste', { paste });
});

// Search pastes
app.get('/search', async (req, res) => {
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
  res.render('search', { q, results });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`textbin running on http://localhost:${PORT}`);
}); 