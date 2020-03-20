	.data
f_pth:	.asciz	"hello.S"

	.text
	.global	main
main:
	movl	$f_pth,%ecx
	call	return_file_response
	retl
