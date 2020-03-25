	.intel_syntax	noprefix

	.text
	.global	wpstr
wpstr:
	mov	esi, ecx
	push	16
	call	malloc
	mov	edi, eax
	add	esp, 4
	push	edi
	call	error_response__init
	add	esp, 4
	mov	DWORD PTR [edi + 12], esi
	push	edi
	call	error_response__get_packed_size
	mov	ebx, eax
	add	esp, 4
	push	eax
	call	malloc
	add	esp, 4
	mov	esi, eax
	push	esi
	push	edi
	call	error_response__pack
	add	esp, 8
	push	edi
	call	free
	add	esp, 4
	mov	ecx, esi
	mov	edx, ebx
	call	wrhtml