const Koa = require('koa');
const Router = require('koa-router');
const convert = require('koa-convert');
const session = require('koa-session');
const Lru = require('lru-cache');
const bodyParser = require('koa-bodyparser');
const cash = require('koa-cash');
const helpers = require('./helpers');
const http = require('http');

const app = new Koa();

app.use(helpers());

app.use(async (ctx, next) => {
    ctx.type = 'application/json';
    ctx.resp = function (code, message) {
        ctx.status = code;
        ctx.body = message;
    };
    await next();
});

app.use(async (ctx, next) => {
    try {
        await next();
    } catch (err) {
        ctx.resp(500, {
            error: err.message,
        });
    }
});

const cache = new Lru({
    max: 1337,
    maxAge: 1337,
});

app.use(
    convert(
        cash({
            get: (key) => cache.get(key),
            set: (key, value) => cache.set(key, value),
        })
    )
);

app.use(
    bodyParser({
        enableTypes: ['json'],
    })
);

app.keys = [process.env.KEY];

app.use(
    session(
        {
            key: 'session',
            maxAge: 1000 * 24 * 60 * 60,
            httpOnly: true,
            renew: true,
        },
        app
    )
);

app.use(async (ctx, next) => {
    ctx.auth = ctx.session.id !== undefined;
    await next();
});

app.use(async (ctx, next) => {
    ctx.get = (url) => {
        return new Promise((resolve, reject) => {
            let data = '';
            let req = http
                .request(url, (res) => {
                    res.setEncoding('utf8');
                    res.on('data', (chunk) => {
                        data += chunk;
                    });
                    res.on('end', () => {
                        try {
                            let pdata = JSON.parse(data);
                            resolve(pdata);
                        } catch (_) {
                            reject();
                        }
                    });
                })
                .on('error', (err) => {
                    reject(err);
                })
                .setTimeout(5000);

            req.end();
        });
    };

    ctx.post = (url, body = null) => {
        return new Promise((resolve, reject) => {
            let data = '';
            let req = http
                .request(url, (res) => {
                    res.setEncoding('utf8');
                    res.on('data', (chunk) => {
                        data += chunk;
                    });
                    res.on('end', () => {
                        try {
                            let pdata = JSON.parse(data);
                            resolve(pdata);
                        } catch (_) {
                            reject();
                        }
                    });
                })
                .on('error', (err) => {
                    reject(err);
                })
                .setTimeout(5000);

            req.method = 'POST';
            req.setHeader('Content-Type', 'application/json');

            if (body !== null) {
                const payload = JSON.stringify(body);
                req.setHeader('Content-Length', Buffer.byteLength(payload));
                req.write(payload, () => {
                    req.end();
                });
            } else {
                req.end();
            }
        });
    };

    await next();
});

app.use(async (ctx, next) => {
    ctx.unwrap = function (data) {
        const ok = data.error === undefined;
        if (ok) {
            ctx.data = data.ok;
            return false;
        } else {
            ctx.resp(400, {
                error: data.error,
            });
            return true;
        }
    };

    await next();
});

const api = new Router({
    prefix: '/api',
});

const register_routes = require('./routes');
register_routes(api);

app.use(api.routes()).use(api.allowedMethods());

function create_server(pool) {
    app.context.pool = pool;
    return app;
}

module.exports = create_server;
