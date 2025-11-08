ENTRY(_start);

SECTIONS {
  . = 0x8200;
  
  .startup : {
    _start = .;       /* kernel to 0x8200 */
    *(.startup)
  }
  
  .text : { *(.text) }
  .rodata : { *(.rodata) }
  .bss : { *(.bss) }
  .data : { *(.data) }
}