%include "src/io.inc"
%include "src/lexer.asm"

section .data
debilizem:
	db "Syntax: bf <brainfuck_program>", 0ah, 0
no_file?:
	db "Invalid file name.", 0ah, 0
filename:
	times 256 db 0
BF_BUFFER:
	times 30000 dd 0 

section .bss
BF_CODE:
	resb 1000001

section .text
global _start
_start:
	pop ecx
	cmp ecx, 2
	jne inv_para_size

	pop eax
	pop eax

	mov ecx, filename
	xor edx, edx

get_file_name:
	mov dl, byte[eax]
	cmp dl, 0
	jz .out 
	mov byte[ecx], dl
	inc eax
	inc ecx
	jmp get_file_name

.out:
	mov eax, 5
	mov ebx, filename
	mov ecx, 0
	int 80h

	cmp eax, 0 
	jl file_keine_exist 

	mov ebx, eax
	mov eax, 3
	mov ecx, BF_CODE
	mov edx, 1000000	
	int 80h
	
	xor eax, eax
	mov ecx, BF_BUFFER
	mov edx, BF_CODE

	call lexer

main_loop:
	mov al, byte[edx]
	inc edx

	cmp al, '>'
	je right

	cmp al, '<'
	je left

	cmp al, '+'
	je plus

	cmp al, '-'
	je minus

	cmp al, '.'
	je putchar

	cmp al, ','
	je getchar

	cmp al, '['
	je loop_start

	cmp al, ']'
	je loop_end

	cmp al, 0
	jz exit

	jmp main_loop 

right:
	add ecx, 4
	jmp main_loop

left:
	sub ecx, 4
	jmp main_loop

plus:
	mov eax, dword[ecx]
	inc eax
	mov dword[ecx], eax
	jmp main_loop 

minus:
	mov eax, dword[ecx]
	dec eax
	mov dword[ecx], eax
	jmp main_loop

putchar:
	push edx

	mov eax, 4
	mov ebx, 1
	mov edx, 4 
	int 80h

	pop edx

	jmp main_loop

getchar:
	push edx

	mov eax, 3
	mov ebx, 0
	mov edx, 1
	int 80h

	pop edx

	jmp main_loop

loop_start:
        cmp dword[ecx], 0
        jne main_loop
        xor ebx, ebx

.find_partner:
	push .find_partner
        mov al, byte[edx]
        inc edx
        cmp al, ']'
        je chk_if_matching
        cmp al, '['
        je another_one
	pop eax
        jmp .find_partner

loop_end:
	cmp dword[ecx], 0
	jz main_loop
	xor ebx, ebx
	dec edx

.find_partner:
	push .find_partner
	dec edx
	mov al, byte[edx]
	cmp al, '['
	je chk_if_matching
	cmp al, ']'
	je another_one
	pop eax
	jmp .find_partner

chk_if_matching:
	pop eax
	cmp ebx, 0
	jz main_loop
	dec ebx
	jmp eax

another_one:
	pop eax
	inc ebx
	jmp eax

inv_para_size:
	mov eax, debilizem
	call sprint

	mov eax, 1
	mov ebx, 1
	int 80h

file_keine_exist:
	mov eax, no_file? 
	call sprint
	
	mov eax, 1
	mov ebx, 2
	int 80h

exit:
	mov eax, 1
	mov ebx, 0
	int 80h 
