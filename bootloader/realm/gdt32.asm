gdt32:
  gdt32_null:
    dd 0x00000000
    dd 0x00000000
    
  gdt32_code:
    dw 0xFFFF       ; Limit
    dw 0x0000       ; base
    db 0x00         ; base
    db 10011010b    ; flags
    db 11001111b    ; 4 flags + limit
    db 0x00         ; base
    
  gdt32_data:
    dw 0xFFFF       ; limit
    dw 0x0000       ; base
    db 0x00         ; base
    db 10010010b    ; flags
    db 11001111b    ; 4 flags + limit
    db 0x00         ; base
  
gdt32_end:

gdt32_desc:
  dw gdt32_end - gdt32 - 1      ; size - 1
  dd gdt32                      ; start
  
; pointers
PNT_code:     equ gdt32_code - gdt32      ; location within gdt
PNT_data:     equ gdt32_data - gdt32