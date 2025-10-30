[org 0x7C00]
[bits 16]

mov bx, MSG_FIRST
call bios_print

jmp $

%include "print.asm"


MSG_FIRST:    db `\r\nThe device is booted\r\n`, 0
times 510-($-$$) db 0
dw 0xAA55