#ifndef __DRIVER_VIDEO_VGATEXT
#define __DRIVER_VIDEO_VGATEXT

#include <types.hpp>

#define VGA_BEGIN 0xB8000
#define VGA_ROWS 25
#define VGA_COLUMNS 80
#define VGA_AREA 80 * 25

typedef struct {
  intu8_t character;     // byte
  intu8_t style;
} __attribute__((packed)) vga_char;

void vgatext_clear(intu8_t bg_color, intu8_t fg_color);

void vgatext_enablecursor();
void vgatext_disablecursor();
void vgatext_movecursor_bycords(intu8_t x, intu8_t y);

void vgatext_charout(intu8_t character, intu8_t bg_color, intu8_t fg_color);
void vgatext_stringout(intu8_t* string, intu8_t bg_color, intu8_t fg_color);

#endif
