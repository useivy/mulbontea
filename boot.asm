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

jmp $

%include "print.asm"
%include "print_hex.asm"
%include "disk.asm"

MSG_FIRST:    db `\r\nThe device is booted\r\n`, 0

times 510-($-$$) db 0
dw 0xAA55

extended_boot:

MSG_DISK_TEST:      db `\r\nHiiii\r\n`, 0

times 512 - ($ - extended_boot) db 0