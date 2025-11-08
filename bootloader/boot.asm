[org 0x7C00]

jmp brm
kernel_size db 0
brm:

[bits 16]

xor ax, ax
mov ss, ax
mov es, ax
mov sp, 0x0500 ; overwrites some bios data but it works for now

mov bx, MSG_FIRST
call bios_print

mov al, [kernel_size]
add al, 0x02
mov cx, 0x0002
mov dh, 0x00
mov bx, 0x7E00
call bios_disk_read

mov bx, MSG_DISK_TEST
call bios_print

call mup32

%include "realm/print.asm"
%include "realm/print_hex.asm"
%include "realm/disk.asm"
%include "realm/gdt32.asm"
%include "realm/mup32.asm"

MSG_FIRST:    db `\r\nThe device is booted\r\n`, 0

times 510-($-$$) db 0
dw 0xAA55

pm:

call mup64_ch

mov esi, MSG_32B_ENTER
call print32

call paging64
call mup64

jmp $

%include "protm/print32.asm"
%include "protm/gdt64.asm"
%include "protm/mup64_ch.asm"
%include "protm/mup64.asm"
%include "protm/paging64.asm"

PNT_vga_start:      equ 0x000B8000

MSG_DISK_TEST:      db `\r\nHiiii\r\n`, 0
MSG_32B_ENTER:      db `Entered 32bit mode`, 0

times 512 - ($ - pm) db 0

lm:

call kernel_start

; anything here should never be executed, maybe I will add something here if it returns (err msg)

jmp $

kernel_start:           equ 0x8200      ; some people use 0x10000 to get a good looking address, I use 0x8200 because its exactly 1MB

times 512 - ($ - lm) db 0