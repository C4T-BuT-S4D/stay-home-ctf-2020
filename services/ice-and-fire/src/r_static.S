	.intel_syntax	noprefix

	.data
sts:
	.asciz	"static/"

	.text
	.global	serve_static
serve_static:
	mov	ecx, ebp
	call	gstrlen
	sub	esp, eax
	sub	esp, 8
	mov	ecx, esp
	push	offset sts
	push	ecx
	call	strcpy
	add	esp, 8
	mov	ecx, esp
	push	ebp
	push	ecx
	call	strcat
	add	esp, 8
	mov	ecx, esp
	call	return_file

	push	0
	call	exit