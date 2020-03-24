	.data
cntt:	.asciz	"Content-Type: text/html\r\n"
cntl:	.asciz	"Content-Length: "
nlnl:	.asciz	"\r\n\r\n"

	.text
	.global	whtml
whtml:
	pushl	%esi
	movl	%ecx,%esi

	movl	$cntt,%ecx
	call	simple_write

	movl	$cntl,%ecx
	call	simple_write

	movl	%esi,%ecx
	call	gstrlen
	movl	%eax,%ecx
	call	watoi

	movl	$nlnl,%ecx
	call	simple_write

	movl	%esi,%ecx
	call	simple_write

	pushl	0
	call	exit
