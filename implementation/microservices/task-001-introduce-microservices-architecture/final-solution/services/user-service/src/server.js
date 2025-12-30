const express = require('express');
const { Pool } = require('pg');
const axios = require('axios');

const app = express();
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST || 'user-db',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'user_db',
  user: process.env.DB_USER || 'user_user',
  password: process.env.DB_PASSWORD,
});

// Middleware to validate token
async function validateToken(req, res, next) {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }
    
    const response = await axios.post(
      `http://${process.env.AUTH_SERVICE_URL || 'auth-service:3001'}/auth/validate`,
      { token }
    );
    
    if (!response.data.valid) {
      return res.status(401).json({ error: 'Invalid token' });
    }
    
    req.userId = response.data.userId;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Token validation failed' });
  }
}

// Get user profile
app.get('/users/profile/:userId', validateToken, async (req, res) => {
  try {
    const { userId } = req.params;
    // Only allow users to view their own profile
    if (req.userId !== parseInt(userId)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    
    const result = await pool.query(
      'SELECT id, name, email, created_at FROM users WHERE id = $1',
      [userId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update user profile
app.put('/users/profile/:userId', validateToken, async (req, res) => {
  try {
    const { userId } = req.params;
    const { name } = req.body;
    
    if (req.userId !== parseInt(userId)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    
    const result = await pool.query(
      'UPDATE users SET name = $1 WHERE id = $2 RETURNING id, name, email',
      [name, userId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

const PORT = process.env.PORT || 3003;
app.listen(PORT, () => {
  console.log(`User Service running on port ${PORT}`);
});

