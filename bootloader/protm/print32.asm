[bits 32]

; PRINT 32 BIT
; edi - destination addresss (vga memory)
; esi - source address (to print)
; ax:
;   al - character
;   ah - style

print32:
  pusha
  mov edi, PNT_vga_start
  
  print32_loop:
    cmp byte[esi], 0
    je print32_end
    
    mov al, byte[esi]
    mov ah, 0xAF
    
    mov word[edi], ax
    
    add esi, 1        ; to get new character
    add edi, 2        ; character plus style
    
    jmp print32_loop
    
print32_end:
  popa
  ret