	.intel_syntax	noprefix

	.data
static:
	.asciz	"/static/"
root:
	.asciz	"/"

	.global	routes
routes:
	.int	static
	.int	serve_static
	.int	root
	.int	test_route
	.int	0