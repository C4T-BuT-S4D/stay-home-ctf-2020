	.intel_syntax	noprefix

	.text
	.global	users_route
users_route:
	call	get_users_listing
	push	eax
	xor	edx, edx
	mov	ecx, eax

urlo1:
	mov	ebx, DWORD PTR [ecx + 4]
	test	ebx, ebx
	jz	uren1

	add	edx, 4
	add	ecx, 8

	jmp	urlo1

uren1:
	push	edx
	mov	edi, edx
	call	malloc
	add	esp, 4
	mov	esi, eax
	pop	ebx
	push	esi
	shr	edi, 2
	push	edi

urlo2:
	mov	ecx, DWORD PTR [ebx + 4]
	test	ecx, ecx
	jz	uren2

	mov	ecx, DWORD PTR [ebx]
	add	ecx, 1

	push	1
	push	ecx
	call	calloc
	add	esp, 8
	push	eax

	mov	ecx, DWORD PTR [ebx]
	push	ecx
	mov	ecx, DWORD PTR [ebx + 4]
	push	ecx
	push	eax
	call	memcpy
	add	esp, 12

	pop	eax

	mov	DWORD PTR [esi], eax

	add	esi, 4
	add	ebx, 8

	jmp	urlo2

uren2:
	pop	edi
	mov	ebx, edi
	pop	esi
	push	20
	call	malloc
	add	esp, 4

	mov	edi, eax
	push	edi
	call	user_list__init
	add	esp, 4

	mov	DWORD PTR [edi + 12], ebx
	mov	DWORD PTR [edi + 16], esi

	push	edi
	call	user_list__get_packed_size
	add	esp, 4

	mov	ebx, eax
	push	eax
	call	malloc
	add	esp, 4
	mov	esi, eax

	push	esi
	push	edi
	call	user_list__pack
	add	esp, 8

	mov	ecx, esi
	mov	edx, ebx
	call	return_200