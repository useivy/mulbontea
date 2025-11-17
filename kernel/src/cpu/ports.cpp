#include <cpu/ports.hpp>
#include <types.hpp>

intu8_t port_in(intu16_t port) {
  // read from a port
  intu8_t output;
  // __asm__
  // command : output : input
  // command : register -> variable : register <- variable
  // volatile makes sure that it will stay as it is
  // in gets whatever is in a port (bx) to a register (al)
  __asm__ volatile ("in %%dx, %%al" : "=a" (output) : "d" (port));
  return output;
}

void port_out(intu8_t data, intu16_t port) {
  __asm__ volatile ("out %%al, %%dx" : : "a" (data), "d" (port));
}