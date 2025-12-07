section .bss
    buffer resb 256

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 256
    int 0x80
    mov esi, eax

    mov ecx, buffer
    mov edi, esi

.loop:
    test edi, edi
    jz .done

    mov al, [ecx]

    cmp al, 'a'
    jl .next
    cmp al, 'z'
    jg .next

    sub al, 0x20
    mov [ecx], al

.next:
    inc ecx
    dec edi
    jmp .loop

.done:
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, esi
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
