section .data
    prompt1 db "Enter first number: "
    prompt1_len equ $ - prompt1
    prompt2 db "Enter second number: "
    prompt2_len equ $ - prompt2
    msg db "Result: "
    msg_len equ $ - msg
    newline db 10

section .bss
    input1 resb 16
    input2 resb 16
    result resb 12

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, prompt1_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input1
    mov edx, 16
    int 0x80

    mov ecx, input1
    call atoi
    mov esi, eax

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input2
    mov edx, 16
    int 0x80

    mov ecx, input2
    call atoi
    mov edi, eax

    mov eax, esi
    add eax, edi

    mov ecx, result + 11
    mov byte [ecx], 0
    mov ebx, 10

.convert:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz .convert

    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    pop ecx
    mov edx, result + 11
    sub edx, ecx
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

atoi:
    xor eax, eax
    xor ebx, ebx

.atoi_loop:
    mov bl, [ecx]
    cmp bl, '0'
    jl .atoi_done
    cmp bl, '9'
    jg .atoi_done

    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc ecx
    jmp .atoi_loop

.atoi_done:
    ret
