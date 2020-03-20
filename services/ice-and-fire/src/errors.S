	.data
nf_s:	.asciz	"HTTP/1.0 404 Not found\r\n"
br_s:	.asciz	"HTTP/1.0 400 Bad request\r\n"
ie_s:	.asciz	"HTTP/1.0 500 Internal error\r\n"
nf_m:	.asciz	"<h1>Not found!</h1>"
br_m:	.asciz	"<h1>Bad request!</h1>"
ie_m:	.asciz	"<h1>Internal error!</h1>"

	.text
	.global	return_404
return_404:
	movl	$nf_s,%ecx
	call	simple_write
	movl	$nf_m,%ecx
	call	return_html_response
	retl

	.global	return_400
return_400:
	movl	$br_s,%ecx
	call	simple_write
	movl	$br_m,%ecx
	call	return_html_response
	retl

	.global	return_500
return_500:
	movl	$ie_s,%ecx
	call	simple_write
	movl	$ie_m,%ecx
	call	return_html_response
	retl
