#include <util/delay.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <inttypes.h>
#include <avr/pgmspace.h>

#include <mcp2515.h>
#include <mcp2515_defs.h>
#include <spi.h>
#include "lib/hausbus_protocols.h"
#include "lib/uart.h"

void can_print(void)
{
	uint8_t i;

	printf("id: %" PRIu32 "\n", can_get_std_id);
	if (can_is_extended) {
		printf("eid: %" PRIu32 "\n", can_get_ex_id);
	}
	if (can_is_remote_frame) {
		printf("rtr\n");
	} else {
		printf("data");
		for (i=0; i<can_get_len; i++) {
			printf(" %x", can_frame.data[i]);
		}
		printf("\n");
	}
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
	uint8_t canintf;

	MCP2515_enable;

	spi_wrrd(MCP2515_READ);
	spi_wrrd(MCP2515_CANINTF);
	canintf = spi_wrrd(0);

	MCP2515_disable;

	if (canintf & MCP2515_CANINTF_RX0IF) {
		can_rxh(0);
		/* handle can frame */
		can_print();
		hausbus_handler();
	}
	if (canintf & MCP2515_CANINTF_RX1IF) {
		can_rxh(1);
		/* handle can frame */
		can_print();
		hausbus_handler();
	}

	/* reset interrupt flags */
	mcp2515_perform(MCP2515_WRITE, MCP2515_CANINTF,
	        0x00,
	        0x00);
}
