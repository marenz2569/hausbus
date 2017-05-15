#include <util/delay.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <avr/pgmspace.h>
#include <avr/sleep.h>

#include <mcp2515.h>
#include "lib/pwm.h"
#include "lib/switch.h"
#include "lib/tick.h"

int main(void)
{
	/* INT0, low level */
	EIMSK = _BV(INT0);

	mcp2515_init();

	// tick_init();

	set_sleep_mode(SLEEP_MODE_EXT_STANDBY);

	sei();

	for (;;) {
		sleep_mode();
	}

	return 0;
}

void can_msg_handler(void)
{
	pwm_handler();
	switch_handler();
}

ISR(INT0_vect)
{
	can_rx_handler(&can_msg_handler);
}

void user_tick_interrupt(void)
{

}
