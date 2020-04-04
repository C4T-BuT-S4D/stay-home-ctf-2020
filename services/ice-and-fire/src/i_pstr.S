	.intel_syntax	noprefix

	.text
	.global	wpstr_err
wpstr_err:
	mov	esi, ecx
	push	20
	call	malloc
	mov	edi, eax
	add	esp, 4
	push	edi
	call	response__init

	add	esp, 4
	mov	DWORD PTR [edi + 12], 0
	mov	DWORD PTR [edi + 16], esi
	push	edi
	call	response__get_packed_size

	mov	ebx, eax
	add	esp, 4
	push	eax
	call	malloc
	add	esp, 4
	mov	esi, eax
	push	esi
	push	edi
	call	response__pack

	add	esp, 8
	push	edi
	call	free
	add	esp, 4
	mov	ecx, esi
	mov	edx, ebx
	call	wrhtml

	.global	wpstr_ok
wpstr_ok:
	mov	esi, ecx
	push	20
	call	malloc
	mov	edi, eax
	add	esp, 4
	push	edi
	call	response__init

	add	esp, 4
	mov	DWORD PTR [edi + 12], 1
	mov	DWORD PTR [edi + 16], esi
	push	edi
	call	response__get_packed_size

	mov	ebx, eax
	add	esp, 4
	push	eax
	call	malloc
	add	esp, 4
	mov	esi, eax
	push	esi
	push	edi
	call	response__pack

	add	esp, 8
	push	edi
	call	free
	add	esp, 4
	mov	ecx, esi
	mov	edx, ebx
	call	wrhtml