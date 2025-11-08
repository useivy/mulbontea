[bits 32]
; MODE UPGRADE 64 BIT

mup64:
  mov ecx, 0xC0000080         ; the way to switch ti 64 bit mode isnt standarized much, every cpu can have different register for it
  rdmsr                       ; but we can read and write to model specific registers by saying ehat do we want in ecx and getting it in eax
  or eax, 1 << 8
  wrmsr                       ; and write eax to this MSR to enable 64 bit mode
  
  mov eax, cr0
  or eax, 1 << 31
  mov cr0, eax                ; enable paging
  
  lgdt [gdt64_desc]           ; load 64 bit gdt
  jmp PNT_code64:blm          ; get into 64 bit code segment
  
[bits 64]
blm:
  mov ax, PNT_data64
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  
  jmp lm
  