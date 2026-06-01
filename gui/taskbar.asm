; панель задач

taskbar_height equ 20

draw_taskbar:
    pusha
    mov ax, 0
    mov bx, 460
    mov cx, 640
    mov dx, taskbar_height
    mov bl, 0x07
    call rect_fill
    
    ; разделительная линия
    mov ax, 0
    mov bx, 460
    mov cx, 640
    mov dx, 461
    mov bl, 0x0F
    call rect_fill
    
    call draw_start_button
    
    ; часы
    call update_clock
    mov ax, 560
    mov bx, 462
    mov si, clock_str
    call draw_string
    
    popa
    ret

update_clock:
    pusha
    mov ah, 0x02
    int 0x1A
    mov al, ch
    call bcd_to_ascii
    mov [clock_str], ax
    mov [clock_str+2], ':'
    mov al, cl
    call bcd_to_ascii
    mov [clock_str+3], ax
    popa
    ret

bcd_to_ascii:
    pusha
    mov ah, al
    shr al, 4
    add al, '0'
    and ah, 0x0F
    add ah, '0'
    mov [.high], al
    mov [.low], ah
    popa
    mov ax, [.high]
    ret
.high: db 0
.low:  db 0

clock_str: db '00:00', 0
