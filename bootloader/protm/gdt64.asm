; GDT 64
; same as 32 bit, but with 64 bit flag set

align 4

gdt64:
  gdt64_null:
    dd 0x00000000
    dd 0x00000000
    
  gdt64_code:
    dw 0xFFFF       ; Limit
    dw 0x0000       ; base
    db 0x00         ; base
    db 10011010b    ; flags
    db 10101111b    ; 4 flags + limit
    db 0x00         ; base
    
  gdt64_data:
    dw 0xFFFF       ; limit
    dw 0x0000       ; base
    db 0x00         ; base
    db 10010010b    ; flags
    db 10100000b    ; 4 flags + limit (data sector wont be needed (paging))
    db 0x00         ; base
  
gdt64_end:

gdt64_desc:
  dw gdt64_end - gdt64 - 1      ; size - 1
  dd gdt64                      ; start
  
; pointers
PNT_code64:     equ gdt64_code - gdt64      ; location within gdt
PNT_data64:     equ gdt64_data - gdt64