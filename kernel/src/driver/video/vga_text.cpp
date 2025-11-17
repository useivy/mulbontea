#include <driver/video/vga_text.hpp>
#include <cpu/ports.hpp>
#include <types.hpp>
// vga usable is an array of vga chars at VGA_BEGIN
volatile vga_char* const VGA_USABLE = reinterpret_cast<volatile vga_char*>(VGA_BEGIN);

intu16_t vgatext_getcursor() {
  intu16_t position = 0;
  
  port_out(0x0F, PORT_VGATEXT_CURSORPOS_OUT);
  position |= port_in(PORT_VGATEXT_CURSORPOS_IN);
  
  port_out(0x0E, PORT_VGATEXT_CURSORPOS_OUT);
  position |= port_in(PORT_VGATEXT_CURSORPOS_IN) << 8;
  
  return position;
}

void vgatext_enablecursor() {
  port_out(0x0A, PORT_VGATEXT_CURSORPOS_OUT);
  port_out((port_in(PORT_VGATEXT_CURSORPOS_IN) & 0xC0) | (intu8_t) 13, PORT_VGATEXT_CURSORPOS_IN);
  
  port_out(0x0B, PORT_VGATEXT_CURSORPOS_OUT);
  port_out((port_in(PORT_VGATEXT_CURSORPOS_IN) & 0xE0) | (intu8_t) 15, PORT_VGATEXT_CURSORPOS_IN);
}

void vgatext_disablecursor() {
  port_out(0x0A, PORT_VGATEXT_CURSORPOS_OUT);
  port_out(0x20, PORT_VGATEXT_CURSORPOS_IN);
}

void vgatext_movecursor_bycords(intu8_t x, intu8_t y) {
  intu16_t position = VGA_COLUMNS * y + x;
  
  port_out(0x0F, PORT_VGATEXT_CURSORPOS_OUT);
  port_out((intu8_t) (position & 0xFF), PORT_VGATEXT_CURSORPOS_IN);
  port_out(0x0E, PORT_VGATEXT_CURSORPOS_OUT);
  port_out((intu8_t) ((position >> 8) & 0xFF), PORT_VGATEXT_CURSORPOS_IN);
}

void vgatext_movecursor_advance() {
  intu16_t position = vgatext_getcursor();
  position++;
  
  port_out(0x0F, PORT_VGATEXT_CURSORPOS_OUT);
  port_out((intu8_t) (position & 0xFF), PORT_VGATEXT_CURSORPOS_IN);
  port_out(0x0E, PORT_VGATEXT_CURSORPOS_OUT);
  port_out((intu8_t) ((position >> 8) & 0xFF), PORT_VGATEXT_CURSORPOS_IN);
}

void vgatext_movecursor_decrease() {
  intu16_t position = vgatext_getcursor();
  position--;
  
  port_out(0x0F, PORT_VGATEXT_CURSORPOS_OUT);
  port_out((intu8_t) (position & 0xFF), PORT_VGATEXT_CURSORPOS_IN);
  port_out(0x0E, PORT_VGATEXT_CURSORPOS_OUT);
  port_out((intu8_t) ((position >> 8) & 0xFF), PORT_VGATEXT_CURSORPOS_IN);
}

intu8_t vgatext_makecolor(intu8_t bg_color, intu8_t fg_color) {
  // bg color in upper 4 bits, remove 4 upper bits from fg color and merge them
  return (bg_color << 4) | (fg_color & 0x0F);
}

void vgatext_clear(intu8_t bg_color, intu8_t fg_color) {
  intu8_t color = vgatext_makecolor(bg_color, fg_color);
  const intu8_t blank = ' ';
  
  for (intu64_t i = 0; i < VGA_AREA; i++) {
    VGA_USABLE[i].character = blank;
    VGA_USABLE[i].style = color;
  }
}

void vgatext_charout(intu8_t character, intu8_t bg_color, intu8_t fg_color) {
  intu16_t position = vgatext_getcursor();
  
  if (character == '\n') {
    // to do
  } else if (character == '\t') {
    for (intu8_t i = 3; i > 0; i--) {
      vgatext_charout('a', bg_color, fg_color);
    }
  } else {
    intu8_t style = vgatext_makecolor(bg_color, fg_color);
    VGA_USABLE[position].character = character;
    VGA_USABLE[position].style = style;
    vgatext_movecursor_advance();
  }
}

void vgatext_stringout(intu8_t* string, intu8_t bg_color, intu8_t fg_color) {
  while (*string != '\0') {
    vgatext_charout((intu8_t) *string, bg_color, fg_color);
    string++;
  }
}

// this method might fix issues on older/special devices
//void vgatext_enablecursor1() {
//  port_out(0x0A, PORT_VGATEXT_CURSORPOS_OUT);
//  intu8_t argbegin = port_in(PORT_VGATEXT_CURSORPOS_IN);
//  
//  port_out(0x0A, PORT_VGATEXT_CURSORPOS_OUT);
//  port_out(argbegin & 0xC0, PORT_VGATEXT_CURSORPOS_IN);
//  
//  port_out(0x0B, PORT_VGATEXT_CURSORPOS_OUT);
//  intu8_t argend = port_in(PORT_VGATEXT_CURSORPOS_IN);
//  
//  port_out(0x0B, PORT_VGATEXT_CURSORPOS_OUT);
//  port_out(argend & 0xE0, PORT_VGATEXT_CURSORPOS_IN);
//}