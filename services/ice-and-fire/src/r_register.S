	.intel_syntax	noprefix

	.data
usr:	.asciz	"username"
pwd:	.asciz	"password"
dusr:	.int	0
dpwd:	.int	0
usre:	.asciz	"Invalid username"
pwde:	.asciz	"Invalid password"

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
	mov	ecx, DWORD PTR [esi + 12]
	mov	edx, DWORD PTR [esi + 16]
	lea	eax, DWORD PTR [esi + 20]
	mov	esi, DWORD PTR [eax]
	cmp	esi, 16
	jz	rdok
	xor	ecx, ecx
	call	return_400
rdok:
	shl	esi, 2
	mov	DWORD PTR [eax], esi
	call	add_user

	xor	ecx, ecx
	call	return_400