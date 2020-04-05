	.intel_syntax	noprefix

	.data
naut:
	.asciz	"Not authorized!"

	.text
	.global	match_route
match_route:
	call	get_session
	test	eax, eax
	jnz	mrau
	mov	ecx, offset naut
	call	return_400_str

mrau:
	call	get_body
	push	eax
	push	ecx
	push	0
	call	match_request__unpack
	add	esp, 12
	mov	esi, eax
	test	eax, eax
	jnz	mrok
	xor	ecx, ecx
	call	return_400
mrok:
