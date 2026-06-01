; графические примитивы

rect_fill:
    pusha
    mov di, ax
    mov si, cx
    sub si, di
    mov cx, si
.row:
    push cx
    mov cx, dx
    sub cx, bx
.col:
    pusha
    call put_pixel
    inc ax
    loop .col
    popa
    inc bx
    pop cx
    loop .row
    popa
    ret

rect_outline:
    pusha
    mov si, cx
    sub si, ax
    mov cx, si
.top:
    pusha
    call put_pixel
    inc ax
    loop .top
    popa
    mov cx, dx
    sub cx, bx
.right:
    pusha
    call put_pixel
    inc bx
    loop .right
    popa
    mov cx, si
.bottom:
    pusha
    call put_pixel
    dec ax
    loop .bottom
    popa
    mov cx, dx
    sub cx, bx
.left:
    pusha
    call put_pixel
    dec bx
    loop .left
    popa
    popa
    ret

put_pixel:
    pusha
    mov cx, 640
    mul cx
    add ax, bx
    mov di, ax
    mov al, bl
    mov [0xA0000 + di], al
    popa
    ret

draw_line:
    pusha
    cmp ax, cx
    je .vertical
    jb .x_swap
.x_swap:
    xchg ax, cx
    xchg bx, dx
.x_loop:
    pusha
    call line_calc
    mov bl, 0x0F
    call put_pixel
    inc ax
    cmp ax, cx
    jle .x_loop
    jmp .done
.vertical:
    cmp bx, dx
    jbe .y_loop
    xchg bx, dx
.y_loop:
    pusha
    mov bl, 0x0F
    call put_pixel
    inc bx
    cmp bx, dx
    jle .y_loop
.done:
    popa
    ret

line_calc:
    pusha
    mov si, cx
    sub si, ax
    mov di, dx
    sub di, bx
    cmp si, di
    jg .steep
    xchg si, di
.steep:
    mov cx, si
    mov dx, di
    popa
    ret

draw_string:
    pusha
.char:
    lodsb
    or al, al
    jz .done
    call draw_char
    add ax, 6
    jmp .char
.done:
    popa
    ret

draw_char:
    pusha
    push ax
    push bx
    mov si, font_8x16
    mov cl, al
    mov ch, 0
    shl cx, 4
    add si, cx
    pop bx
    pop ax
    mov cx, 16
.row:
    push cx
    mov cx, 8
    mov dl, [si]
.col:
    test dl, 0x80
    jz .skip
    pusha
    mov bl, 0x0F
    call put_pixel
    popa
.skip:
    shl dl, 1
    inc ax
    loop .col
    inc bx
    pop cx
    inc si
    loop .row
    popa
    ret

font_8x16:
    incbin "data/font.bin"
