[bits 32]

; PAGING 64 BIT

; 0x1000 PML4T
; 0x2000 PDPT
; 0x3000 PDT
; 0x4000 PT

; PML4T points to PDPT points to PDT points to PT
; mapping with only one page table, equals to around 2MB of memory
; since interrupts wont be used anymore propably, this space is propably good to use
; page table and other tables have 512 entries, each takes 8 bytes, so 4096 bytes (16xxx) bytes used for paging
; but besides one page table everything will be zero for now

paging64:
  pushad    ; push all regs and flags
  ; clear everything from 0x1000 (beggining of PML4T) to 0x4FFF (the end of PT)
  
  mov edi, 0x1000
  mov cr3, edi          ; cr3 is the register that contain a pointer to PML4T
  xor eax, eax
  mov ecx, 4096
  rep stosd             ; this will write eax (0), which is a double word (4 bytes), and repeat this 4096 times incrementing edi by a dword. 4 bytes multiplied by 4096 times give 16xxx so the needed space
  
  mov edi, cr3
  
  ; from now for some reason every address that will be used must be able to be divided by 0x1000
  ; the last 3 hex digits will be used for flags, and they couldnt find a better place (address and flags overlap, address = towrite - flags)
  
  ; edi at PML4T
  
  mov dword[edi], 0x2003        ; PML4T pointing to PDPT with flags exsisting plus read/write
  add edi, 0x1000
  mov dword[edi], 0x3003        ; PDPT pointing to PDT with flags
  add edi, 0x1000
  mov dword[edi], 0x4003        ; PDT pointing to PT with flags
  
  ; ENTRIES ARENT NEW ADDRESSING SCHEME, SO ENTRY 1 ISNT 0X1 IN VIRTUAL MEMORY, IT MAPS FIRST 1000 PLACES STARTING FROM THE ENTRY ADDRESS
  ; so if entry 0 (first) is mapped to 0x1000, so in virtual memory 0x0 is 0x1000 in real memory, 0x1 is 0x1001
  add edi, 0x1000             ; go to PT
  mov ebx, 0x00000003         ; address 0x0 with flags
  mov ecx, 512                ; 512 times, for 512 entries
  
  paging64_entryadd:
    mov dword[edi], ebx       ; move to page table what we want to send
    add ebx, 0x1000           ; flags stay, but the address is plus 0x1000
    add edi, 8                ; entry is 8 bytes, so adding 8 bytes to address
    
    loop paging64_entryadd
    
    mov eax, cr4
    or eax, 1 << 5            ; setting fifth bit of cr4, so telling cpu i want to use paging
    mov cr4, eax
    
    popad
    ret                       ; paging should be working
  
  
  
  