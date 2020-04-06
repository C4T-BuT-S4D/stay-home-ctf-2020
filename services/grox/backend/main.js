const PORT = 3000;

const create_server = require('./src/main');
const app = create_server();
console.log(`Listening on port ${PORT}!`);
app.listen(PORT);
