[bits 16]

; ah - used by register
; al - num of sectors to read
; ch - cylinder number
; cl - sector number (first already loaded by bios!)
; dh - head number 
; dl - disk type (guaranteed to be set correctly)

; RETURN
; al - readed sectors
; ah - hex error code
; jc - set if error

bios_disk_read:
  push ax
  push bx
  push cx
  push dx
  
  mov ah, 0x02
  mov byte[loaded_sectors], al
  
  int 0x13
  
  jc bios_disk_read_error
  
  mov bl, byte[loaded_sectors]
  cmp al, bl
  jne bios_disk_read_error
  
  mov bx, MSG_bios_disk_read_success
  call bios_print
  
  pop dx
  pop cx
  pop bx
  pop ax
  
  ret

bios_disk_read_error:
  mov bx, MSG_bios_disk_read_err
  call bios_print
  
  shr ax, 8
  mov bx, ax
  call bios_print_hex
  
  jmp $


MSG_bios_disk_read_success:   db `\r\nSectors loaded\r\n`, 0
MSG_bios_disk_read_err:       db `\r\nError while loading sectors\r\n`, 0
loaded_sectors:               db 0x00