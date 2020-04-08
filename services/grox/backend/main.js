const PORT = 3000;

async function run(port) {
    const init_db = require('./src/init_db');
    const create_server = require('./src/main');
    const pool = await init_db();
    const app = create_server(pool);
    console.log(`Listening on port ${port}!`);
    app.listen(port);
}

run(PORT);
