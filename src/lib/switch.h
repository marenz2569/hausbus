#ifndef SWITCH_H__
#define SWITCH_H__

#include <inttypes.h>

#define B &PORTB
#define C &PORTC
#define D &PORTD

/*
 * commands:
 * set switch value: 0 0 [6 bits nothing] [24 bits mask] [24 bits values]
 * set switch lock: 1 1 [6 bits nothing] [24 bits mask] [24 bits values]
 * remove switch lock: 1 0 [6 bits nothing] [6 bytes nothing]
 */

enum {
	SWITCH_SET = 0x00,
	SWITCH_LOCK_SET = 0xc0,
	SWITCH_LOCK_REMOVE = 0x80,
	SWITCH_MASK = 0x3f
};

void switch_init(void);

void switch_handler(void);

void switch_set(const uint32_t id, const uint8_t sub, const uint8_t value);

void switch_lock_set(const uint32_t id, const uint8_t sub, const uint8_t value);

void switch_lock_remove(const uint32_t id, const uint8_t sub);

#endif
