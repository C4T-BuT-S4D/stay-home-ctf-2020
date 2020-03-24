	.intel_syntax	noprefix

	.data
error:
	.asciz	"error"

	.text
	.global	return_error
return_error:
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
	call	return_json_response
	push	edi
	call	cJSON_Delete
	add	esp, 4
	pop	edi
	ret
