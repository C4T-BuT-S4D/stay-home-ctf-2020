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
	jnz	err_au

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
	jz	cmd_err_au

	movl	(%eax),%ecx
	cmpl	$3,%ecx
	jne	cmd_err_au

	movl	4(%eax),%ecx
	testl	%ecx,%ecx
	jz	usr_exists

	pushl	%edi
	pushl	%esi
	pushl	$sp_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	cmd_err_au

	xorl	%eax,%eax
	jmp	end_au

usr_exists:
	movl	$exists,%ecx
	call	return_400
	xorl	%eax,%eax
	incl	%eax
	jmp	end_au

cmd_err_au:
	movl	redctx,%ecx
	addl	$4,%ecx
	jmp	err_au

err_au:
	call	return_500
	xorl	%eax,%eax
	incl	%eax
	jmp	end_au

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
	jnz	err_gup

	pushl	$gp_hir
	pushl	redctx
	call	redisCommand
	testl	%eax,%eax
	jz	cmd_err_gup

	movl	(%eax),%ecx
	cmpl	$1,%ecx
	jne	br_gup

	movl	16(%eax),%ecx
	xorl	%eax,%eax
	jmp	end_gup

br_gup:
	movl	redctx,%ecx
	addl	$4,%ecx
	call	return_400
	xorl	%eax,%eax
	incl	%eax
	jmp	end_gup

cmd_err_gup:
	movl	redctx,%ecx
	addl	$4,%ecx
	jmp	err_gup

err_gup:
	call	return_500
	xorl	%eax,%eax
	incl	%eax
	jmp	end_gup

end_gup:
	movl	%esi,%esp
	popl	%esi
	retl

	.global	check_user_password
check_user_password:
	pushl	%edi
	movl	%esp,%edi

	pushl	%edx
	call	get_user_password
	testl	%eax,%eax
	jnz	end_cup
	popl	%edx
	call	gstrcmp

end_cup:
	movl	%edi,%esp
	popl	%edi
	retl
