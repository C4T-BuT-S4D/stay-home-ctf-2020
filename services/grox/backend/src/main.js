const koa = require('koa');
const Router = require('koa-router');

const app = new koa();
const api = new Router({
    prefix: '/api'
});

const register_routes = require('./routes');
register_routes(api);

let router = app.use(async (ctx, next) => {
    try {
        await next();
    } catch (err) {
        ctx.status = err.status || 500;
        ctx.body = err.message;
    }
});

app.use(router.routes()).use(api.allowedMethods());

function create_server() {
    return app;
}

module.exports = create_server;
