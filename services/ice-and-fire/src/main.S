	.intel_syntax	noprefix

	.data
urle:	.asciz	"DOCUMENT_URI"

	.text
	.global	main
main:
	push	offset urle
	call	getenv
	add	esp, 4
	mov	edx, eax
	call	handle
	xor	eax, eax
	ret