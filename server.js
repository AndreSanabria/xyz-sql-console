const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
const PORT = 3000;

app.use(express.static('public'));
app.use(express.json());

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'xyz_user',         // replace with your MySQL username
  password: 'xyz_password', // replace with your MySQL password
  database: 'XYZ'           // use your actual DB name
});

app.post('/query', (req, res) => {
  const { sql } = req.body;
  if (!sql) return res.status(400).json({ error: 'No SQL query provided.' });

  connection.query(sql, (err, results, fields) => {
    if (err) {
      return res.status(400).json({ error: err.sqlMessage || err.message });
    }
    res.json({ results, fields });
  });
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
