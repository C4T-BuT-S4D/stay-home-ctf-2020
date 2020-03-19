	.data
hellow:	.asciz	"<h1>Hello, World!</h1>\n"

	.text
	.global	main
main:
	pushl	%ebp
	movl	%esp,%ebp

	movl	$4,%eax
	movl	$1,%ebx
	movl	$hellow,%ecx
	movl	$23,%edx
	int	$0x80

	xorl	%eax,%eax
	movl	%ebp,%esp
	popl	%ebp
	retl
