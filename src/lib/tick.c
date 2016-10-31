#include <avr/interrupt.h>

#include "tick.h"

void tick_init(void)
{
	systick = 0;
	OCR0A = 250;
	TIMSK0 = _BV(OCIE0A);
	TCCR0B = _BV(CS01) | _BV(CS00);
}

ISR(TIMER0_COMPA_vect)
{
	TCNT0 = 0;

	systick++;
}
