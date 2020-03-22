	.data
f_pth:	.asciz	"/proc/self/fd/0"

	.text
	.global	main
main:
	movl	$f_pth,%ecx
	call	return_file_response
	retl
