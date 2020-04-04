	.intel_syntax	noprefix

	.data
pwde:	.asciz	"Invalid password"
okusr:	.asciz	"Success!"

	.text
	.global	login_route
login_route:
	call	get_body
	push	eax
	push	ecx
	push	0
	call	login_request__unpack
	add	esp, 12
	mov	esi, eax
	test	eax, eax
	jnz	lpok
	xor	ecx, ecx
	call	return_400
lpok:
	mov	edi, DWORD PTR [esi + 12]
	mov	ecx, DWORD PTR [edi + 12]
	mov	edx, DWORD PTR [edi + 16]
	push	ecx

	call	check_user_password
	test	eax, eax
	jz	lcok

	mov	ecx, offset pwde
	call	return_400_str

lcok:
	sub	esp, 33
	mov	ebp, 16
	mov	ecx, esp
	call	token_hex

	mov	ecx, esp
	mov	edx, DWORD PTR [esp + 33]
	call	set_session

	mov	ecx, offset okusr
	call	return_200_str_sess