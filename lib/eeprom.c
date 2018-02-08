#include <string.h>
#include <mcp2515.h>

#include "handler.h"
#include "eeprom.h"

#ifndef EEPROM_TABLE
#error "EEPROM_TABLE is not defined."
#endif

struct {
	const uint32_t id;
} eeprom_handlermap[] = {
#define ID(a) { .id = a },
	EEPROM_TABLE
#undef ID
};

#define EL eeprom_handlermap[i]
#define MAP for (i=0; i<sizeof(eeprom_handlermap)/sizeof(*eeprom_handlermap); i++) {
#define MAP_END }

void eeprom_handler(void)
{
	uint8_t i;
	uint32_t addr, id;

	addr = can_addr;
	MAP
		id = can_std_id(EL.id);
		if (0 == memcmp(&addr, &id, 4)) {
			if (can_is_extended || can_get_len == 0) {
				return;
			}
			eeprom_save();
		}
	MAP_END
}
