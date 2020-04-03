	.data
ss_hir:	.asciz	"SET session:%s %s"

gs_hir:	.asciz	"GET session:%s"

	.text
	.global	set_session
set_session:
	pushl	%edi
	movl	%esp,%edi

	pushl	%edx
	pushl	%ecx
	call	proc_redis_context
	testl	%eax,%eax
	jnz	throw_500

	pushl	$ss_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	throw_redis_500

	movl	%edi,%esp
	popl	%edi

	retl

	.global	get_sess_username
get_sess_username:
	pushl	%esi
	movl	%esp,%esi

	pushl	%ecx
	call	proc_redis_context
	testl	%eax,%eax
	jnz	throw_500

	pushl	$gs_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	throw_redis_500

	movl	(%eax),%ecx
	cmpl	$1,%ecx
	jne	throw_redis_400

	movl	16(%eax),%ecx

	movl	%esi,%esp
	popl	%esi

	retl
