function register_routes(router) {
    router.post('/register', async (ctx) => {
        const { username: u = null, password: p = null } = ctx.request.body;

        if (!u || !p) {
            ctx.resp(403, {
                error: 'No username or password',
            });
            return;
        }

        const [id = null] = await ctx.get_user(u);

        if (id !== null) {
            ctx.resp(403, {
                error: 'User already exists',
            });
            return;
        }

        await ctx.add_user(u, p);

        ctx.resp(200, {
            ok: 'User created',
        });
    });

    router.post('/login', async (ctx) => {
        const { username: u = null, password: p = null } = ctx.request.body;

        if (!u || !p) {
            ctx.resp(403, {
                error: 'No username or password',
            });
            return;
        }

        const [id = null, password = null] = await ctx.get_user(u);

        if (id === null) {
            ctx.resp(403, {
                error: 'No such user',
            });
            return;
        }

        if (password !== p) {
            ctx.resp(403, {
                error: 'Invalid password',
            });
            return;
        }

        ctx.session.id = id;

        ctx.resp(200, {
            ok: 'Success',
        });
    });

    router.get('/me', async (ctx) => {
        if (!ctx.auth) {
            ctx.resp(403, {
                error: 'Not authorized',
            });
            return;
        }

        const { id: uid } = ctx.session;

        const [{ username = null } = {}] = (
            await ctx.pool.query(
                `
            SELECT username FROM users WHERE id=$1
        `,
                [uid]
            )
        ).rows;

        ctx.resp(200, {
            ok: {
                id: uid,
                username,
            },
        });
    });

    router.post('/logout', async (ctx) => {
        ctx.session = null;

        ctx.resp(200, {
            ok: 'Success',
        });
    });

    router.get('/user/list', async (ctx) => {
        const cashed = await ctx.cashed();
        if (cashed) return;

        const users = await ctx.list_users();

        ctx.resp(200, {
            ok: users,
        });
    });

    router.get('/user/:id/empires', async (ctx) => {
        const cashed = await ctx.cashed();
        if (cashed) return;

        const { id: uid } = ctx.params;

        if (
            ctx.unwrap(await ctx.get(`http://owner:8001/api/graph_list/${uid}`))
        ) {
            return;
        }

        ctx.resp(200, {
            ok: ctx.data,
        });
    });

    router.post('/empire/create', async (ctx) => {
        if (!ctx.auth) {
            ctx.resp(403, {
                error: 'Not authorized',
            });
            return;
        }

        const { name = null } = ctx.request.body;

        if (!name) {
            ctx.resp(400, {
                error: 'No empire name',
            });
            return;
        }

        const { id: uid } = ctx.session;

        if (ctx.unwrap(await ctx.post(`http://graph:8000/api/create_graph/`))) {
            return;
        }

        const gid = ctx.data;

        if (
            ctx.unwrap(
                await ctx.post(`http://owner:8001/api/graph_set/`, {
                    uid,
                    gid,
                })
            )
        ) {
            return;
        }

        await ctx.add_empire(gid, name);

        ctx.resp(200, {
            ok: gid,
        });
    });

    router.post('/planet/create', async (ctx) => {
        if (!ctx.auth) {
            ctx.resp(403, {
                error: 'Not authorized',
            });
            return;
        }

        const { name = null, info = null } = ctx.request.body;

        if (!name || !info) {
            ctx.resp(400, {
                error: 'No planet name or info',
            });
            return;
        }

        const { graph = null } = ctx.request.body;

        if (!graph) {
            ctx.resp(403, {
                error: 'No graph id',
            });
            return;
        }

        const { id: uid } = ctx.session;

        if (
            ctx.unwrap(
                await ctx.post(`http://graph:8000/api/create_node/`, {
                    graph,
                })
            )
        ) {
            return;
        }

        const nid = ctx.data;

        if (
            ctx.unwrap(
                await ctx.post(`http://owner:8001/api/node_set/`, {
                    uid,
                    nid,
                })
            )
        ) {
            return;
        }

        await ctx.add_planet(nid, name, info);

        ctx.resp(200, {
            ok: nid,
        });
    });

    router.post('/alliance/create', async (ctx) => {
        if (!ctx.auth) {
            ctx.resp(403, {
                error: 'Not authorized',
            });
            return;
        }

        const { l = null, r = null } = ctx.request.body;

        if (!l || !r) {
            ctx.resp(403, {
                error: 'No planets provided',
            });
            return;
        }

        const { id: uid } = ctx.session;

        if (
            ctx.unwrap(
                await ctx.get(`http://owner:8001/api/node_get/${uid}/${l}`, {
                    nid: l,
                })
            )
        ) {
            return;
        }

        if (ctx.data === 0) {
            ctx.resp(403, {
                error: 'No access',
            });
            return;
        }

        if (
            ctx.unwrap(
                await ctx.post(`http://graph:8000/api/create_link/`, {
                    l,
                    r,
                })
            )
        ) {
            return;
        }

        const lid = ctx.data;

        ctx.resp(200, {
            ok: lid,
        });
    });

    router.get('/empire/:id', async (ctx) => {
        const cashed = await ctx.cashed();
        if (cashed) return;

        const { id: gid } = ctx.params;

        if (
            ctx.unwrap(
                await ctx.get(`http://graph:8000/api/graph_nodes/${gid}`)
            )
        ) {
            return;
        }

        const nodes = ctx.data;

        if (
            ctx.unwrap(
                await ctx.get(`http://graph:8000/api/graph_links/${gid}`)
            )
        ) {
            return;
        }

        const links = ctx.data;

        const [name] = await ctx.get_empire(gid);

        ctx.resp(200, {
            ok: {
                name,
                nodes,
                links,
            },
        });
    });

    router.get('/planet/:id', async (ctx) => {
        const cashed = await ctx.cashed();
        if (cashed) return;

        const { id: uid } = ctx.session;

        if (!ctx.auth) {
            ctx.resp(403, {
                error: 'Not authorized',
            });
            return;
        }

        const { id: nid } = ctx.params;

        if (
            ctx.unwrap(
                await ctx.get(`http://owner:8001/api/node_get/${uid}/${nid}`, {
                    nid,
                })
            )
        ) {
            return;
        }

        const [name, info] = await ctx.get_planet(nid);

        if (ctx.data !== 0) {
            ctx.resp(200, {
                ok: {
                    name,
                    info,
                },
            });
            return;
        }
    });
}

module.exports = register_routes;
