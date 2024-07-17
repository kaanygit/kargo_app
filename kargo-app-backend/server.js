const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');

const app = express();
app.use(bodyParser.json());

const pool = new Pool({
    user: 'kargo-app', 
    host: '$$$$$$$', 
    database: 'kargo-app-db',  
    password: '$$$$$$$',
    port: 5432,
  });
  
app.post('/signup', async (req, res) => {
  const { username, password } = req.body;
  try {
    const newUser = await pool.query(
      'INSERT INTO users (username, password) VALUES ($1, $2) RETURNING *',
      [username, password]
    );
    res.status(201).json(newUser.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

app.post('/signin', async (req, res) => {
  const { username, password } = req.body;
  try {
    const user = await pool.query(
      'SELECT * FROM users WHERE username = $1 AND password = $2',
      [username, password]
    );
    if (user.rows.length > 0) {
      res.status(200).json(user.rows[0]);
    } else {
      res.status(400).json({ message: 'Invalid Credentials' });
    }
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
