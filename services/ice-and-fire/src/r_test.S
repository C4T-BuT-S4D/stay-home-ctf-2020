	.data
usern:	.asciz	"test_username"
	.text
	.global	test_route
test_route:
	pushl	%ebp
	pushl	%edi
	movl	%esp,%edi


	subl	$33,%esp
	movl	$16,%ebp
	movl	%esp,%ecx
	call	token_hex

	movl	%esp,%ecx
	movl	$usern,%edx
	call	set_session

	movl	%esp,%ecx
	call	get_sess_username
	call	wpstr

	movl	%edi,%esp
	popl	%edi
	popl	%ebp

	retl