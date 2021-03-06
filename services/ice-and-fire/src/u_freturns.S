	.data
ok_s:	.asciz	"HTTP/1.0 200 OK\r\n"
cntt:	.asciz	"Content-Type: "
cntl:	.asciz	"Content-Length: "
nl:	.asciz	"\r\n"
nlnl:	.asciz	"\r\n\r\n"

js_e:	.asciz	".js"
css_e:	.asciz	".css"
html_e:	.asciz	".html"
png_e:	.asciz	".png"
jpg_e:	.asciz	".jpg"
dir_e:	.asciz	"/"

js_t:	.asciz	"application/javascript"
css_t:	.asciz	"text/css"
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
	jnz	label_css

	movl	$js_t,%ecx
	jmp	end_wct

label_css:
	movl	%esi,%ebx
	addl	%edi,%ebx
	subl	$4,%ebx
	movl	%ebx,%ecx
	movl	$css_e,%edx
	call	gstrcmp
	test	%eax,%eax
	jnz	label_html

	movl	$css_t,%ecx
	jmp	end_wct

label_html:
	movl	%esi,%ebx
	addl	%edi,%ebx
	subl	$5,%ebx
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
	subl	$4,%ebx
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
	subl	$4,%ebx
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

copy_file_contents:
	pushl	%ebx
xmm_cfc:
	cmpl	$16,%edx
	jl	int_cfc
	movups	(%ecx),%xmm0
	movups	%xmm0,(%eax)
	subl	$16,%edx
	addl	$16,%eax
	addl	$16,%ecx
	jmp	xmm_cfc

int_cfc:
	cmpl	$4,%edx
	jl	left_cfc
	movl	(%ecx),%ebx
	movl	%ebx,(%eax)
	subl	$4,%edx
	addl	$4,%eax
	addl	$4,%ecx
	jmp	int_cfc

left_cfc:
	test	%edx,%edx
	jz	end_cfc
	movb	(%ecx),%bl
	movb	%bl,(%eax)
	decl	%edx
	incl	%eax
	incl	%ecx
	jmp	left_cfc

end_cfc:
	popl	%ebx
	retl

write_file_contents:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi

	movl	%ecx,%ebx
	movl	%edx,%edi

	xorl	%ebp,%ebp
	subl	%edi,%esp
	subl	$4096,%esp
read_wfc:
	movl	$3,%eax
	movl	%esp,%ecx
	movl	$4096,%edx
	int	$0x80

	cmpl	$0,%eax
	jle	end_read_wfc

	movl	%esp,%ecx
	movl	%eax,%edx

	addl	%eax,%ebp
	neg	%eax
	addl	%ebp,%eax
	addl	%esp,%eax
	addl	$4096,%eax

	call	copy_file_contents
	jmp	read_wfc

end_read_wfc:
	addl	$4096,%esp

	movl	%esp,%esi
write_wfc:
	test	%ebp,%ebp
	jz	end_wfc

	movl	$4,%eax
	movl	$1,%ebx
	movl	%esi,%ecx
	movl	%ebp,%edx
	int	$0x80

	subl	%eax,%ebp
	addl	%eax,%esi
	jmp	write_wfc

end_wfc:
	xorl	%eax,%eax
	addl	%edi,%esp

	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
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

	.global	return_file
return_file:
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	%ecx,%esi

	movl	$5,%eax
	movl	%ecx,%ebx
	xorl	%ecx,%ecx
	xorl	%edx,%edx
	int	$0x80

	cmpl	$0,%eax
	jg	ok_file

no_file:
	call	return_404

ok_file:
	movl	%eax,%edi

	subl	$88,%esp
	movl	%esi,%ecx
	movl	%esp,%edx
	call	get_file_size

	movl	44(%esp),%ebx
	addl	$88,%esp

	movl	$ok_s,%ecx
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
	movl	%ebx,%edx
	call	write_file_contents

	popl	%edi
	popl	%esi
	popl	%ebx

	retl
