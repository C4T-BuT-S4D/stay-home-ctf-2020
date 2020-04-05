	.intel_syntax	noprefix

	.data
static:
	.asciz	"/static/"
register:
	.asciz	"/register/"
login:
	.asciz	"/login/"
users:
	.asciz	"/users/"
me:
	.asciz	"/me/"
match:
	.asciz	"/match/"

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
	.int	0