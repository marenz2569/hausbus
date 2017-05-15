#include <avr/interrupt.h>
#include <string.h>
#include <mcp2515.h>

#include "handler.h"
#include "switch.h"

#ifndef SWITCH_TABLE
#error "SWITCH_TABLE is not defined."
#endif

volatile uint32_t switch_lock;

const struct {
	const uint32_t id;
	const uint8_t sub;
	volatile uint8_t * const port;
	const uint8_t pin;
} __flash switch_handlermap[] = {
#define ENTRY(a, b, c, d) { can_std_id(c), d, &PORT ## a, PORT ## a ## b },
	SWITCH_TABLE
#undef ENTRY
};

void switch_init(void)
{
#define ENTRY(a, b, c, d) DDR ## a |= _BV(DD ## a ## b); \
                          PORT ## a &= ~_BV(PORT ## a ## b);
	SWITCH_TABLE
#undef ENTRY
}

void switch_handler(void)
{
	size_t i;
	uint32_t addr;

	addr = can_addr;
	for (i=0; i<sizeof(switch_handlermap)/sizeof(*switch_handlermap); i++) {
		if(0 == memcmp(&addr, &switch_handlermap[i].id, 4)) {
			if (can_is_extended || can_get_len != 7) {
				return;
			}
#define SWITCH_MSG_TO_U32(x) ((uint32_t) can_frame.data[x] << 16 | (uint32_t) can_frame.data[x] << 8 | (uint32_t) can_frame.data[x+2])
#define SWITCH_BIT           _BV((uint32_t) switch_handlermap[i].sub)
#define SWITCH_BIT_SET(x)    (SWITCH_BIT & SWITCH_MSG_TO_U32(x))
			if (SWITCH_BIT_SET(1) == 0) {
				return;
			}
			switch (can_frame.data[0] & ~SWITCH_MASK) {
			case SWITCH_SET:
				if ((switch_lock & SWITCH_BIT) == 0) {
switch_set_value:
					if (SWITCH_BIT_SET(4)) {
						*switch_handlermap[i].port |= _BV(switch_handlermap[i].pin);
					} else {
						*switch_handlermap[i].port &= ~_BV(switch_handlermap[i].pin);
					}
				}
				break;
			case SWITCH_LOCK_SET:
				switch_lock |= SWITCH_BIT;
				goto switch_set_value;
				break;
			case SWITCH_LOCK_REMOVE:
				switch_lock &= ~SWITCH_BIT;
				break;
			/* this case should never happen */
			default:
				break;
			}
		}
	}
}

static void switch_send(const uint32_t id, const uint8_t sub, const uint8_t value, const uint8_t op)
{
	uint8_t send_v[7] = {0};

	if (sub >= 24) {
		return;
	}
	send_v[0] = op;
	send_v[sub/8 + 1] = _BV(sub % 8);
	if (value) {
		send_v[sub/8 + 4] = _BV(sub % 8);
	}

	while (can_tx_busy())
		;
	can_send(can_std_id(id), sizeof(send_v)/sizeof(*send_v), send_v);
}

void switch_set(const uint32_t id, const uint8_t sub, const uint8_t value)
{
	switch_send(id, sub, value, SWITCH_SET);
}

void switch_lock_set(const uint32_t id, const uint8_t sub, const uint8_t value)
{
	switch_send(id, sub, value, SWITCH_LOCK_SET);
}

void switch_lock_remove(const uint32_t id, const uint8_t sub)
{
	switch_send(id, sub, 0, SWITCH_LOCK_REMOVE);
}
