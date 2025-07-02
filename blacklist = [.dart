blacklist = [
  "Dawood Ibrahim",
  "Chhota Shakeel",
  "Hafiz Saeed",
  "Zakiur Rehman Lakhvi",
  "Masood Azhar",
  "Syed Salahuddin",
  "Sajid Mir",
  "Abdul Karim Tunda",
  "Ibrahim Athar",
  "Maulana Masood Azhar",
  "Anees Ibrahim",
  "Mohammed Yahya Mujahid",
  "Fazlur Rehman Khalil",
  "Mohammad Saeed",
  "Vijay Mallya",
  "Mehul Choksi",
  "Nirav Modi",
  "Lalit Modi",
  "Sandesara Brothers",
  "Jatin Mehta",
  "Deepak Kochhar",
  "Rana Kapoor",
  "Sanjay Chandra",
  "Subrata Roy",
  "Ramalinga Raju",
  "Nitin Sandesara",
  "Chetan Sandesara",
  "Karti Chidambaram",
  "Yasin Bhatkal",
  "Fayaz Kagzi",
  "Ariz Khan",
  "Simi Ahmed",
  "Iqbal Bhatkal",
  "Riyaz Bhatkal",
  "Syed Zabiuddin Ansari",
  "Abdul Subhan Qureshi",
  "Mohammed Shahid Bilal",
  "Sultan Armar",
  "Shafi Armar",
  "Mufti Abdul Rauf Asghar",
  "Amjad Khan",
  "Faisal Haroon",
  "Ibrahim Musa",
  "Noor Wali Mehsud",
  "Ayman al-Zawahiri",
  "Abu Bakr al-Baghdadi",
  "Zakir Musa",
  "Burhan Wani",
  "Abdul Rehman Makki",
  "Hammad Azhar",
  "Zulfiqar Babar",
  "Maqbool Sherwani",
  "Gulzar Ahmed Bhat",
  "Abid Bashir Khan",
  "Adil Ahmad Dar",
  "Mujahid Ahmad Khan",
  "Mohammad Shafi",
  "Ali Mohammad Bhat",
  "Farooq Ahmed Dar",
  "Mohammad Ashraf Khan",
  "Syed Ali Shah Geelani",
  "Asiya Andrabi",
  "Shabir Ahmad Shah",
  "Masarat Alam Bhat",
  "Yasin Malik",
  "Bilal Ahmed Kawa",
  "Mohammad Abbas Bhat",
  "Irfan Ahmed Dar",
  "Fayaz Ahmad Lone",
  "Mohammad Shafi Shah",
  "Showkat Ahmad Parray",
  "Bashir Ahmad Bhat",
  "Ghulam Nabi Khan",
  "Mohammad Yasin Bhat",
  "Syed Manzoor Ahmad",
  "Zubair Ahmad Sheikh",
  "Ghulam Mohammad Bhat",
  "Nisar Ahmad Bhat",
  "Javed Ahmad Khan",
  "Aijaz Ahmad Mir",
  "Mohammad Afzal Guru",
  "Maulvi Abdul Hameed",
  "Reyaz Ahmad Dar",
  "Tariq Ahmed Bhat",
  "Fayaz Ahmad Bhat",
  "Gulzar Ahmad Bhat",
  "Riyaz Ahmad Naikoo",
  "Sajad Ahmad Bhat",
  "Mehmood Ahmad Khan",
  "Waseem Ahmed Shah",
  "Shahid Bashir Sheikh",
  "Mushtaq Ahmad Lone",
  "Umar Khalid",
  "Anis Ansari",
  "Shahrukh Pathan",
  "Shafiqur Rahman",
  "Zulfikar Ali",
  "Shabbir Gangster",
  "Iqbal Kaskar",
  "Feroz Khan",
  "Wasim Sheikh",
  "Nadeem Saifi",
  "Samiullah Khan",
  "Junaid Khan",
  "Salim Khan",
  "Arman Ali",
  "Faizan Ahmed",
  "Azharuddin Khan"
]

const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();

app.use(express.json());

// Load Blacklist
const blacklist = JSON.parse(
  fs.readFileSync(path.join(__dirname, 'db', 'blacklist.json'))
).map(n => n.toLowerCase());

// POST API - Name Screening
app.post('/name-check', (req, res) => {
  const { name } = req.body;

  if (!name) return res.status(400).json({ error: 'Name is required in body.' });

  const isBlacklisted = blacklist.includes(name.trim().toLowerCase());

  return res.json({
    name,
    allowed: !isBlacklisted,
    ...(isBlacklisted && { reason: 'Name matches blacklist' })
  });
});

// Start Server
app.listen(3000, () => console.log('Name Screening API running on port 3000'));

