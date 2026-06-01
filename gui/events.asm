; очередь событий

struc EVENT
    .type   resw 1
    .x      resw 1
    .y      resw 1
    .param  resw 1
endstruc

event_queue times 64 * EVENT_size db 0
event_head dw 0
event_tail dw 0

push_event:
    pusha
    mov di, [event_head]
    mov [di + EVENT.type], ax
    mov [di + EVENT.x], bx
    mov [di + EVENT.y], cx
    mov [di + EVENT.param], dx
    add word [event_head], EVENT_size
    cmp word [event_head], event_queue + (64 * EVENT_size)
    jne .done
    mov word [event_head], event_queue
.done:
    popa
    ret

pop_event:
    pusha
    mov si, [event_tail]
    cmp si, [event_head]
    je .empty
    mov ax, [si + EVENT.type]
    mov bx, [si + EVENT.x]
    mov cx, [si + EVENT.y]
    mov dx, [si + EVENT.param]
    add word [event_tail], EVENT_size
    cmp word [event_tail], event_queue + (64 * EVENT_size)
    jne .done
    mov word [event_tail], event_queue
.done:
    popa
    ret
.empty:
    xor ax, ax
    popa
    ret

handle_events:
    pusha
    call mouse_get_pos
    mov ax, 1
    mov bx, [mouse_x]
    mov cx, [mouse_y]
    mov dx, [mouse_click]
    call push_event
    
    call pop_event
    cmp ax, 0
    je .done
    cmp ax, 1
    je .mouse_event
.done:
    popa
    ret

.mouse_event:
    mov [mouse_x], bx
    mov [mouse_y], cx
    mov [mouse_click], dx
    ret
