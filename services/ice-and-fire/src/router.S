	.intel_syntax	noprefix

	.text
comp:
	xor	ecx, ecx
clp:
	push	edx
	push	eax
	mov	dl, BYTE PTR [edx + ecx]
	mov	al, BYTE PTR [eax + ecx]
	and	edx, 0xff
	and	eax, 0xff
	test	al, al
	jz	cndo
	cmp	al, dl
	jnz	cndn
	pop	eax
	pop	edx
	inc	ecx
	jmp	clp

cndo:
	pop	eax
	pop	edx
	lea	edx, BYTE PTR [edx + ecx]
	xor	eax, eax
	inc	eax
	ret

cndn:
	pop	eax
	pop	edx
	xor	eax, eax
	ret

	.global	handle
handle:
	push	esi
	push	ebp
	mov	esi, offset routes
lp:
	mov	eax, DWORD PTR [esi]
	test	eax, eax
	jz	lpe
	call	comp
	add	esi, 8
	test	eax, eax
	jz	lp

	sub	esi, 4
	mov	ebp, edx
	call	DWORD PTR [esi]
	jmp	end

lpe:
	call	return_404
end:
	pop	ebp
	pop	esi
	ret