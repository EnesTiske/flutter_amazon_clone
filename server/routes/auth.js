const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");

authRouter.get("/user", (req, res) => {
  res.send("Hello from user");
});

// Sign Up
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ message: "User with same email already exists" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      name,
      email,
      password: hashedPassword,
    });

    user = await user.save();
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Sign In
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    const isMatch = bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password!" });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Token Validation
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);

    return res.json(true);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get User DAta
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});

// Temporary Map to store QR tokens
const qrTokens = new Map();

// Helper function to generate random session ID
const generateSessionId = () => {
  return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
};

// QR token generation endpoint
authRouter.post('/api/generate-qr-token', (req, res) => {
  try {
    // Create a simple session ID
    const sessionId = generateSessionId();
    
    // Store the session and set status as 'pending'
    qrTokens.set(sessionId, {
      status: 'pending',
      createdAt: Date.now()
    });

    // Clear session after 30 seconds
    setTimeout(() => {
      qrTokens.delete(sessionId);
    }, 30000);

    res.json({ token: sessionId });
  } catch (error) {
    res.status(500).json({ message: 'Error occurred while generating token' });
  }
});

// QR token status check endpoint
authRouter.get('/api/check-qr-status/:token', (req, res) => {
  const { token } = req.params;
  const sessionData = qrTokens.get(token);

  if (!sessionData) {
    return res.json({ status: 'expired' });
  }

  res.json({ 
    status: sessionData.status,
    ...(sessionData.status === 'authenticated' ? {
      token: sessionData.authToken,
      userInfo: sessionData.userInfo
    } : {})
  });
});

// QR code verification endpoint from mobile app
authRouter.post('/api/verify-qr-token', async (req, res) => {
  const { qrToken, userInfo } = req.body;

  if (!qrTokens.has(qrToken)) {
    return res.status(400).json({ message: 'Invalid or expired QR token' });
  }

  try {
    // Create a new auth token for user
    const authToken = jwt.sign({ 
      email: userInfo.email,
      userId: userInfo.userId 
    }, "passwordKey", { expiresIn: '7d' });

    // Update session status
    qrTokens.set(qrToken, {
      status: 'authenticated',
      authToken,
      userInfo,
      authenticatedAt: Date.now()
    });

    res.json({ message: 'QR code successfully verified' });
  } catch (error) {
    res.status(500).json({ message: 'Error occurred during verification' });
  }
});

module.exports = authRouter;
