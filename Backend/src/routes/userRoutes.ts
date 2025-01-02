import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import User from '../models/User';

const router = express.Router();

//userRegisteration
router.post('/users/register', async (req, res) => {
  try {
    const { username, password, role } = req.body;

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      username,
      password: hashedPassword,
      role: role || 'patron',
    });

    await newUser.save();

    res.status(201).json({ message: 'User registered successfully' });
  } catch (error: any) {
    console.error(error.message);
    res.status(500).json({ error: 'Failed to register user' });
  }
});

// UserLogin
router.post('/users/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    // Checking Existing User
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(401).json({ error: 'Invalid username or password' });
    }

    // Checking Password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid username or password' });
    }

    // JWT for Authentication
    const token = jwt.sign(
      {
        userId: user._id,
        role: user.role,
      },
      process.env.JWT_SECRET || 'secretKey',
      { expiresIn: '1h' }
    );

    res.status(200).json({
      message: 'Login successful',
      token: token,
      role: user.role,
    });
  } catch (error: any) {
    console.error(error.message);
    res.status(500).json({ error: 'Failed to login user' });
  }
});

export default router;
