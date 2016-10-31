#include <avr/interrupt.h>

#include "pwm.h"
#include "handler.h"

#define ENTRY(a, b) volatile uint8_t pwm_ ## a ## b;
	PWM_TABLE
#undef ENTRY

const struct {
	volatile uint8_t * const port;
	const uint8_t pin;
	volatile uint8_t * const value;
} __flash pwm_handlermap[] = {
#define ENTRY(a, b) { &PORT ## a, PORT ## a ## b, &pwm_ ## a ## b },
	PWM_TABLE
#undef ENTRY
};

void pwm_init(void)
{
	uint8_t i;

#define ENTRY(a, b) DDR ## a |= _BV(DD ## a ## b);
	PWM_TABLE
#undef ENTRY

	for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
		*pwm_handlermap[i].value = 0;
	}

	/* setup timer 2 */
	OCR2A = 16;
	TIMSK2 = _BV(OCIE2A);
	TCCR2B = _BV(CS20);
}

void pwm_inc(volatile uint8_t * const port, const uint8_t pin)
{
	uint8_t i;

	for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
		if (port == pwm_handlermap[i].port && pin == pwm_handlermap[i].pin) {
			if (*pwm_handlermap[i].value < 255) {
				*pwm_handlermap[i].value++;
			}
			break;
		}
	}
}

void pwm_dec(volatile uint8_t * const port, const uint8_t pin)
{
	uint8_t i;

	for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
		if (port == pwm_handlermap[i].port && pin == pwm_handlermap[i].pin) {
			if (*pwm_handlermap[i].value > 0) {
				--*pwm_handlermap[i].value;
			}
			break;
		}
	}
}

void pwm_set(volatile uint8_t * const port, const uint8_t pin, const uint8_t value)
{
	uint8_t i;

	for (i=0; i<sizeof(pwm_handlermap)/sizeof(*pwm_handlermap); i++) {
		if (port == pwm_handlermap[i].port && pin == pwm_handlermap[i].pin) {
			*pwm_handlermap[i].value = value;
			break;
		}
	}
}

ISR(TIMER2_COMPA_vect)
{
	static volatile uint8_t pwm = 0;
	uint8_t i;

	TCNT2 = 0;

	if (++pwm > 255) {
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
}
