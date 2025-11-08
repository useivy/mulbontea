[bits 32]
; MODE UPGRADE 64 BIT CHECK

mup64_ch:
  ; people wont use 16 bit cpus, but they may use 32 bit, so we have to check do they have 64 bit support
  pushad
  pushfd
  pop eax                   ; flags in eax
  
  mov ecx, eax              ; copy of eax
  
  xor eax, 1 << 21          ; will be flipped if no cpuid
  
  push eax
  popfd                     ; write
  
  pushfd
  pop eax                   ; get the new flags
  
  push ecx
  popfd                     ; restore flags to first state
  
  cmp eax, ecx
  je mup64_ch_ncpuid        ; check if flipped
  
  ; check if cpuid have function needed
  mov eax, 0x80000000
  cpuid
  cmp eax, 0x80000001
  jb mup64_ch_ncpuid            ; if cpuid have extended support, then cpuid woukd make eax greater than 0x80000000
  
  ; we know that we have cpuid that can check if we have 64 bit support
  mov eax, 0x80000001            ; its actually first command in extended cpuid
  cpuid
  test edx, 1 << 29             ; cpuid will puf some things in edx, 29 bit would be set if 64bit mode is possible
  jz mup64_ch_nlmode
  
  popad
  ret
  
  
mup64_ch_ncpuid:
  mov esi, MSG_mup64_ch_ncpuid
  call print32
  jmp $
  
mup64_ch_nlmode:
  mov esi, MSG_mup64_ch_nlmode
  call print32
  jmp $
  
 MSG_mup64_ch_ncpuid:     db `Unable to detect 64bit mode support`, 0
 MSG_mup64_ch_nlmode:     db `64 bit mode unsupported`, 0