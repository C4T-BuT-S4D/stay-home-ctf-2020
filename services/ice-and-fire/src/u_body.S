	.intel_syntax	noprefix

	.data
cntle:	.asciz	"CONTENT_LENGTH"

	.text
	.global	get_body
get_body:
	push	edi
	push	esi
	push	ebx
	push	offset cntle
	call	getenv
	add	esp, 4
	push	eax
	call	atoi
	add	esp, 4
	mov	ebx, eax
	inc	eax
	push	0
	push	eax
	call	calloc
	add	esp, 8
	test	eax, eax
	jnz	ok
	call	return_500
ok:
	mov	edi, eax
	xor	esi, esi

lp:

	mov	eax, 3
	mov	ebx, 0
	lea	ecx, BYTE PTR [edi + esi]
	mov	edx, ebx
	int	0x80
	cmp	eax, 0
	jz	end
	add	esi, eax
	sub	ebx, eax
	jmp	lp

end:
	mov	eax, edi
	pop	ebx
	pop	esi
	pop	edi
	ret