#include <avr/interrupt.h>
#include <string.h>
#include <mcp2515.h>

#include "handler.h"
#include "output.h"

#ifndef OUTPUT_TABLE
#error "OUTPUT_TABLE is not defined."
#endif

struct {
	const uint32_t id;
	volatile uint32_t lock;
	struct {
		volatile uint8_t * port;
		uint8_t pin;
	} sub[24];
} output_handlermap[] = {
#define ID(a) { .id = a, .lock = 0, .sub = {{ .port = NULL, .pin = 0 }} },
#define ENTRY(a, b, c)
	OUTPUT_TABLE
#undef ENTRY
#undef ID
};

#define MAP for (i=0; i<sizeof(output_handlermap)/sizeof(*output_handlermap); i++)
#define EL output_handlermap[i]

void output_init(void)
{
	size_t i = 0;

#define ID(a) i++;
#define ENTRY(a, b, c) output_handlermap[i-1].sub[a].port = &PORT ## b; \
                       output_handlermap[i-1].sub[a].pin = PORT ## b ## c; \
                       DDR ## b |= _BV(DD ## b ## c); \
                       PORT ## b &= ~_BV(PORT ## b ## c);
	OUTPUT_TABLE
#undef ENTRY
#undef ID
}

void output_handler(void)
{
	size_t i, j;
	uint32_t addr, id;

	addr = can_addr;
	MAP {
		id = can_std_id(EL.id);
		if(0 == memcmp(&addr, &id, 4)) {
			if (can_is_extended || can_get_len != 7) {
				return;
			}
#define OUTPUT_MSG_TO_U32(x) ((uint32_t) can_frame.data[x] | (uint32_t) can_frame.data[x+1] << 8 | (uint32_t) can_frame.data[x+2] << 16)
#define OUTPUT_BIT           _BV((uint32_t) j)
#define OUTPUT_BIT_SET(x)    (OUTPUT_BIT & OUTPUT_MSG_TO_U32(x))
			if (OUTPUT_MSG_TO_U32(1) == 0) {
				return;
			}
			for (j=0; j<24; j++) {
				if (OUTPUT_BIT_SET(1) == 0 || EL.sub[j].port == NULL) {
					continue;
				}
				switch (can_frame.data[0] & ~OUTPUT_MASK) {
				case OUTPUT_SET:
					if ((EL.lock & OUTPUT_BIT) == 0) {
output_set_value:
						if (OUTPUT_BIT_SET(4)) {
							*EL.sub[j].port |= _BV(EL.sub[j].pin);
						} else {
							*EL.sub[j].port &= ~_BV(EL.sub[j].pin);
						}
					}
					break;
				case OUTPUT_TOGGLE:
					if ((EL.lock & OUTPUT_BIT) == 0) {
						*EL.sub[j].port ^= _BV(EL.sub[j].pin);
					}
					break;
				case OUTPUT_LOCK_SET:
					EL.lock |= OUTPUT_BIT;
					goto output_set_value;
					break;
				case OUTPUT_LOCK_REMOVE:
					EL.lock &= ~OUTPUT_BIT;
					break;
				/* this case should never happen */
				default:
					break;
				}
			}
		}
	}
}

void output_status(void)
{
	size_t i, j;
	uint8_t send_v[6] = {0};

#define LOCK_BITS(x) send_v[x] = EL.lock >> (x * 8)
	MAP {
		LOCK_BITS(0);
		LOCK_BITS(1);
		LOCK_BITS(2);
		for (j=0; j<24; j++) {
			if (*EL.sub[j].port & _BV(EL.sub[j].pin)) {
				send_v[j/8+3] |= _BV(j%8);
			}
		}
		while (can_tx_busy())
			;
		can_send(can_std_id(EL.id + 1), sizeof(send_v)/sizeof(*send_v), send_v);
	}
}

static void output_send(const uint32_t id, const uint8_t sub, const uint8_t value, const uint8_t op)
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

void output_set(const uint32_t id, const uint8_t sub, const uint8_t value)
{
	output_send(id, sub, value, OUTPUT_SET);
}

void output_toggle(const uint32_t id, const uint8_t sub)
{
	output_send(id, sub, 0, OUTPUT_TOGGLE);
}

void output_lock_set(const uint32_t id, const uint8_t sub, const uint8_t value)
{
	output_send(id, sub, value, OUTPUT_LOCK_SET);
}

void output_lock_remove(const uint32_t id, const uint8_t sub)
{
	output_send(id, sub, 0, OUTPUT_LOCK_REMOVE);
}
