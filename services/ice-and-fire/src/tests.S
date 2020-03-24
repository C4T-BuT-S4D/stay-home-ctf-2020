	.data
username:
	.asciz	"test_user1"
password:
	.asciz	"test_password"
data:	.asciz	"test_data"
data_len:
	.int	9


	.text
	.global	test_route
test_route:
	pushl	$data
	pushl	data_len
	movl	%esp,%eax
	movl	$username,%ecx
	movl	$password,%edx

	call	check_user_password
	addl	$8,%esp
	testl	%eax,%eax
	jnz	err_test

	call	return_html_response

err_test:
	retl