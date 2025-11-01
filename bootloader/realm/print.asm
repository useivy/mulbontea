[bits 16]

; PRINT BIOS
; ax: displayed thing
; bx: used by interrupt, characters

bios_print:
    push ax
    push bx
    
    mov ah, 0x0E
    
    bios_print_loop:
        cmp byte[bx], 0
        je bios_print_end
        
        mov al, byte[bx]
        int 0x10
        inc bx
        jmp bios_print_loop
        
bios_print_end:
    pop bx
    pop ax
    ret

