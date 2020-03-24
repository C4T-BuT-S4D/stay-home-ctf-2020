	.intel_syntax	noprefix

	.data
kek:
	.asciz	"kek"

	.text
	.global	register_route
register_route:
	push	esi
	mov	esi, offset kek
	call	return_error
	pop	esi
	ret