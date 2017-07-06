#ifndef OUTPUT_H__
#define OUTPUT_H__

#include <inttypes.h>

#define B &PORTB
#define C &PORTC
#define D &PORTD

/*
 * commands:
 * set output value: 0 0 [6 bits nothing] [24 bits mask] [24 bits values]
 * toggle output value: 0 1 [6 bits nothing] [24 bits mask] [3 bytes nothing]
 * set output lock: 1 1 [6 bits nothing] [24 bits mask] [24 bits values]
 * remove output lock: 1 0 [6 bits nothing] [24 bits mask] [3 bytes nothing]
 */

enum {
	OUTPUT_SET = 0x00,
	OUTPUT_TOGGLE = 0x40,
	OUTPUT_LOCK_SET = 0xc0,
	OUTPUT_LOCK_REMOVE = 0x80,
	OUTPUT_MASK = 0x3f
};

void output_init(void);

void output_handler(void);

void output_status(void);

void output_set(const uint32_t id, const uint8_t sub, const uint8_t value);

void output_toggle(const uint32_t id, const uint8_t sub);

void output_lock_set(const uint32_t id, const uint8_t sub, const uint8_t value);

void output_lock_remove(const uint32_t id, const uint8_t sub);

#endif
