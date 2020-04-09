	.data
urlt:	.ascii	"????????????????????????????????????????????????\x00\x01\x02\x03\x04\x05\x06\x07\x08\t???????\n\x0b\x0c\r\x0e\x0f??????????????????????????\n\x0b\x0c\r\x0e\x0f?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????"
urnd:	.asciz	"/dev/urandom"
alph:	.asciz	"0123456789abcdef"
	.text
	.global	gstrlen
gstrlen:
	xorl	%eax,%eax
	push	%ebx
loop_len:
	movzx	(%ecx,%eax,1),%ebx
	test	%ebx,%ebx
	jz	endloop_len
	incl	%eax
	jmp	loop_len
endloop_len:
	popl	%ebx
	retl

	.global	watoi
watoi:
	pushl	%ebx
	pushl	%esi
	movl	$9,%esi
	subl	$10,%esp
loop_watoi:
	movl	%ecx,%eax
	xorl	%edx,%edx
	movl	$10,%ebx
	div	%ebx
	movl	%eax,%ecx

	addl	$48,%edx
	movb	%dl,(%esp,%esi,1)
	decl	%esi

	test	%eax,%eax
	jnz	loop_watoi

	movl	%esp,%ecx
	addl	%esi,%ecx
	incl	%ecx

	negl	%esi
	addl	$9,%esi
	movl	%esi,%edx

	movl	$4,%eax
	movl	$1,%ebx
	int	$0x80

	addl	$10,%esp
	popl	%esi
	popl	%ebx
	retl

	.global	simple_write
simple_write:
	pushl	%ebx
	movl	%ecx,%ebx
	call	gstrlen

	movl	%ebx,%ecx
	movl	%eax,%edx

	movl	$4,%eax
	movl	$1,%ebx
	int	$0x80

	popl	%ebx
	retl

	.global	gstrcmp
gstrcmp:
	pushl	%esi
	pushl	%edi

	movl	%ecx,%esi
	movl	%edx,%edi

loop_strcmp:
	movzx	(%esi),%ecx
	movzx	(%edi),%edx

	test	%ecx,%ecx
	jz	rcmp

	test	%edx,%edx
	jz	rcmp

	incl	%esi
	incl	%edi
	cmpl	%ecx,%edx
	jz 	loop_strcmp

rcmp:
	subl	%edx,%ecx
	movl	%ecx,%eax

	popl	%edi
	popl	%esi
	retl

	.global	grand
grand:
	pushl	%ebx
	pushl	%esi

	movl	%edx,%esi

	movl	$5,%eax
	movl	$urnd,%ebx
	xorl	%ecx,%ecx
	xorl	%edx,%edx
	int	$0x80

	movl	%eax,%ebx
	movl	$3,%eax
	movl	%esi,%ecx
	movl	%edi,%edx
	int	$0x80

	movl	$6,%eax
	int	$0x80

	popl	%esi
	popl	%ebx
	retl

	.global	throw_500
throw_500:
	call	return_500_str
	retl

	.global	throw_redis_500
throw_redis_500:
	movl	redctx,%ecx
	addl	$4,%ecx
	call	return_500_str
	retl

	.global	throw_redis_400
throw_redis_400:
	movl	redctx,%ecx
	addl	$4,%ecx
	call	return_400_str
	retl

	.global	token_hex
token_hex:
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	%esp,%ebx

	subl	%ebp,%esp
	movl	%esp,%edx
	movl	%ebp,%edi

	pushl	%ecx
	call	grand
	popl	%ecx

	xorl	%edx,%edx
	movb	%dl,(%ecx,%ebp,2)

	movl	$alph,%esi
loop_th:
	test	%ebp,%ebp
	jz	end_th
	decl	%ebp

	xorl	%edx,%edx
	movb	(%esp,%ebp),%dl
	shrl	$4,%edx
	movb	(%esi,%edx),%dl
	movb	%dl,(%ecx,%ebp,2)

	xorl	%edx,%edx
	movb	(%esp,%ebp),%dl
	andl	$0xF,%edx
	movb	(%esi,%edx),%dl
	movb	%dl,1(%ecx,%ebp,2)

	jmp	loop_th

end_th:
	movl	%ebx,%esp
	popl	%edi
	popl	%esi
	popl	%ebx
	retl

	.global	urldecode
urldecode:
	pushl	%ebx
	pushl	%esi

	movl	$urlt,%esi

loop_ud:
	xorl	%eax,%eax
	movb	(%ecx),%al
	testl	%eax,%eax
	jz	end_ud

	cmpl	$0x25,%eax
	je	decode_perc

	movb	%al,(%edx)
	incl	%ecx
	incl	%edx
	jmp	loop_ud

decode_perc:
	incl	%ecx
	xorl	%eax,%eax
	movb	(%ecx),%al
	testl	%eax,%eax
	jz	write_perc

	cmpl	$0x25,%eax
	je	double_perc

	incl	%ecx
	xorl	%ebx,%ebx
	movb	(%ecx),%bl
	testl	%ebx,%ebx
	jz	insuff_symb

	movb	(%esi,%eax),%al
	movb	(%esi,%ebx),%bl

	shll	$4,%eax
	addl	%ebx,%eax
	movb	%al,(%edx)

	incl	%ecx
	incl	%edx
	jmp	loop_ud

insuff_symb:
	movl	$0x25,%ebx
	movb	%bl,(%edx)
	incl	%edx

	movb	%al,(%edx)
	incl	%edx

	jmp	loop_ud

double_perc:
	incl	%ecx
	jmp	write_perc

write_perc:
	movl	$0x25,%eax
	movb	%al,(%edx)
	incl	%edx
	jmp	loop_ud

end_ud:
	xorl	%eax,%eax
	movb	%al,(%edx)
	popl	%esi
	popl	%ebx
	retl
