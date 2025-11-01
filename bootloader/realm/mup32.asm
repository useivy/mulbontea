[bits 16]

; MODE UPGRADE

mup32:
  cli
  
  lgdt [gdt32_desc]
  
  mov eax, cr0
  or eax, 0x00000001
  mov cr0, eax
  
  jmp PNT_code:bpm
  
  [bits 32]
  bpm:
  
  mov ax, PNT_data
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  
  mov eax, 0x90000
  mov esp, eax
  
  jmp pm