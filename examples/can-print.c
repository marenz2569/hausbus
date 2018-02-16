#include <util/delay.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <avr/sleep.h>
#include <string.h>
#include <avr/wdt.h>

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
		pwm_handler();
	output_handler();
	button_handler();

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
	uint8_t i, sreg;

	MCUSR &= ~(_BV(WDRF) | _BV(BORF) | _BV(EXTRF) | _BV(PORF));
	wdt_disable();

	pwm_init();
	output_init();
	button_init();
	uart_init();

	tick_init();

	printf("power on\n");

	/* INT0, low level */
	EIMSK = _BV(INT0);
	
	mcp2515_init();

	DDRD |= _BV(DDD0);
	PORTD &= ~_BV(PORTD0);

	sei();

	printf("isr activated\n");
	set_sleep_mode(SLEEP_MODE_IDLE);

	for (;;) {
loop_start:
		// do stuff for new packets
		for (i=0; i<2; i++) {
			if (can_buffer[i].state == FILLED) {
				memcpy(&can_frame, can_buffer + i, sizeof(can_frame));
				can_msg_printer();
				can_buffer[i].state = FREE;
			}
		}
		// goto sleep while waiting for new packets
		sreg = SREG;
		cli();
		for (i=0; i<2; i++) {
			if (can_buffer[i].state == FILLED) {
				goto loop_start;
			}
		}
		SREG = sreg;
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

static uint16_t every_1s = 0;
if (++every_1s > 1000) {
	every_1s = 0;
	PORTD ^= _BV(PORTD0);
	output_toggle(204,0);
}
			static uint8_t a = 0,
	               b = 0,
	               c = 0;

	if (++a > 100) {
		a = 0;

		pwm_status();
		output_status();
		button_status();
	}

	if (++b > 10) {
		b = 0;

		button_tick();
	}

	if (++c > 16) {
		c = 0;

		button_dimmer();
	}
}
