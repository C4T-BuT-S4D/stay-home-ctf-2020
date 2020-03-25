	.data
ok_s:	.asciz	"HTTP/1.0 200 OK\r\n"
nf_s:	.asciz	"HTTP/1.0 404 Not found\r\n"
br_s:	.asciz	"HTTP/1.0 400 Bad request\r\n"
ie_s:	.asciz	"HTTP/1.0 500 Internal error\r\n"
nf_m:	.asciz	"<h1>Not found!</h1>"
br_m:	.asciz	"Bad request!"
ie_m:	.asciz	"Internal error!"

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
	call	wpstr

	.global	return_400
return_400:
	movl	%ecx,%esi
	movl	%edx,%edi
	movl	$br_s,%ecx
	call	simple_write

	testl	%esi,%esi
	jnz	custom_400

default_400:
	movl	$br_m,%esi
	call	wpstr

custom_400:
	movl	%esi,%ecx
	movl	%edi,%edx
	call	wrhtml

	.global	return_400_str
return_400_str:
	movl	%ecx,%esi
	movl	$br_s,%ecx
	call	simple_write
	call	wpstr

	.global	return_500
return_500:
	movl	%ecx,%esi
	movl	%edx,%edi
	movl	$ie_s,%ecx
	call	simple_write

	testl	%esi,%esi
	jnz	custom_500

default_500:
	movl	$ie_m,%esi
	call	wpstr

custom_500:
	movl	%esi,%ecx
	movl	%edi,%edx
	call	whtml

	.global	return_500_str
return_500_str:
	movl	%ecx,%esi
	movl	$ie_s,%ecx
	call	simple_write
	call	wpstr