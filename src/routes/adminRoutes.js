const express = require('express');
const router = express.Router();
const {authenticate, authorizeAdmin} = require('../middleware/authMiddleware');
const adminController = require('../controllers/adminController');

router.post('/allUsers', authenticate, authorizeAdmin, adminController.allUsers);

module.exports = router;