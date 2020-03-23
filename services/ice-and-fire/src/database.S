	.data
no_all:	.asciz	"Can't allocate redis context"
	.text
	.global	proc_redis_context
proc_redis_context:
	movl	redctx,%eax
	testl	%eax,%eax
	jnz	no_alloc_ctx

	pushl	red_p
	pushl	$red_a
	call	redisConnect
	addl	$8,%esp
	testl	%eax,%eax
	jz	ret_ctx

ret_ctx:
	movl	(%eax),%ecx
	testl	%ecx,%ecx
	jnz	err_conn_ctx

	movl	%eax,redctx
	jmp	ok_ctx

err_conn_ctx:
	leal	4(%eax),%ecx
	jmp	err_ctx
	
no_alloc_ctx:
	movl	$no_all,%ecx
	jmp	err_ctx

ok_ctx:
	xorl	%eax,%eax
	retl

err_ctx:
	xorl	%eax,%eax
	incl	%eax
	retl