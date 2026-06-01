; SolarOS IDT setup

idt_real:
    dw 0x03FF
    dd 0

init_idt:
    pusha
    lidt [idt_real]
    popa
    ret

init_irq:
    pusha
    ; remap PIC
    mov al, 0x11
    out 0x20, al
    out 0xA0, al
    mov al, 0x20
    out 0x21, al
    mov al, 0x28
    out 0xA1, al
    mov al, 0x04
    out 0x21, al
    mov al, 0x02
    out 0xA1, al
    mov al, 0x01
    out 0x21, al
    out 0xA1, al
    popa
    ret

; default interrupt handler
default_int:
    pusha
    mov si, int_msg
    call print
    popa
    iret

int_msg: db '[!] Interrupt', 0x0D, 0x0A, 0
