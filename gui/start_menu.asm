start_menu_show:
    pusha
    mov ax, 10
    mov bx, 400
    mov cx, 120
    mov dx, 60
    mov bl, 0x08
    call rect_fill
    mov ax, 15
    mov bx, 405
    mov si, shutdown_str
    call draw_string
    mov ax, 15
    mov bx, 425
    mov si, exit_str
    call draw_string
    call mouse_get_pos
    cmp word [mouse_click], 0
    je start_menu_show
    cmp bx, 400
    jl .close
    cmp bx, 460
    jg .close
    cmp bx, 405
    jge .check_shutdown
.close:
    call repaint_desktop
    popa
    ret
.check_shutdown:
    cmp bx, 420
    jle .do_shutdown
    cmp bx, 425
    jge .do_exit
    jmp .close
.do_shutdown:
    call system_shutdown
    jmp .close
.do_exit:
    call exit_to_cmd
    jmp .close

shutdown_str: db 'Shutdown', 0
exit_str: db 'Exit to CMD', 0
