	.intel_syntax	noprefix

	.data
static:
	.asciz	"/static/"
root:
	.asciz	"/"
register:
	.asciz	"/register/"
login:
	.asciz	"/login/"
users:
	.asciz	"/users/"
.me:
	.asciz	"/me/"

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
	.int	root
	.int	test_route
	.int	0