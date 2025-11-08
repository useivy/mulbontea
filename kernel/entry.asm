; this should be at 0x8200 (1MB specified in boot.asm)
; apparently a linker can do it, but to use it I have to sadly no longer use binary output, I have to use ELF

[bits 64]
[extern kmain]

global _start           ; for ELF
section .startup           ; also

_start:
  call kmain
  jmp $
