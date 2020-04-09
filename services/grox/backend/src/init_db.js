const { Pool } = require('pg');

async function init() {
    const sleep = (time) =>
        new Promise((resolve) => setTimeout((_) => resolve(), time));

    const pool = new Pool({
        user: 'grox',
        host: 'postgres',
        database: 'grox',
        password:
            '29fc24ba5c7f99a5f750bb5edfc5aa04b4dea78f70b4eaab15521e16af99398f',
        port: 5432,
    });

    while (true) {
        try {
            await pool.connect();
            break;
        } catch (_) {
            await sleep(1000);
        }
    }

    await pool.query(`
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        username VARCHAR(100) NOT NULL,
        password VARCHAR(100) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS empires (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        gid INTEGER NOT NULL
    );

    CREATE TABLE IF NOT EXISTS planets (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        info VARCHAR(100) NOT NULL,
        nid INTEGER NOT NULL
    );
    `);

    return pool;
}

module.exports = init;
