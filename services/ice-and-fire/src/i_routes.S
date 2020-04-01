	.intel_syntax	noprefix

	.data
static:
	.asciz	"/static/"
root:
	.asciz	"/"
register:
	.asciz	"/register/"
test_p:	
	.asciz	"/test/"

	.global	routes
routes:
	.int	static
	.int	serve_static
	.int	register
	.int	register_route
	.int	test_p
	.int	test_route
	.int	0