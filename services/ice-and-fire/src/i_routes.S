	.intel_syntax	noprefix

	.data
static:
	.asciz	"/static/"
register:
	.asciz	"/api/register/"
login:
	.asciz	"/api/login/"
users:
	.asciz	"/api/users/"
me:
	.asciz	"/api/me/"
match:
	.asciz	"/api/match/"
root:
	.asciz	""

	.global	routes
routes:
	.int	static
	.int	serve_static
	.int	register
	.int	register_route
	.int	login
	.int	login_route
	.int	users
	.int	users_route
	.int	me
	.int	me_route
	.int	match
	.int	match_route
    .int    root
    .int    root_route
	.int	0