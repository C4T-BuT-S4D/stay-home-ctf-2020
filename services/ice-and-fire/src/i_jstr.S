	.intel_syntax	noprefix

	.data
error:
	.asciz	"error"
ok:
	.asciz	"ok"

	.text
	.global	wjerrstr
wjerrstr:
	push	edi
	call	cJSON_CreateObject
	mov	edi, eax
	push	esi
	call	cJSON_CreateString
	add	esp, 4
	push	eax
	push	offset	error
	push	edi
	call	cJSON_AddItemToObject
	add	esp, 12
	mov	ecx, edi
	call	wjson

	.global	wjokstr
wjokstr:
	push	edi
	call	cJSON_CreateObject
	mov	edi, eax
	push	esi
	call	cJSON_CreateString
	add	esp, 4
	push	eax
	push	offset	ok
	push	edi
	call	cJSON_AddItemToObject
	add	esp, 12
	mov	ecx, edi
	call	wjson