	.intel_syntax	noprefix

	.data
cntle:	.asciz	"CONTENT_LENGTH"
memerr:	.asciz	"Memory allocation error"
boderr:	.asciz	"Body parsing error"

	.text
	.global	get_body
get_body:
	push	edi
	push	esi
	push	offset cntle
	call	getenv
	add	esp, 4
	push	eax
	call	atoi
	add	esp, 4
	push	eax
	inc	eax
	push	1
	push	eax
	call	calloc
	add	esp, 8
	test	eax, eax
	jnz	ok
	push	offset memerr
	call	return_500_str
ok:
	mov	edi, eax
	xor	esi, esi

lp:
	mov	eax, 3
	mov	ebx, 0
	lea	ecx, BYTE PTR [edi + esi]
	pop	edx
	int	0x80
	cmp	eax, 0
	jz	end
	add	esi, eax
	sub	edx, eax
	push	edx
	jmp	lp

	test	ebx, ebx
	jz	end

	push	offset boderr
	call	return_500_str

end:
	push	offset cntle
	call	getenv
	add	esp, 4
	push	eax
	call	atoi
	add	esp, 4
	mov	ecx, eax
	mov	eax, edi
	pop	esi
	pop	edi
	ret