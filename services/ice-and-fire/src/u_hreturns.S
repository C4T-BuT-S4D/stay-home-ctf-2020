	.data
ok_s:	.asciz	"Status: 200\r\n"
nf_s:	.asciz	"Status: 404 Not found\r\n"
br_s:	.asciz	"Status: 400\r\n"
ie_s:	.asciz	"Status: 500\r\n"
nf_m:	.asciz	"<h1>Not found!</h1>"
br_m:	.asciz	"Bad request!"
ie_m:	.asciz	"Internal error!"
cook:	.asciz	"Set-Cookie: session="
nlnl:	.asciz	"\r\n"

	.text
	.global	return_404
return_404:
	movl	$nf_s,%ecx
	call	simple_write
	movl	$nf_m,%ecx
	call	whtml

	.global	return_200
return_200:
	movl	%ecx,%esi
	movl	%edx,%edi
	movl	$ok_s,%ecx
	call	simple_write
	movl	%esi,%ecx
	movl	%edi,%edx
	call	wrhtml

	.global	return_200_str
return_200_str:
	movl	%ecx,%esi
	movl	$ok_s,%ecx
	call	simple_write
	movl	%esi,%ecx
	call	wpstr_ok

	.global	return_200_str_sess
return_200_str_sess:
	movl	%ecx,%esi
	movl	$ok_s,%ecx
	call	simple_write
	movl	$cook,%ecx
	call	simple_write
	movl	%esp,%ecx
	addl	$4,%ecx
	call	simple_write
	movl	$nlnl,%ecx
	call	simple_write
	movl	%esi,%ecx
	call	wpstr_ok

	.global	return_400
return_400:
	movl	%ecx,%esi
	movl	%edx,%edi
	movl	$br_s,%ecx
	call	simple_write

	testl	%esi,%esi
	jnz	custom_400

default_400:
	movl	$br_m,%ecx
	call	wpstr_err

custom_400:
	movl	%esi,%ecx
	movl	%edi,%edx
	call	wrhtml

	.global	return_400_str
return_400_str:
	movl	%ecx,%esi
	movl	$br_s,%ecx
	call	simple_write
	movl	%esi,%ecx
	call	wpstr_err

	.global	return_500
return_500:
	movl	%ecx,%esi
	movl	%edx,%edi
	movl	$ie_s,%ecx
	call	simple_write

	testl	%esi,%esi
	jnz	custom_500

default_500:
	movl	$ie_m,%ecx
	call	wpstr_err

custom_500:
	movl	%esi,%ecx
	movl	%edi,%edx
	call	whtml

	.global	return_500_str
return_500_str:
	movl	%ecx,%esi
	movl	$ie_s,%ecx
	call	simple_write
	movl	%esi,%ecx
	call	wpstr_err
