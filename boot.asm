[org 0x7C00]
[bits 16]

xor ax, ax
xor bx, bx
xor cx, cx
xor dx, dx
xor bp, bp
xor sp, sp
xor cs, cs
xor ds, ds
xor ss, ss

mov bx, MSG_FIRST
call print_bios

jmp $

%include "print.asm"


MSG_FIRST:    db `\r\nThe device is booted\r\n", 0
times 510-($-$$) db 0
dw 0xAA55