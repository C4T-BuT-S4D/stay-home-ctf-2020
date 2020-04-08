function add_helpers() {
    return async (ctx, next) => {
        ctx.get_user = async (u) => {
            const [{ id = null, password = null } = {}] = (
                await ctx.pool.query(
                    `
                SELECT id, password FROM users WHERE username=$1
            `,
                    [u]
                )
            ).rows;

            return [id, password];
        };

        ctx.add_user = async (u, p) => {
            const [{ id = null } = {}] = (
                await ctx.pool.query(
                    `
                INSERT INTO users (username, password) VALUES ($1, $2) RETURNING id
            `,
                    [u, p]
                )
            ).rows;

            return id;
        };

        ctx.get_empire = async (gid) => {
            const [{ name = null } = {}] = (
                await ctx.pool.query(
                    `
                SELECT name FROM empires WHERE gid=$1
            `,
                    [gid]
                )
            ).rows;

            return [name];
        };

        ctx.add_empire = async (gid, name) => {
            const [{ id = null } = {}] = (
                await ctx.pool.query(
                    `
                INSERT INTO empires (gid, name) VALUES ($1, $2) RETURNING id
            `,
                    [gid, name]
                )
            ).rows;

            return id;
        };

        ctx.get_planet = async (nid) => {
            const [{ name = null, info = null } = {}] = (
                await ctx.pool.query(
                    `
                SELECT name, info FROM planets WHERE nid=$1
            `,
                    [nid]
                )
            ).rows;

            return [name, info];
        };

        ctx.add_planet = async (nid, name, info) => {
            const [{ id = null } = {}] = (
                await ctx.pool.query(
                    `
                INSERT INTO planets (nid, name, info) VALUES ($1, $2, $3) RETURNING id
            `,
                    [nid, name, info]
                )
            ).rows;

            return id;
        };

        ctx.list_users = async () => {
            const users = (
                await ctx.pool.query(
                    `
                SELECT id, username FROM users ORDER BY id DESC LIMIT 500
            `
                )
            ).rows.map(({ id, username }) => ({
                id,
                username,
            }));

            return users;
        };

        await next();
    };
}

module.exports = add_helpers;
