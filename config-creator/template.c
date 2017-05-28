#include <stdio.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <inttypes.h>

#include <mcp2515.h>
#include "lib/pwm.h"
#include "lib/output.h"
#include "lib/button.h"
#include "lib/tick.h"
#include "lib/uart.h"

int main(void)
{
	pwm_init();
	output_init();
	button_init();
	uart_init();

  tick_init();

	/* INT0, low level */
	EIMSK = _BV(INT0);

	mcp2515_init();

	sei();

	set_sleep_mode(SLEEP_MODE_IDLE);

	for (;;) {
		sleep_mode();
	}

	return 0;
}

void can_msg_handler(void)
{
	pwm_handler();
	output_handler();
	button_handler();
}

ISR(INT0_vect)
{
	can_rx_handler(&can_msg_handler);
}

void user_tick_interrupt(void)
{
	static uint8_t a = 0,
	               b = 0,
	               c = 0;

	if (++a > 100) {
		a = 0;

		pwm_status();
		output_status();
		button_status();
	}

	if (++b > 20) {
		b = 0;

		button_tick();
	}

	if (++c > 9) {
		c = 0;

		button_dimmer();
	}
}
