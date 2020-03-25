	.data
cntth:	.asciz	"Content-Type: text/html\r\n"
cntto:	.asciz	"Content-Type: application/octet-stream\r\n"
cntl:	.asciz	"Content-Length: "
nlnl:	.asciz	"\r\n\r\n"

	.text
	.global	whtml
whtml:
	pushl	%esi
	movl	%ecx,%esi

	movl	$cntth,%ecx
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

	pushl	$0
	call	exit

	.global	wrhtml
wrhtml:
	movl	%ecx,%esi
	movl	%edx,%edi

	movl	$cntto,%ecx
	call	simple_write

	movl	$cntl,%ecx
	call	simple_write

	movl	%edi,%ecx
	call	watoi

	movl	$nlnl,%ecx
	call	simple_write

	movl	$4,%eax
	movl	$1,%ebx
	movl	%esi,%ecx
	movl	%edi,%edx
	int	$0x80

	pushl	$0
	call	exit
