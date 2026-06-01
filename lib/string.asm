; SolarOS string library

strlen:
    push bx
    mov bx, si
    xor ax, ax
.loop:
    cmp byte [si], 0
    je .done
    inc si
    inc ax
    jmp .loop
.done:
    mov si, bx
    pop bx
    ret

strcmp:
    pusha
.loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .not_equal
    test al, al
    jz .equal
    inc si
    inc di
    jmp .loop
.equal:
    popa
    clc
    ret
.not_equal:
    popa
    stc
    ret

strcpy:
    pusha
.loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    test al, al
    jnz .loop
    popa
    ret

strcat:
    pusha
    call strlen
    add di, ax
    call strcpy
    popa
    ret

strchr:
    pusha
.loop:
    mov al, [si]
    test al, al
    jz .not_found
    cmp al, cl
    je .found
    inc si
    jmp .loop
.found:
    mov ax, si
    popa
    ret
.not_found:
    xor ax, ax
    popa
    ret

strtolower:
    pusha
.loop:
    mov al, [si]
    test al, al
    jz .done
    cmp al, 'A'
    jl .next
    cmp al, 'Z'
    jg .next
    add al, 0x20
    mov [si], al
.next:
    inc si
    jmp .loop
.done:
    popa
    ret

strtoupper:
    pusha
.loop:
    mov al, [si]
    test al, al
    jz .done
    cmp al, 'a'
    jl .next
    cmp al, 'z'
    jg .next
    sub al, 0x20
    mov [si], al
.next:
    inc si
    jmp .loop
.done:
    popa
    ret
