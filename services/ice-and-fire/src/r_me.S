	.intel_syntax	noprefix

	.data
cook:
	.asciz	"HTTP_COOKIE"
naut:
	.asciz	"Not authorized!"
user:
	.int	0
cont:
	.int	0

	.text
	.global	me_route
me_route:
	call	get_session
	test	eax, eax
	jnz	soku
	mov	ecx, offset naut
	call	return_400_str

soku:
	mov	ecx, eax
	call	get_sess_username
	mov	eax, ecx
	push	eax

	push	20
	call	malloc
	add	esp, 4
	push	eax
	push	eax
	call	user__init
	add	esp, 4
	pop	eax

	mov	DWORD PTR [user], eax

	pop	ecx
	push	ecx
	push	eax

	mov	DWORD PTR [eax + 12], ecx

	call	get_user_password

	pop	edx

	mov	DWORD PTR [edx + 16], ecx

	push	16
	call	malloc
	add	esp, 4
	push	eax
	push	eax
	call	contact__init
	add	esp, 4
	pop	eax

	mov	DWORD PTR [cont], eax

	pop	ecx
	push	eax

	call	get_user_contact

	pop	esi
	mov	DWORD PTR [esi + 12], ecx

	push	20
	call	malloc
	add	esp, 4
	push	eax
	push	eax
	call	my_data__init
	add	esp, 4
	pop	eax

	mov	esi, DWORD PTR [user]
	mov	DWORD PTR [eax + 12], esi
	mov	esi, DWORD PTR [cont]
	mov	DWORD PTR [eax + 16], esi

	push	eax
	push	eax
	call	my_data__get_packed_size
	add	esp, 4
	pop	ecx
	push	eax
	push	ecx

	push	eax
	call	malloc
	add	esp, 4
	pop	ecx

	push	eax

	push	eax
	push	ecx
	call	my_data__pack
	add	esp, 8

	pop	ecx
	pop	edx
	call	return_200