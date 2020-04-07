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

        ctx.list_users = async () => {
            const users = (
                await ctx.pool.query(
                    `
                SELECT username FROM users ORDER BY id DESC LIMIT 500
            `
                )
            ).rows.map(({ username }) => username);

            return users;
        };

        await next();
    };
}

module.exports = add_helpers;
