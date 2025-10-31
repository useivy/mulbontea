[bits 16]

; al - used by register
; bl - to write
; cl - used by code to know when 4 characters are printed (so no need for 0 at the end, but limit to 4 chars)

bios_print_hex:
  push ax
  push bx
  push cx
  
  mov ah, 0x0E
  mov cx, 0
  
  bios_print_hex_loop:
    cmp cx, 4
    je bios_print_hex_end
    
    push bx
    
    shr bx, 12
    cmp bx, 9
    jg bios_print_hex_letter
    
    mov al, '0'
    add al, bl
    jmp bios_print_hex_print
    
    bios_print_hex_letter:
      sub bl, 10
      mov al, 'A'
      add al, bl
      
    bios_print_hex_print:
      int 0x10
      inc cx
      
      pop bx
      shl bx, 4
      
      jmp bios_print_hex_loop
      
      
bios_print_hex_end:
  pop cx
  pop bx
  pop ax
  
  ret