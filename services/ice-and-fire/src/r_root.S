	.intel_syntax	noprefix

	.data
index:
	.asciz	"static/index.html"

	.text
	.global	root_route
root_route:
	mov	ecx, offset index
	call	return_file
	push	0
	call	exit

bad_file:
	xor ecx, ecx
	call	return_400
