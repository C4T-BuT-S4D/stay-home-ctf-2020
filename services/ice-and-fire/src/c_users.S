	.data
exists:	.asciz	"User already exists"

sp_hir:	.asciz	"SET user:%s:password %s"
sd_hir:	.asciz	"SETNX user:%s:data %b"

gp_hir:	.asciz	"GET user:%s:password"
gd_hir:	.asciz	"GET user:%s:data"

	.text
	.global	add_user
add_user:
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	%esp,%ebx

	pushl	%eax
	movl	%ecx,%esi
	movl	%edx,%edi

	call	proc_redis_context
	testl	%eax,%eax
	jnz	throw_500

	popl	%eax

	movl	(%eax),%ecx
	pushl	%ecx
	movl	4(%eax),%ecx
	pushl	%ecx
	pushl	%esi
	pushl	$sd_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	throw_redis_500

	movl	(%eax),%ecx
	cmpl	$3,%ecx
	jne	throw_redis_500

	movl	4(%eax),%ecx
	testl	%ecx,%ecx
	jz	usr_exists

	pushl	%edi
	pushl	%esi
	pushl	$sp_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	throw_redis_500

	xorl	%eax,%eax
	jmp	end_au

usr_exists:
	movl	$exists,%ecx
	call	return_400_str

end_au:
	movl	%ebx,%esp
	popl	%edi
	popl	%esi
	popl	%ebx
	retl

	.global	get_user_password
get_user_password:
	pushl	%esi
	movl	%esp,%esi

	pushl	%ecx

	call	proc_redis_context
	testl	%eax,%eax
	jnz	throw_500

	pushl	$gp_hir
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

	.global	check_user_password
check_user_password:
	pushl	%edi
	movl	%esp,%edi

	pushl	%edx
	call	get_user_password
	popl	%edx
	call	gstrcmp

	movl	%edi,%esp
	popl	%edi
	retl
