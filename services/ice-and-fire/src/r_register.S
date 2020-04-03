	.intel_syntax	noprefix

	.data
inlen:	.asciz	"Invalid data length"
okusr:	.asciz	"User created!"

	.text
	.global	register_route
register_route:
	call	get_body
	push	eax
	push	ecx
	push	0
	call	register_request__unpack
	add	esp, 12
	mov	esi, eax
	test	eax, eax
	jnz	rpok
	xor	ecx, ecx
	call	return_400
rpok:
	mov	edi, DWORD PTR [esi + 12]
	mov	ecx, DWORD PTR [edi + 12]
	mov	edx, DWORD PTR [edi + 16]
	lea	eax, DWORD PTR [esi + 16]
	mov	esi, DWORD PTR [eax]
	cmp	esi, 16
	jz	rdok
	mov	ecx, offset inlen
	call	return_400_str
rdok:
	shl	esi, 3
	sub	esp, 12
	mov	DWORD PTR [esp], esi
	mov	esi, DWORD PTR [eax + 4]
	mov	DWORD PTR [esp + 4], esi
	mov	edi, DWORD PTR [eax + 8]
	mov	esi, DWORD PTR [edi + 12]
	mov	DWORD PTR [esp + 8], esi
	mov	eax, esp
	call	add_user

	mov	ecx, offset okusr
	call	return_200_str