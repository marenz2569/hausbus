#ifndef PWM_H__
#define PWM_H__

#include <inttypes.h>

#include "handler.h"

#ifndef PWM_TABLE
#error "PWM_TABLE is not defined."
#endif

void pwm_init(void);

#endif
