	.intel_syntax	noprefix

	.data
static:
	.asciz	"/static/"
root:
	.asciz	"/"
register:
	.asciz	"/register/"

	.global	routes
routes:
	.int	static
	.int	serve_static
	.int	register
	.int	register_route
	.int	root
	.int	test_route
	.int	0