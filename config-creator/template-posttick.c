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
