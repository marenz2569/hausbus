#ifndef PWM_H__
#define PWM_H__

#include <inttypes.h>

#include "handler.h"

#ifndef PWM_TABLE
#error "PWM_TABLE is not defined."
#endif

void pwm_init(void);

void pwm_inc(volatile uint8_t * const port, const uint8_t pin);

void pwm_dec(volatile uint8_t * const port, const uint8_t pin);

void pwm_set(volatile uint8_t * const port, const uint8_t pin, const uint8_t value);

#endif
