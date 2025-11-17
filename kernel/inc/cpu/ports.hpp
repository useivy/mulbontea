#ifndef __CPU_PORTS
#define __CPU_PORTS

#include <types.hpp>

intu8_t port_in(intu16_t port);
void port_out(intu8_t data, intu16_t port);

#define PORT_VGATEXT_CURSORPOS_OUT (intu16_t) 0x3D4
#define PORT_VGATEXT_CURSORPOS_IN (intu16_t) 0X3D5

#endif