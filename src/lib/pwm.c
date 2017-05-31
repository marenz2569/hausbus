#include <avr/interrupt.h>
#include <string.h>
#include <mcp2515.h>

#include "handler.h"
#include "pwm.h"

#ifndef PWM_TABLE
#error "PWM_TABLE is not defined."
#endif

#define ID(a)
#define ENTRY(a, b, c) uint8_t pwm_ ## b ## c; \
                       uint8_t pwm_ ## b ## c_safe;
	PWM_TABLE
#undef ENTRY
#undef ID

struct {
	const uint32_t id;
	volatile uint8_t lock;
	struct {
		volatile uint8_t * port;
		uint8_t pin;
		uint8_t * value;
		uint8_t * value_safe;
	} sub[6];
} pwm_handlermap[] = {
#define ID(a) { .id = a, .sub = {{ NULL, 0, NULL, NULL }} }
#define ENTRY(a, b, c)
	PWM_TABLE
#undef ENTRY
#undef ID
};

#define EL pwm_handlermap[i]
#define MAP for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
#define MAP_END }
#define SEL EL.sub[j]
#define SMAP for (j=0; j<6; j++) { \
             if (SEL.value == NULL) { \
						   continue; \
						 }
#define SMAP_END }

void pwm_init(void)
{
	size_t i = 0;

#define ID(a) i++;
#define ENTRY(a, b, c) DDR ## b |= _BV(DD ## b ## c); \
                       PORT ## b &= ~_BV(PORT ## b ## c); \
                       pwm_handlermap[i-1].sub[a].port = &PORT ## b; \
                       pwm_handlermap[i-1].sub[a].pin = PORT ## b ## c; \
                       pwm_handlermap[i-1].sub[a].value = &pwm_ ## b ## c; \
                       pwm_handlermap[i-1].sub[a].value_safe = &pwm_ ## b ## c_safe; \
                       *pwm_handlermap[i-1].sub[a].value = 0; \
                       *pwm_handlermap[i-1].sub[a].value_safe = 0;
	PWM_TABLE
#undef ENTRY
#undef ID

	/* setup timer 2, div 32 prescaler, ctc, compare match a, total f = ~2kHz */
	OCR2A = 0;
	TIMSK2 = _BV(OCIE2A);
	TCCR2A = _BV(WGM21);
	TCCR2B = _BV(CS21) | _BV(CS20);
}

ISR(TIMER2_COMPA_vect)
{
	static uint8_t val = 0;
	size_t i, j;

	MAP
		SMAP
			if (SEL.port == NULL) {
				continue;
			}
			if (val == 0) {
				memcpy(EL.sub[j].value, EL.sub[j].value_safe, sizeof(*EL.sub[j].value));
				if (*SEL.value != 0) {
					*SEL.port |= _BV(SEL.pin);
				}
			}
			if (*SEL.value == val) {
				*SEL.port &= ~_BV(SEL.pin);
			}
		SMAP_END
	MAP_END

	val++;
	val %= 255;
}

void pwm_handler(void)
{
	size_t i, j;
	uint32_t addr, id;

	addr = can_addr;
	MAP
		id = can_std_id(EL.id);
		if(0 == memcmp(&addr, &id, 4)) {
			if (can_is_extended || can_get_len != 7) {
				return;
			}
			if ((can_frame.data[0] & PWM_MASK) == 0) {
				return;
			}
			SMAP
				switch (can_frame.data[0] & ~PWM_MASK) {
				case PWM_SET:
					if ((EL.lock & _BV(j)) == 0) {
pwm_set_value:
						*SEL.value_safe = can_frame.data[j+1];
					}
					break;
				case PWM_LOCK_SET:
					EL.lock |= _BV(j);
					goto pwm_set_value;
					break;
				case PWM_LOCK_REMOVE:
					EL.lock &= ~_BV(j);
					break;
				/* this case should never happen */
				default:
					break;
				}
			SMAP_END
		}
	MAP_END
}

void pwm_status(void)
{
	size_t i, j;
	uint8_t send_v[7] = {0};

	MAP
		send_v[0] = EL.lock | PWM_MASK;
		SMAP
			send_v[1+j] = *SEL.value;
		SMAP_END
		while (can_tx_busy())
			;
		can_send(can_std_id(EL.id + 1), sizeof(send_v)/sizeof(*send_v), send_v);
	MAP_END
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
