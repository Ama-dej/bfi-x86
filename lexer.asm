lexer_failure:
	db "Brackets exist that have no pair.", 0ah, 0	

lexer:
	push edx
	push ebx
	push eax

	xor eax, eax
	xor ebx, ebx

.loop:
	mov al, byte[edx]
	inc edx
	cmp al, '['
	je .inc
	cmp al, ']'
	je .dec
	cmp al, 0
	jz .exit
	jmp .loop

.inc:
	inc ebx
	jmp .loop

.dec:
	dec ebx
	jmp .loop	

.exit:
	cmp ebx, 0
	jz .ok

	mov eax, lexer_failure
	call sprint	

	mov eax, 1
	mov ebx, 1
	int 80h

.ok:
	pop eax
	pop ebx
	pop edx
	ret
