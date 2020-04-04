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

	.global	routes
routes:
	.int	static
	.int	serve_static
	.int	register
	.int	register_route
	.int	login
	.int	login_route
	.int	0