	.data
nf_s:	.asciz	"HTTP/1.0 404 Not found\r\n"
br_s:	.asciz	"HTTP/1.0 400 Bad request\r\n"
ie_s:	.asciz	"HTTP/1.0 500 Internal error\r\n"
nf_m:	.asciz	"<h1>Not found!</h1>"
br_m:	.asciz	"<h1>Bad request!</h1>"
ie_m:	.asciz	"<h1>Internal error!</h1>"

	.text
	.global	return_404
return_404:
	movl	$nf_s,%ecx
	call	simple_write
	movl	$nf_m,%ecx
	call	return_html_response
	retl

	.global	return_400
return_400:
	pushl	%esi
	movl	%ecx,%esi
	movl	$br_s,%ecx
	call	simple_write

	testl	%esi,%esi
	jnz	custom_400

default_400:
	movl	$br_m,%ecx	
	jmp	ret_400

custom_400:
	movl	%esi,%ecx
	jmp	ret_400

ret_400:
	call	return_html_response
	popl	%esi
	retl

	.global	return_500
return_500:
	pushl	%esi
	movl	%ecx,%esi
	movl	$ie_s,%ecx
	call	simple_write

	testl	%esi,%esi
	jnz	custom_500

default_500:
	movl	$ie_m,%ecx	
	jmp	ret_500

custom_500:
	movl	%esi,%ecx
	jmp	ret_500

ret_500:
	call	return_html_response
	popl	%esi
	retl
