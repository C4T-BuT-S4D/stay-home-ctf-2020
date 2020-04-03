	.intel_syntax	noprefix

	.data
sts:
	.asciz	"static/"

	.text
	.global	serve_static
serve_static:
	mov	ecx, ebp
	call	gstrlen
	sub	esp, eax
	sub	esp, 8
	mov	ecx, esp
	push	offset sts
	push	ecx
	call	strcpy
	add	esp, 8
	mov	ecx, esp
	push	ebp
	push	ecx
	call	strcat
	add	esp, 8
	mov	ecx, esp

	call	gstrlen
	dec	eax

	push	ebx
	xor	ebx, ebx
	movb	bl, BYTE PTR [ecx + eax]
	cmp	ebx, 0x2f
	je	bad_file
	pop	ebx

	call	return_file

bad_file:
	xor	ecx, ecx
	call	return_400
