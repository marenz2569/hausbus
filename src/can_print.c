#include <util/delay.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <avr/pgmspace.h>

#include <mcp2515.h>
#include <mcp2515_defs.h>
#include <spi.h>
#include "lib/uart.h"

void can_print(void)
{
	uint8_t i;

	if (can_is_extended || can_is_remote_frame) {
		return;
	}

	printf("{\"id\":%" PRIu32 ",\"data\":[", can_get_std_id);

	for (i=0; i<can_get_len;) {
		printf("%d", can_frame.data[i]);
		if (++i < can_get_len) {
			printf(",");
		}
	}

	printf("]}\n");
}

int main(void)
{
	uart_init();

	/* INT0, low level */
	EIMSK = _BV(INT0);

	mcp2515_init();

	sei();

	for (;;) {
	}

	return 0;
}

ISR(INT0_vect)
{
	can_rx_handler(&can_print);
}

void user_tick_interrupt(void)
{

}
