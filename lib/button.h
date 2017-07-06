#ifndef SWITCH_H__
#define SWITCH_H__

#include <inttypes.h>

/*
 * commands:
 * set button lock: 1 [7 bits nothing] [3 byte mask]
 * remove button lock: 0 [7 bits nothing] [3 byte mask]
 */

enum {
	BUTTON_LOCK_SET = 0x80,
	BUTTON_LOCK_REMOVE = 0x00,
	BUTTON_MASK = 0x7f
};

struct button_sub {
	volatile uint8_t * port;
	uint8_t pin;
	/* number of shortpress (0 to 255) and longpress (0 or 1) */
	void (*f) (struct button_sub *, uint8_t);
	/* dimming may happen after a long press */
	struct {
		uint32_t id;
		uint8_t sub;
		uint8_t value;
		enum {
			NO_DIMMING = 0,
			START_DIMMING = 1,
			DIMMING = 2
		} status;
	} dimmer;
	uint8_t status;
	uint8_t count;
	uint64_t sched_time;
};

/* initialize as a button */
void button_init(void);

/* button poll loop */
void button_tick(void);
void button_dimmer(void);

/* receive as a button */
void button_handler(void);

/* send from button */
void button_status(void);

/* send to button */
void button_lock_set(const uint32_t id, const uint8_t sub, const uint8_t value);
void button_lock_remove(const uint32_t id, const uint8_t sub);

#endif
