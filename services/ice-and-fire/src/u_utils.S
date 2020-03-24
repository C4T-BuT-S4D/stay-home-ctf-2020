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
