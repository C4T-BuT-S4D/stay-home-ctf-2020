	.intel_syntax	noprefix
	.data
cntt:	.asciz	"Content-Type: application/json\r\n"
cntl:	.asciz	"Content-Length: "
nlnl:	.asciz	"\r\n\r\n"

	.text
	.global	wjson
wjson:
	push	esi
	push	edi
	push	ecx
	mov	edi, ecx
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

	push	edi
	call	cJSON_Delete
	add	esp, 4

	push	0
	call	exit
