	.intel_syntax	noprefix

	.data
static:
	.asciz	"/static/"

	.global	routes
routes:
	.int	static
	.int	serve_static
	.int	0