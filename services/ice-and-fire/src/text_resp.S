	.data
cntt:	.asciz	"Content-Type: text/html\r\n"
cntl:	.asciz	"Content-Length: "
nlnl:	.asciz	"\r\n\r\n"

	.text
	.global	return_html_response
return_html_response:
	pushl	%esi
	pushl	%edi
	movl	%ecx,%esi

	movl	$cntt,%ecx
	call	simple_write

	movl	$cntl,%ecx
	call	simple_write

	movl	%esi,%ecx
	call	gstrlen
	movl	%eax,%ecx
	movl	%eax,%edi
	call	watoi

	movl	$nlnl,%ecx
	call	simple_write

	movl	%esi,%ecx
	call	simple_write

	popl	%edi
	popl	%esi
	retl
