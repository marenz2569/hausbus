#include <avr/pgmspace.h>
#include <mcp2515.h>

#include "hausbus_protocols.h"

const struct {
	hausbus_handler_ids id;
	void (*handler) (void);
} hausbus_handlermap[] PROGMEM = {
#define ENTRY(a) { a, a ## _handler },
	HANDLER_TABLE
#undef ENTRY
};

void hausbus_handler(void)
{
	uint8_t i;
	uint32_t addr;

	for (i=0; i<sizeof(hausbus_handlermap)/sizeof(*hausbus_handlermap); i++) {
		/*
		 * using filter to avoid checking for rtr
		 * it's position is dependent on the frame type
		 * it will be checked in each handler function
		 */
		addr = can_addr & (MCP2515_RX_EID_FLAG | MCP2515_RX_ID_MASK | (can_is_extended?(MCP2515_RX_EID_MASK):0));
		if (0 == memcmp_P(&addr, &hausbus_handlermap[i].id, 4)) {
			hausbus_handlermap[i].handler();
			break;
		}
	}
}
