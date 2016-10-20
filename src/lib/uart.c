#include <avr/io.h>
#include <stdio.h>

#include "uart.h"
#include "uart_config.h"

#include <util/setbaud.h>

void uart_putc(char c, FILE *stream)
{
	if (c == '\n') {
		uart_putc('\r', stream);
	}

	loop_until_bit_is_set(UCSR0A, UDRE0);

	UDR0 = c;
}

FILE uart_output = FDEV_SETUP_STREAM(uart_putc, NULL, _FDEV_SETUP_WRITE);

void uart_init(void)
{
	UBRR0H = UBRRH_VALUE;
	UBRR0L = UBRRL_VALUE;

#if USE_2X
	UCSR0A |= _BV(U2X0);
#else
	UCSR0A &= ~_BV(U2X0);
#endif

	UCSR0C = _BV(UCSZ01) | _BV(UCSZ00) | _BV(UPM01) | _BV(UPM00);
	UCSR0B = _BV(TXEN0);

	stdout = &uart_output;
}
