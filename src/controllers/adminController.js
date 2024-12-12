const db = require('../models/db');

exports.allUsers = async (req, res) => {
    try {
        const [users] = await db.query('SELECT userID, username, email, firstName, lastName, registeredOn, isAdmin FROM users');
        res.status(200).json(users);
    } catch (err) {
        console.error(err);
        res.status(500).json({message: 'Server error'});
    }
};