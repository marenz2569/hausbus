#include <util/delay.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <avr/sleep.h>
#include <string.h>

#include <mcp2515.h>
#include <mcp2515_defs.h>
#include <spi.h>
#include <lib/pwm.h>
#include <lib/output.h>
#include <lib/button.h>
#include <lib/uart.h>
#include <lib/tick.h>

void can_msg_printer(void)
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
	uint8_t i;

	pwm_init();
	output_init();
	button_init();
	uart_init();

	tick_init();

	printf("power on\n");

	/* INT0, low level */
	EIMSK = _BV(INT0);
	
	mcp2515_init();

	sei();

	set_sleep_mode(SLEEP_MODE_IDLE);

	for (;;) {
		for (i=0; i<2; i++) {
			if (can_buffer[i].state == FILLED) {
				memcpy(&can_frame, can_buffer + i, sizeof(can_frame));
				can_msg_printer();
				can_buffer[i].state = FREE;
			}
		}
		sleep_mode();
	}

	return 0;
}

ISR(INT0_vect)
{
	can_rx_handler();
}

void user_tick_interrupt(void)
{
}
