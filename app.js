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

console.log("hi");

// -------- Existing name-check route ----------
app.post('/name-check', (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ error: 'Name is required.' });

  const userInput = name.trim().toLowerCase();
  const matchedName = blacklist.find(blackName => blackName.includes(userInput));

  const isBlacklisted = !!matchedName;

  res.json({
    name,
    allowed: !isBlacklisted,
    ...(isBlacklisted && { reason: `Name matches blacklist (matched with "${matchedName}")` })
  });
});

// -------- New: Save Demographics ----------
const demographicsFile = path.join(__dirname, 'demographics.json');

// Helper to load existing demographics
function loadDemographics() {
  if (!fs.existsSync(demographicsFile)) return [];
  const data = fs.readFileSync(demographicsFile, 'utf8');
  return data ? JSON.parse(data) : [];
}

// Save user demographics
app.post('/save-demographics', (req, res) => {
  const { name, dob, phoneNumber, emailId, address } = req.body;
  if (!name || !dob || !phoneNumber || !emailId || !address) {
    return res.status(400).json({ error: 'All fields are required.' });
  }

  const demographics = loadDemographics();

  // Optional: Check for existing phone number
  const exists = demographics.find(user => user.phoneNumber === phoneNumber);
  if (exists) {
    return res.status(409).json({ error: 'User with this phone number already exists.' });
  }

  demographics.push({ name, dob, phoneNumber, emailId, address });

  fs.writeFileSync(demographicsFile, JSON.stringify(demographics, null, 2));
  res.json({ message: 'Demographics saved successfully.' });
});

// -------- New: Get Demographics by phoneNumber --------
app.get('/get-demographics', (req, res) => {
  const { phoneNumber } = req.query;
  if (!phoneNumber) return res.status(400).json({ error: 'phoneNumber query param required.' });

  const demographics = loadDemographics();
  const user = demographics.find(u => u.phoneNumber === phoneNumber);

  if (!user) return res.status(404).json({ error: 'User not found.' });

  res.json(user);
});

// -------- Start Server ----------
const PORT = 3000;
app.listen(PORT, () => console.log(`✅ Server running at http://localhost:${PORT}`));
