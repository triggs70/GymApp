const bcrypt = require('bcrypt');
const db = require('../models/db');
const jwt = require('jsonwebtoken');

exports.register = async (req,res) => {
    const {username, email, firstName, lastName, password} = req.body;
    try {
        //Check for existing credentials
        const [rows] = await db.query('SELECT * FROM users WHERE username = ? or email = ?', [username,email]);
        if (rows.length > 0) {
            return res.status(400).json({ message: 'Username or email already in use'});
        }
        //Hash Password
        const hashedPass = await bcrypt.hash(password,15);
        //Insert new user into db
        await db.query('INSERT INTO users (username, email, firstName, lastName, passwordHash) VALUES (?, ?, ?, ?, ?)',
            [username, email, firstName, lastName, hashedPass]
        );
        res.status(201).json({message: 'User registered successfully'});
    } catch (err) {
        console.error(err);
        res.status(500).json({message: 'Server error'});
    }
};

exports.login = async (req, res) => {
    const {email, password} = req.body;
    try {
        //Find user be email
        const [rows] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        if (rows.length === 0) {
            return res.status(404).json({message: 'User not found'});
        }
        //Verify user
        const user = rows[0];
        const isMatch = await bcrypt.compare(password, user.passwordHash);
        if (!isMatch) {
            return res.status(400).json({message: 'Invalid password'});
        }
        //Generate JWT token
        const token = jwt.sign(
            {userID: user.userID, username: user.username, isAdmin: user.isAdmin},
            process.env.JWT_SECRET,
            {expiresIn: '1h'}
        );
        res.status(200).json({token});
    } catch (err) {
        console.error(err);
        res.status(500).json({message: 'Server error'});
    }
};