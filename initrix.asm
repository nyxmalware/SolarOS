; SolarOS Initrix (второй этап загрузки)
org 0x0000
bits 16

start:
    ; настройка сегментов
    mov ax, cs
    mov ds, ax
    mov es, ax
    
    ; сохраняем номер диска
    mov [boot_drive], dl

    ; выводим сообщение
    mov si, msg_init
    call print

    ; получаем параметры диска
    call disk_params
    mov [sectors_per_track], cx
    mov [heads], dh

    ; загружаем ядро с FAT12
    mov si, kernel_filename
    mov ax, KERNEL_SEGMENT
    mov bx, KERNEL_OFFSET
    mov dl, [boot_drive]
    call load_file

    ; передаём управление ядру
    mov ax, KERNEL_SEGMENT
    mov ds, ax
    mov es, ax
    jmp KERNEL_SEGMENT:KERNEL_OFFSET

%include "disk/fat12.asm"
%include "kernel/print.asm"

kernel_filename: db 'KERNEL  BIN'
boot_drive:      db 0
sectors_per_track: dw 0
heads:           dw 0

KERNEL_SEGMENT equ 0x2000
KERNEL_OFFSET  equ 0x0000

msg_init: db 'Initrix loaded initializing FAT...', 0x0D, 0x0A, 0