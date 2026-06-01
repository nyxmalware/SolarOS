; SolarOS string library

strlen:
    push bx
    mov bx, si
    xor ax, ax
.strlen_loop:
    cmp byte [si], 0
    je .done
    inc si
    inc ax
    jmp .strlen_loop
.done:
    mov si, bx
    pop bx
    ret

strcpy:
    pusha
.strcpy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    test al, al
    jnz .strcpy_loop
    popa
    ret

strcat:
    pusha
    call strlen
    add di, ax
    call strcpy
    popa
    ret

strcmp:
    pusha
.strcmp_loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .not_equal
    test al, al
    jz .equal
    inc si
    inc di
    jmp .strcmp_loop
.equal:
    popa
    xor ax, ax
    ret
.not_equal:
    popa
    mov ax, 1
    ret

strchr:
    pusha
.strchr_loop:
    mov al, [si]
    test al, al
    jz .not_found
    cmp al, cl
    je .found
    inc si
    jmp .strchr_loop
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
.strtolower_loop:
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
    jmp .strtolower_loop
.done:
    popa
    ret

strtoupper:
    pusha
.strtoupper_loop:
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
    jmp .strtoupper_loop
.done:
    popa
    ret
