#include <avr/interrupt.h>

#include "tick.h"

void tick_init(void)
{
	/* set up an interrupt every 1ms */
	systick = 0;
	OCR2A = 249;
	TIMSK2 = _BV(OCIE2A);
	TCCR2B = _BV(CS22);
}

ISR(TIMER2_COMPA_vect)
{
	TCNT2 = 0;

	systick++;

	user_tick_interrupt();
}
