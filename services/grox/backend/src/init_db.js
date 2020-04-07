const { Pool } = require('pg');

async function init() {
    const pool = new Pool({
        user: 'grox',
        host: 'postgres',
        database: 'grox',
        password:
            '29fc24ba5c7f99a5f750bb5edfc5aa04b4dea78f70b4eaab15521e16af99398f',
        port: 5432,
    });

    await pool.query(`
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            username VARCHAR(100) NOT NULL,
            password VARCHAR(100) NOT NULL
        );
        `);

    return pool;
}

module.exports = init;
