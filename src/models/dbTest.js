const db = require('./db');
require('dotenv').config();

async function testConnection() {
    try {
        const [rows] = await db.query('SELECT 1 + 1 AS result');
        console.log('Database connected: ',  rows[0].result);
    } catch (err) {
        console.error('Database connection failed: ', err.message);
    } finally {
        process.exit();
    }
}

testConnection();