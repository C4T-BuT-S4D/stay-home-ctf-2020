	.data
exists:	.asciz	"User already exists"
no_us:	.asciz	"No such user"

sp_hir:	.asciz	"SET user:%s:password %s"
sd_hir:	.asciz	"SETNX user:%s:data %b"
sc_hir:	.asciz	"SET user:%s:contact %s"

gp_hir:	.asciz	"GET user:%s:password"
gd_hir:	.asciz	"GET user:%s:data"
gc_hir:	.asciz	"GET user:%s:contact"

	.text
no_user:
	movl	$no_us,%ecx
	jmp	return_400_str

usr_exists:
	movl	$exists,%ecx
	call	return_400_str

	.global	add_user
add_user:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	%esp,%ebx

	movl	%eax,%ebp
	movl	%ecx,%esi
	movl	%edx,%edi

	call	proc_redis_context
	testl	%eax,%eax
	jnz	throw_500

	movl	(%ebp),%ecx
	pushl	%ecx
	movl	4(%ebp),%ecx
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

	movl	8(%ebp),%ecx
	pushl	%ecx
	pushl	%esi
	pushl	$sc_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	throw_redis_500

	pushl	%edi
	pushl	%esi
	pushl	$sp_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	throw_redis_500

	xorl	%eax,%eax
	jmp	end_au

end_au:
	movl	%ebx,%esp
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
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
	jne	no_user

return_user_gup:
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

	.global	get_user_contact
get_user_contact:
	pushl	%esi
	movl	%esp,%esi

	pushl	%ecx

	call	proc_redis_context
	testl	%eax,%eax
	jnz	throw_500

	pushl	$gc_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	throw_redis_500

	movl	(%eax),%ecx
	cmpl	$1,%ecx
	jne	no_user

	movl	16(%eax),%ecx

	movl	%esi,%esp
	popl	%esi
	retl
