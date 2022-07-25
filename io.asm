slen:
	push ebx
	mov ebx, eax
	
.loop:
	cmp byte[eax], 0
	jz .exit
	inc eax 
	jmp .loop 

.exit:
	sub eax, ebx
	pop ebx
	
	ret


sprint:
	push edx
	push ecx
	push ebx
	push eax

	mov ecx, eax

	call slen
	mov edx, eax

	mov eax, 4
	mov ebx, 1
	int 80h

	pop eax
	pop ebx
	pop ecx
	pop edx

	ret

sprintln:
	call sprint

	push eax
	mov eax, 0ah
	push eax
	mov eax, esp
	call sprint
	pop eax
	pop eax

	ret
