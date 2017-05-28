#include <avr/interrupt.h>
#include <string.h>
#include <mcp2515.h>

#include "handler.h"
#include "button.h"
#include "tick.h"
#include "pwm.h"

#ifndef BUTTON_TABLE
#error "BUTTON_TABLE is not defined."
#endif

#include <inttypes.h>

struct {
	const uint32_t id;
	volatile uint32_t lock;
	struct button_sub sub[24];
} button_handlermap[] = {
#define ID(a) { .id = a, .lock = 0, .sub = {{ .port = NULL, .pin = 0, .f = NULL , .dimmer = { .status = NO_DIMMING }, .shortpress = { .count = 0, .last_unpress = 0 } , .last = { .unpress = 0, .press = 0 } , .sched_time = 0 }} },
#define ENTRY(a, b, c)
	BUTTON_TABLE
#undef ENTRY
#undef ID
};

#define MAP for (i=0; i<sizeof(button_handlermap)/sizeof(*button_handlermap); i++)
#define EL button_handlermap[i]
#define SMAP for (j=0; j<24; j++)
#define SEL EL.sub[j]

#define ID(a)
#define ENTRY(a, b, c) extern void button_ ## b ## c(struct button_sub *, uint8_t);
	BUTTON_TABLE
#undef ENTRY
#undef ID

void button_init(void)
{
	size_t i = 0;

#define ID(a) i++;
#define ENTRY(a, b, c) DDR ## b &= ~_BV(DD ## b ## c); \
                       PORT ## b |= _BV(PORT ## b ## c); \
                       button_handlermap[i-1].sub[a].port = &PIN ## b; \
                       button_handlermap[i-1].sub[a].pin = PIN ## b ## c; \
                       button_handlermap[i-1].sub[a].status = PIN ## b & _BV(PIN ## b ## c); \
                       button_handlermap[i-1].sub[a].f = &button_ ## b ## c;
	BUTTON_TABLE
#undef ENTRY
#undef ID
}

// maybe poll on pinchange interrupt? maybe this is not a good idea, as there is going to be no debouncing
// normaly open switches are o.k. what about normaly closed ones?
/* longpress or waiting after a short press terminates a sequence */
#define LONGPRESS_MIN_DELAY   400
#define SHORTPRESS_MAX_DELAY  500
#define INTER_PRESS_MAX_DELAY 500

void button_tick(void)
{
	size_t i, j;
	uint8_t port;
	uint64_t press_time, shortpress_delay;

	MAP {
		SMAP {
			if (SEL.port == NULL) {
				continue;
			}
			if (_BV(j) & EL.lock) {
				SEL.sched_time = 0;
				SEL.last.unpress = 0;
				SEL.last.press = 0;
				SEL.shortpress.count = 0;
				SEL.status = _BV(SEL.pin);
				continue;
			}
			if (systick > SEL.sched_time && SEL.sched_time != 0) {
				SEL.sched_time = 0;
				SEL.f(&SEL, 0);
				SEL.last.unpress = 0;
				SEL.last.press = 0;
				SEL.shortpress.count = 0;
			}
			/* on pin change */
			port = *SEL.port;
			if (SEL.status != (port & _BV(SEL.pin))) {
				SEL.status = port & _BV(SEL.pin);
				SEL.dimmer.status = NO_DIMMING;
				/* press */
				if (SEL.status == 0) {
					SEL.sched_time = 0;
					SEL.last.press = systick;
				/* unpress */
				} else {
					SEL.last.unpress = systick;
					press_time = SEL.last.unpress - SEL.last.press;
					if (press_time < LONGPRESS_MIN_DELAY) {
						SEL.sched_time = SEL.last.unpress + INTER_PRESS_MAX_DELAY;
						if (SEL.shortpress.count == 0) {
							SEL.shortpress.last_unpress = SEL.last.unpress;
						}
						shortpress_delay = SEL.last.unpress - SEL.shortpress.last_unpress;
						if (shortpress_delay > SHORTPRESS_MAX_DELAY) {
							SEL.shortpress.count = 1;
						} else {
							SEL.shortpress.count = (uint8_t) (((uint16_t) SEL.shortpress.count + 1) % 256);
						}
						SEL.shortpress.last_unpress = SEL.last.unpress;
					/* execute a long press or set dimmer flag */
					} else {
						SEL.sched_time = 0;
						SEL.f(&SEL, 1);
						SEL.last.unpress = 0;
						SEL.last.press = 0;
						SEL.shortpress.count = 0;
					}
				}
			}
		}
	}
}

void button_dimmer(void)
{
#define PDIM SEL.dimmer
	size_t i, j;

	MAP {
		SMAP {
			if (EL.lock & _BV(j)) {
				PDIM.status = NO_DIMMING;
			}
			switch (PDIM.status) {
			case NO_DIMMING:
				continue;
			case START_DIMMING:
				PDIM.value = 255;
				break;
			case DIMMING:
				PDIM.value--;
				if (PDIM.value == 0) {
					PDIM.status = NO_DIMMING;
				}
				break;
			}
			pwm_set(PDIM.id, PDIM.sub, PDIM.value);
		}
	}

}

void button_handler(void)
{
	size_t i, j;
	uint32_t addr, id;

	addr = can_addr;
	MAP {
		id = can_std_id(EL.id);
		if (0 == memcmp(&addr, &id, 4)) {
#define BUTTON_MSG_TO_U32(x) ((uint32_t) can_frame.data[x] | (uint32_t) can_frame.data[x+1] << 8 | (uint32_t) can_frame.data[x+2] << 16)
#define BUTTON_BIT           _BV(j)
#define BUTTON_BIT_SET(x)    (BUTTON_BIT & BUTTON_MSG_TO_U32(x))
			if (can_is_extended || can_get_len != 7 || BUTTON_MSG_TO_U32(1) == 0) {
				return;
			}
			SMAP {
				if (BUTTON_BIT_SET(1) == 0 || SEL.port == NULL) {
					continue;
				}
				switch (can_frame.data[0] & ~BUTTON_MASK) {
				case BUTTON_LOCK_SET:
					EL.lock |= BUTTON_BIT;
					break;
				case BUTTON_LOCK_REMOVE:
					EL.lock &= ~BUTTON_BIT;
					break;
				default:
					break;
				}
			}
		}
	}
}

void button_status(void)
{
	size_t i;
	uint8_t send_v[3];

#define LOCK_BITS(x) send_v[x] = EL.lock >> (x * 8)
	MAP {
		LOCK_BITS(0);
		LOCK_BITS(1);
		LOCK_BITS(2);
		while (can_tx_busy())
			;
		can_send(can_std_id(EL.id + 1), sizeof(send_v)/sizeof(*send_v), send_v);
	}
}

static void button_send(const uint32_t id, const uint8_t sub, const uint8_t value, const uint8_t op)
{
	uint8_t send_v[4] = {0};

	if (sub >= 24) {
		return;
	}
	send_v[0] = op;
	send_v[sub/8 + 1] = _BV(sub % 8);

	while (can_tx_busy())
		;
	can_send(can_std_id(id), sizeof(send_v)/sizeof(*send_v), send_v);
}

void button_lock_set(const uint32_t id, const uint8_t sub, const uint8_t value)
{
	button_send(id, sub, value, BUTTON_LOCK_SET);
}

void button_lock_remove(const uint32_t id, const uint8_t sub)
{
	button_send(id, sub, 0, BUTTON_LOCK_REMOVE);
}
