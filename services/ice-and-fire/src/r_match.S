	.intel_syntax	noprefix

	.data
naut:
	.asciz	"Not authorized!"
nmt:
	.asciz	"Too different!"
usrm:
	.int	0

	.text
	.global	match_route
match_route:
	call	get_session
	test	eax, eax
	jnz	mrau
	mov	ecx, offset naut
	call	return_400_str

mrau:
	mov	ecx, eax
	call	get_sess_username
	call	get_user_data

	push	ecx

	call	get_body
	push	eax
	push	ecx
	push	0
	call	match_request__unpack
	add	esp, 12
	mov	ecx, eax
	test	eax, eax
	jnz	mrok
	xor	ecx, ecx
	call	return_400
mrok:
	mov	ecx, DWORD PTR [eax + 12]
	mov	DWORD PTR [usrm], ecx
	call	get_user_data
	mov	edi, ecx
	mov	esi, 16
	pop	ebx
	call	gcompat

	test	esi, esi
	jnz	mrmt

	push	28
	call	malloc
	add	esp, 4

	push	eax
	push	eax
	call	match__init
	add	esp, 4

	pop	esi
	mov	DWORD PTR [esi + 12], 0
	movsd	QWORD PTR [esi + 16], xmm5
	mov	DWORD PTR [esi + 24], 0

	push	esi
	call	match__get_packed_size
	add	esp, 4

	push	eax
	push	eax
	call	malloc
	add	esp, 4
	push	eax

	push	eax
	push	esi
	call	match__pack
	add	esp, 8

	pop	ecx
	pop	edx

	call	return_200

mrmt:
	mov	ecx, DWORD PTR [usrm]
	call	get_user_contact
	push	ecx

	push	16
	call	malloc
	add	esp, 4

	push	eax
	push	eax
	call	contact__init
	add	esp, 4

	pop	eax
	pop	ecx
	mov	DWORD PTR [eax + 12], ecx

	push	eax

	push	28
	call	malloc
	add	esp, 4

	push	eax
	push	eax
	call	match__init
	add	esp, 4

	pop	esi
	pop	eax
	mov	DWORD PTR [esi + 12], 1
	movsd	QWORD PTR [esi + 16], xmm5
	mov	DWORD PTR [esi + 24], eax

	push	esi
	call	match__get_packed_size
	add	esp, 4

	push	eax
	push	eax
	call	malloc
	add	esp, 4
	push	eax

	push	eax
	push	esi
	call	match__pack
	add	esp, 8

	pop	ecx
	pop	edx

	call	return_200