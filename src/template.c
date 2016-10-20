#include <util/delay.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <avr/pgmspace.h>

#include <mcp2515.h>
#include <mcp2515_defs.h>
#include <spi.h>
#include "lib/hausbus_protocols.h"

int main(void)
{
	/* INT0, low level */
	EIMSK = _BV(INT0);

	mcp2515_init();

	DDRB |= _BV(DDB1);

	sei();

	for (;;) {
	}

	return 0;
}

ISR(INT0_vect)
{
	uint8_t canintf;

	MCP2515_enable;

	spi_wrrd(MCP2515_READ);
	spi_wrrd(MCP2515_CANINTF);
	canintf = spi_wrrd(0);

	MCP2515_disable;

	if (canintf & MCP2515_CANINTF_RX0IF) {
		can_rxh(0);
		/* handle can frame */
		hausbus_handler();
	}
	if (canintf & MCP2515_CANINTF_RX1IF) {
		can_rxh(1);
		/* handle can frame */
		hausbus_handler();
	}

	/* reset interrupt flags */
	mcp2515_perform(MCP2515_WRITE, MCP2515_CANINTF,
	        0x00,
	        0x00);
}

void LAMP1_handler(void)
{
	if (can_get_len == 1 && can_is_standard && can_is_standard) {
		switch (can_frame.data[0]) {
		case LAMP_ON:
			PORTB ^= _BV(PORTB1);
			break;
		}
	}
}
