	.intel_syntax	noprefix

	.data
urle:	.asciz	"DOCUMENT_URI"

	.text
	.global	main
main:
	push	edi
	push	esi
	mov	edi, esp

	push	offset urle
	call	getenv
	add	esp, 4

	mov	esi, eax
	mov	ecx, eax
	call	gstrlen
	inc	eax

	sub	esp, eax
	mov	ecx, esi
	mov	edx, esp
	call	urldecode

	mov	edx, esp
	call	handle
	xor	eax, eax
	
	mov	esp, edi
	pop	esi
	pop	edi
	ret