#ifndef HAUSBUS_PROTOCOLS_H__
#define HAUSBUS_PROTOCOLS_H__

#include <stdint.h>

#include <mcp2515.h>
#include "handler.h"

typedef enum {
	LAMP1 = can_std_id(101)
} hausbus_handler_ids;

#ifndef HANDLER_TABLE
#error "HANDLER_TABLE is not defined."
#endif

#define ENTRY(a) void a ## _handler(void);
HANDLER_TABLE
#undef ENTRY

void hausbus_handler(void);

/* protocol specific stuff */
enum {
	LAMP_OFF      = 0,
	LAMP_ON       = 1,
	LAMP_SWITCH   = 2,
	LAMP_DIM_DOWN = 3,
	LAMP_DIM_UP   = 4,
	LAMP_DIM_TO   = 5,
};

#endif
