#include <util/delay.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <avr/sleep.h>

#include <mcp2515.h>
#include <mcp2515_defs.h>
#include <spi.h>
#include "lib/pwm.h"

int main(void)
{
	pwm_init();

	/* INT0, low level */
	EIMSK = _BV(INT0);

	mcp2515_init();

	sei();

	set_sleep_mode(SLEEP_MODE_EXT_STANDBY);

	for (;;) {
		sleep_mode();
	}

	return 0;
}

void can_msg_handler(void)
{
	pwm_handler();
}

ISR(INT0_vect)
{
	can_rx_handler(&can_msg_handler);
}

void user_tick_interrupt(void)
{

}
