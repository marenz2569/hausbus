#ifndef PWM_H__
#define PWM_H__

#include <inttypes.h>

#define B &PORTB
#define C &PORTC
#define D &PORTD

/*
 * commands:
 * set pwm value: 0 0 [6 bits mask] [6 bytes pwm values each being 1 byte long]
 * set pwm lock: 1 1 [6 bits mask] [6 bytes pwm values each being 1 byte long]
 * remove pwm lock: 1 0 [6 bits mask] [6 bytes nothing]
 */

enum {
	PWM_SET = 0x00,
	PWM_LOCK_SET = 0xc0,
	PWM_LOCK_REMOVE = 0x80,
	PWM_MASK = 0x3f
};

void pwm_init(void);

void pwm_handler(void);

void pwm_set(const uint32_t id, const uint8_t sub, const uint8_t value);

void pwm_lock_set(const uint32_t id, const uint8_t sub, const uint8_t value);

void pwm_lock_remove(const uint32_t id, const uint8_t sub);

#endif
