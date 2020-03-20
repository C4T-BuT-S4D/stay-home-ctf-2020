	.data
cntt:	.asciz	"Content-Type: "
cntl:	.asciz	"Content-Length: "
nl:	.asciz	"\r\n"
nlnl:	.asciz	"\r\n\r\n"

js_e:	.asciz	".js"
html_e:	.asciz	".html"
png_e:	.asciz	".png"
jpg_e:	.asciz	".jpg"

js_t:	.asciz	"application/javascript"
html_t:	.asciz	"text/html"
png_t:	.asciz	"image/png"
jpg_t:	.asciz	"image/jpeg"
def_t:	.asciz	"application/octet-stream"

	.text
write_content_type:
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	%ecx,%esi

	call	gstrlen
	movl	%eax,%edi

label_js:
	movl	%esi,%ebx
	addl	%edi,%ebx
	subl	$3,%ebx
	movl	%ebx,%ecx
	movl	$js_e,%edx
	call	gstrcmp
	test	%eax,%eax
	jnz	label_html

	movl	$js_t,%ecx
	jmp	end_wct

label_html:
	movl	%esi,%ebx
	addl	%edi,%ebx
	subl	$3,%ebx
	movl	%ebx,%ecx
	movl	$html_e,%edx
	call	gstrcmp
	test	%eax,%eax
	jnz	label_png

	movl	$html_t,%ecx
	jmp	end_wct

label_png:
	movl	%esi,%ebx
	addl	%edi,%ebx
	subl	$3,%ebx
	movl	%ebx,%ecx
	movl	$png_e,%edx
	call	gstrcmp
	test	%eax,%eax
	jnz	label_jpg

	movl	$png_t,%ecx
	jmp	end_wct

label_jpg:
	movl	%esi,%ebx
	addl	%edi,%ebx
	subl	$3,%ebx
	movl	%ebx,%ecx
	movl	$jpg_e,%edx
	call	gstrcmp
	test	%eax,%eax
	jnz	label_def

	movl	$jpg_t,%ecx
	jmp	end_wct

label_def:
	movl	$def_t,%ecx
	jmp	end_wct

end_wct:
	call	simple_write
	popl	%edi
	popl	%esi
	popl	%ebx
	retl

write_file_contents:
	pushl	%ebx
	pushl	%esi

	movl	%ecx,%esi

	subl	$4096,%esp
read_wfc:
	movl	$3,%eax
	movl	%esi,%ebx
	movl	%esp,%ecx
	movl	$4096,%edx
	int	$0x80

	cmpl	$0,%eax
	jle	end_wfc

	movl	%eax,%edx
	movl	$4,%eax
	movl	$1,%ebx
	movl	%esp,%ecx
	int	$0x80
	jmp	read_wfc

end_wfc:
	xorl	%eax,%eax
	addl	$4096,%esp
	popl	%esi
	popl	%ebx
	retl

get_file_size:
	pushl	%ebx

	movl	$0xc3,%eax
	movl	%ecx,%ebx
	movl	%edx,%ecx
	xorl	%edx,%edx
	int	$0x80

	popl	%ebx
	retl

	.global	return_file_response
return_file_response:
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	%ecx,%esi

	movl	$5,%eax
	movl	%ecx,%ebx
	movl	$0,%ecx
	xorl	%edx,%edx
	int	$0x80

	cmpl	$0,%eax
	jg	ok_file

no_file:
	call	return_404
	jmp	end_rfr

ok_file:
	movl	%eax,%edi

	subl	$88,%esp
	movl	%esi,%ecx
	movl	%esp,%edx
	call	get_file_size

	movl	44(%esp),%ebx
	addl	$88,%esp

	movl	$httpok,%ecx
	call	simple_write

	movl	$cntt,%ecx
	call	simple_write

	movl	%esi,%ecx
	call	write_content_type

	movl	$nl,%ecx
	call	simple_write

	movl	$cntl,%ecx
	call	simple_write

	movl	%ebx,%ecx
	call	watoi

	movl	$nlnl,%ecx
	call	simple_write

	movl	%edi,%ecx
	call	write_file_contents

end_rfr:
	popl	%edi
	popl	%esi
	popl	%ebx
	retl
