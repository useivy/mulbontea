[org 0x7C00]
[bits 16]

xor ax, ax
mov ss, ax
mov es, ax
mov sp, 0x0500 ; overwrites some bios data but it works for now

mov bx, MSG_FIRST
call bios_print

mov al, 0x01
mov cx, 0x0002
mov dh, 0x00
mov bx, 0x7E00
call bios_disk_read

mov bx, MSG_DISK_TEST
call bios_print

call mup32

%include "bootloader/realm/print.asm"
%include "bootloader/realm/print_hex.asm"
%include "bootloader/realm/disk.asm"
%include "bootloader/realm/gdt32.asm"
%include "bootloader/realm/mup32.asm"

MSG_FIRST:    db `\r\nThe device is booted\r\n`, 0

times 510-($-$$) db 0
dw 0xAA55

pm:

;mov eax, 0x000B8000
;mov byte[eax], `H`
;mov eax, 0x000B8002
;mov byte[eax], 0x0F

mov esi, MSG_32B_ENTER
call print32

jmp $

%include "bootloader/protm/print32.asm"

PNT_vga_start:      equ 0x000B8000

MSG_DISK_TEST:      db `\r\nHiiii\r\n`, 0
MSG_32B_ENTER:      db `Entered 32bit mode`, 0

times 512 - ($ - pm) db 0