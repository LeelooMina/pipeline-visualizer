const express = require('express');
const router = express.Router();
const { authUser } = require('../services/auth');

router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const token = await authUser(email, password);
    console.log(token);
    res.status(200).json({ token });
  } catch (error) {
    res.status(401).json({ message: 'Invalid credentials' });
  }
});

module.exports = router;