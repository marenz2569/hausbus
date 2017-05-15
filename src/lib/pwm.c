#include <avr/interrupt.h>
#include <string.h>
#include <mcp2515.h>

#include "handler.h"
#include "pwm.h"

#ifndef PWM_TABLE
#error "PWM_TABLE is not defined."
#endif

#define ENTRY(a, b, c, d) volatile uint8_t pwm_ ## a ## b; \
                          volatile uint8_t pwm_ ## a ## b ## _lock = 0;
	PWM_TABLE
#undef ENTRY

const struct {
	const uint32_t id;
	const uint8_t sub;
	volatile uint8_t * const port;
	const uint8_t pin;
	volatile uint8_t * const value;
	volatile uint8_t * const lock;
} __flash pwm_handlermap[] = {
#define ENTRY(a, b, c, d) { can_std_id(c), d, &PORT ## a, PORT ## a ## b, &pwm_ ## a ## b, &pwm_ ## a ## b ## _lock },
	PWM_TABLE
#undef ENTRY
};

volatile uint8_t pwm_timemap[sizeof(pwm_handlermap)/sizeof(*pwm_handlermap) + 1];

void pwm_init(void)
{
	uint8_t i;

#define ENTRY(a, b, c, d) DDR ## a |= _BV(DD ## a ## b);
	PWM_TABLE
#undef ENTRY

	/* set initial value (off) */
	for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
		*pwm_handlermap[i].value = 0;
	}

	/* setup timer 2, div 1024 prescaler, ctc, compare match a, total f ~= 610Hz */
	OCR2A = 0;
	TIMSK2 = _BV(OCIE2A);
	TCCR2A = _BV(WGM21);
	TCCR2B = _BV(CS22) | _BV(CS21) | _BV(CS20);
}

static void pwm_order(void)
{
	size_t i, j;
	uint8_t tmp;

	/* copy to pwm_timetable from pwm_handlermap struct */
	for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
		pwm_timemap[i] = *pwm_handlermap[i].value;
	}
	pwm_timemap[sizeof(pwm_handlermap)/sizeof(*pwm_handlermap)] = 255;

	/* sort from left to right */
	for (i=1; i<sizeof(pwm_timemap)/sizeof(*pwm_timemap); i++) {
		for (j=1; j<sizeof(pwm_timemap)/sizeof(*pwm_timemap); j++) {
			if (pwm_timemap[j-1] > pwm_timemap[j]) {
				tmp = pwm_timemap[j-1];
				pwm_timemap[j-1] = pwm_timemap[j];
				pwm_timemap[j] = tmp;
			}
		}
	}

	/* calculate the differeneces between the times */
	for (i=sizeof(pwm_timemap)/sizeof(*pwm_timemap) - 1; i>1; i--) {
		pwm_timemap[i] = pwm_timemap[i] - pwm_timemap[i-1];
	}
}

ISR(TIMER2_COMPA_vect)
{
#if 0
	static volatile uint8_t pwm = 0;
	uint8_t i;

	TCNT2 = 0;

	if (pwm++ >= 255) {
		pwm = 0;
	}

	for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
		if (pwm == 0 && 0 != *pwm_handlermap[i].value) {
			*pwm_handlermap[i].port |= _BV(pwm_handlermap[i].pin);
		}
		if (pwm == *pwm_handlermap[i].value) {
			*pwm_handlermap[i].port &= ~_BV(pwm_handlermap[i].pin);
		}
	}

#else

	static size_t i = 0;
	static uint8_t val = 0;

	size_t j;

	/* reset and order */
	if (0 == (val %= 255)) {
		pwm_order();

		/* switch on all outputs if they are not equal to 0 */
		for (j=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); j++) {
			if (*pwm_handlermap[j].value != 0) {
				*pwm_handlermap[j].port |= _BV(pwm_handlermap[j].pin);
			}
		}
	}

	/* ignore the next times if they are equal to 0 */
	for (; i<sizeof(pwm_timemap)/sizeof(*pwm_timemap); i++) {
		if (0 == i) {
			continue;
		}
		/* set next time values */
		OCR2A = pwm_timemap[i];
		val += pwm_timemap[i];
		break;
	}

	/* switch off outputs if they have the current value */
	for (j=0; j<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); j++) {
		if (*pwm_handlermap[j].value == val) {
			*pwm_handlermap[j].port &= ~_BV(pwm_handlermap[j].pin);
		}
	}
#endif
}

void pwm_handler(void)
{
	size_t i;
	uint32_t addr;

	addr = can_addr;
	for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
		if(0 == memcmp(&addr, &pwm_handlermap[i].id, 4)) {
			if (can_is_extended || can_get_len != 7) {
				return;
			}
			if ((_BV(pwm_handlermap[i].sub) & can_frame.data[0] & PWM_MASK) == 0) {
				return;
			}
			switch (can_frame.data[0] & ~PWM_MASK) {
			case PWM_SET:
				if (*pwm_handlermap[i].lock == 0) {
pwm_set_value:
					*pwm_handlermap[i].value = can_frame.data[pwm_handlermap[i].sub + 1];
				}
				break;
			case PWM_LOCK_SET:
				*pwm_handlermap[i].lock = 1;
				goto pwm_set_value;
				break;
			case PWM_LOCK_REMOVE:
				*pwm_handlermap[i].lock = 0;
				break;
			/* this case should never happen */
			default:
				break;
			}
		}
	}
}

static void pwm_send(const uint32_t id, const	uint8_t sub, const uint8_t value, const uint8_t op)
{
	uint8_t send_v[7] = {0};

	if (sub >= 6) {
		return;
	}
	send_v[0] = op | (_BV(sub) & PWM_MASK);
	send_v[sub + 1] = value;

	while (can_tx_busy())
		;
	can_send(can_std_id(id), sizeof(send_v)/sizeof(*send_v), send_v);
}

void pwm_set(const uint32_t id, const uint8_t sub, const uint8_t value)
{
	pwm_send(id, sub, value, PWM_SET);
}

void pwm_lock_set(const uint32_t id, const uint8_t sub, const uint8_t value)
{
	pwm_send(id, sub, value, PWM_LOCK_SET);
}

void pwm_lock_remove(const uint32_t id, const uint8_t sub)
{
	pwm_send(id, sub, 0, PWM_LOCK_REMOVE);
}
