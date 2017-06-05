#include <avr/interrupt.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <mcp2515.h>

#include "handler.h"
#include "pwm.h"

#ifndef PWM_TABLE
#error "PWM_TABLE is not defined."
#endif

struct {
	const uint32_t id;
	volatile uint8_t lock;
	volatile uint8_t *value[4];
} pwm_handlermap[] = {
#define ID(a) { .id = a, .value = { NULL } }
#define ENTRY(a, b, c)
	PWM_TABLE
#undef ENTRY
#undef ID
};

#define EL pwm_handlermap[i]
#define MAP for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
#define MAP_END }
#define SEL EL.value[j]
#define SMAP for (j=0; j<4; j++) { \
             if (SEL == NULL) { \
						   continue; \
						 }
#define SMAP_END }

#define reg_D6 OCR0A
#define reg_D5 OCR0B
#define reg_B1 OCR1AL
#define reg_B2 OCR1BL

#define tccr_D6 TCCR0A
#define tccr_D5 TCCR0A
#define tccr_B1 TCCR1A
#define tccr_B2 TCCR1A

#define pin_D6 _BV(COM0A1) | _BV(COM0A0)
#define pin_D5 _BV(COM0B1) | _BV(COM0B0)
#define pin_B1 _BV(COM1A1) | _BV(COM1A0)
#define pin_B2 _BV(COM1B1) | _BV(COM1B0)

void pwm_init(void)
{
	size_t i = 0;

#define ID(a) i++;
#define ENTRY(a, b, c) DDR ## b |= _BV(DD ## b ## c); \
                       PORT ## b &= ~_BV(PORT ## b ## c); \
                       pwm_handlermap[i-1].value[a] = &reg_ ## b ## c; \
                       tccr_ ## b ## c |= pin_ ## b ## c; \
                       *pwm_handlermap[i-1].value[a] = 255;
	PWM_TABLE
#undef ENTRY
#undef ID

	/* div 64 prescaler, fast pwm, f = ~1kHz */
	/* setup timer 0 */
	TCCR0A |= _BV(WGM01) | _BV(WGM00);
	TCCR0B = _BV(CS01) | _BV(CS00);
	/* setup timer 1 */
	TCCR1A |= _BV(WGM10);
	TCCR1B = _BV(WGM12) | _BV(CS11) | _BV(CS10);
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
						*SEL = 255 - can_frame.data[j+1];
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
			send_v[1+j] = *SEL;
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
