	.intel_syntax	noprefix

	.data
cook:
	.asciz	"HTTP_COOKIE"
sess:
	.asciz	"session="
tok:
	.asciz	"; "
etok:
	.asciz	"="

	.text
	.global	get_session
get_session:
	push	offset cook
	call	getenv
	add	esp, 4
	test	eax, eax
	jnz	trgs
	xor	eax, eax
	ret

trgs:
	mov	esi, eax
	mov	ebx, esi

gslp:
	push	offset tok
	push	ebx
	xor	ebx, ebx
	call	strtok
	add	esp, 8
	mov	esi, eax
	test	esi, esi
	jz	nf
	push	8
	push	offset sess
	push	esi
	call	strncmp
	add	esp, 12
	test	eax, eax
	jz	fnd
	jmp	gslp

nf:
	mov	eax, 0
	ret

fnd:
	mov	eax, 1
	push	offset etok
	push	esi
	call	strtok
	add	esp, 8
	push	offset etok
	push	0
	call	strtok
	add	esp, 8

	ret
