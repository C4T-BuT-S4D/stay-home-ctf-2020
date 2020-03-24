	.intel_syntax	noprefix
	.data
cntt:	.asciz	"Content-Type: application/json\r\n"
cntl:	.asciz	"Content-Length: "
nlnl:	.asciz	"\r\n\r\n"

	.text
	.global	return_json_response
return_json_response:
	push	esi
	push	ecx
	call	cJSON_PrintUnformatted
	add	esp, 4
	mov	esi, eax

	mov	ecx, offset cntt
	call	simple_write

	mov	ecx, offset cntl
	call	simple_write

	mov	ecx, esi
	call	gstrlen
	mov	ecx, eax
	call	watoi

	mov	ecx, offset nlnl
	call	simple_write

	mov	ecx, esi
	call	simple_write

	push	esi
	call	free
	add	esp, 4

	pop esi
	ret
