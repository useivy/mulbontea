#include <driver/video/vga_text.hpp>
#include <types.hpp>
extern "C" int kmain() {
  intu8_t msg[] = "hiiii";
  vgatext_enablecursor();
  vgatext_movecursor_bycords(0, 0);
  vgatext_clear((intu8_t) 0, (intu8_t) 15);
  vgatext_stringout(msg, (intu8_t) 0, (intu8_t) 15);
  //vgatext_charout((intu8_t) '\t', (intu8_t) 0, (intu8_t) 15);
  return 0;
}