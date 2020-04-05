	.data
exists:	.asciz	"User already exists"
no_us:	.asciz	"No such user"
err_lm:	.asciz	"Could not list users"

sp_hir:	.asciz	"SET user:%s:password %s"
sd_hir:	.asciz	"SETNX user:%s:data %b"
sc_hir:	.asciz	"SET user:%s:contact %s"
al_hir:	.asciz	"LPUSH users %s"

gp_hir:	.asciz	"GET user:%s:password"
gd_hir:	.asciz	"GET user:%s:data"
gc_hir:	.asciz	"GET user:%s:contact"
gl_hir:	.asciz	"LRANGE users 0 500"

	.text
no_user:
	movl	$no_us,%ecx
	jmp	return_400_str

usr_exists:
	movl	$exists,%ecx
	call	return_400_str

err_listing:
	movl	$err_lm,%ecx
	call	return_500_str

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

	pushl	%esi
	pushl	$al_hir
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

	.global	get_users_listing
get_users_listing:
	pushl	%ebx
	pushl	%ebp
	pushl	%edi
	pushl	%esi
	movl	%esp,%esi

	call	proc_redis_context
	testl	%eax,%eax
	jnz	throw_500

	pushl	$gl_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	throw_redis_500

	movl	(%eax),%ecx
	cmpl	$2,%ecx
	jne	err_listing

	movl	%esi,%esp
	pushl	%eax
	movl	20(%eax),%ecx

	movl	$192,%eax
	xorl	%ebx,%ebx
	incl	%ecx
	shll	$3,%ecx
	movl	$6,%edx
	movl	$0x22,%esi
	xorl	%edi,%edi
	decl	%edi
	xorl	%ebp,%ebp
	int	$0x80

	movl	%eax,%edi

	popl	%ecx
	movl	20(%ecx),%ebx
	movl	24(%ecx),%esi

	movl	$0,(%edi,%ebx,8)
	movl	$0,4(%edi,%ebx,8)

loop_gul:
	testl	%ebx,%ebx
	jz	end_gul
	decl	%ebx

	movl	(%esi,%ebx,4),%edx
	movl	(%edx),%eax
	cmpl	$1,%eax
	jne	err_listing

	movl	12(%edx),%eax
	movl	%eax,(%edi,%ebx,8)

	movl	16(%edx),%eax
	movl	%eax,4(%edi,%ebx,8)

	jmp	loop_gul

end_gul:
	movl	%edi,%eax
	popl	%esi
	popl	%edi
	popl	%ebp
	popl	%ebx
	retl
