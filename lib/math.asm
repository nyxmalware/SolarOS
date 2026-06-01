; SolarOS math library

abs:
    test ax, ax
    jns .done
    neg ax
.done:
    ret

min:
    cmp ax, bx
    jle .done
    mov ax, bx
.done:
    ret

max:
    cmp ax, bx
    jge .done
    mov ax, bx
.done:
    ret

pow:
    push bx cx
    mov cx, bx
    mov bx, ax
    mov ax, 1
.pow_loop:
    test cx, cx
    jz .done
    mul bx
    dec cx
    jmp .pow_loop
.done:
    pop cx bx
    ret

div32:
    push bx
    xor dx, dx
    div bx
    pop bx
    ret

mod32:
    push bx
    xor dx, dx
    div bx
    mov ax, dx
    pop bx
    ret

mul16:
    push dx
    mul bx
    pop dx
    ret

rand:
    push bx dx
    mov ax, [rand_seed]
    mov bx, 1103515245
    mul bx
    add ax, 12345
    mov [rand_seed], ax
    shr ax, 16
    pop dx bx
    ret

rand_seed: dw 0x1234

atoi:
    push bx si
    xor bx, bx
    xor ax, ax
    mov si, di
.atoi_loop:
    mov cl, [si]
    test cl, cl
    jz .done
    cmp cl, '0'
    jl .done
    cmp cl, '9'
    jg .done
    imul bx, 10
    sub cl, '0'
    movzx cx, cl
    add bx, cx
    inc si
    jmp .atoi_loop
.done:
    mov ax, bx
    pop si bx
    ret

itoa:
    push bx cx dx di
    mov bx, 10
    xor cx, cx
    mov di, si
    test ax, ax
    jnz .convert
    mov byte [di], '0'
    inc di
    jmp .done
.convert:
    push ax
.div_loop:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz .div_loop
    pop ax
.write_loop:
    pop ax
    stosb
    loop .write_loop
.done:
    mov byte [di], 0
    pop di dx cx bx
    ret
