const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(express.json());

// Load blacklist
let blacklist = [];
try {
  const data = fs.readFileSync(path.join(__dirname, 'blacklist.json'), 'utf8');
  blacklist = JSON.parse(data).map(n => n.toLowerCase());
  console.log(`✅ Loaded ${blacklist.length} names into blacklist.`);
} catch (err) {
  console.error('❌ Error loading blacklist:', err);
  process.exit(1);
}

// API Endpoint
app.post('/name-check', (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ error: 'Name is required.' });

  const isBlacklisted = blacklist.includes(name.trim().toLowerCase());
  res.json({
    name,
    allowed: !isBlacklisted,
    ...(isBlacklisted && { reason: 'Name matches blacklist' })
  });
});

// Start server
const PORT = 3000;
app.listen(PORT, () => console.log(`✅ Server running at http://localhost:${PORT}`));
