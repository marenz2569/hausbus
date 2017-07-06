DEVICE     = atmega328p
CLOCK      = 16000000
OBJECTS    = lib/mcp2515/src/spi.o lib/mcp2515/src/mcp2515.o lib/uart.o lib/tick.o
# objects with variable includes, that have to get rebuild each time
VOBJECTS   = lib/output.o lib/pwm.o lib/button.o
# generated by http://www.engbedded.com/fusecalc/
# clockout at PORTB0
FUSES      = -U lfuse:w:0xbe:m -U hfuse:w:0xd9:m -U efuse:w:0x07:m

TARGETS = $(shell ls src/*.c examples/*.c)
override _TARGETS = $(basename $(TARGETS))

LIB =
LIBINCLUDE =
INCLUDE = -Ilib/mcp2515/src -I.
FLAGS = $(LIB) $(LIBINCLUDE) $(INCLUDE) -ffunction-sections -fdata-sections

AVRDUDE = avrdude -p$(DEVICE)
COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -std=gnu99

PUR = \033[0;35m
NC = \033[0m

.PHONY: clean fuse

.PRECIOUS: %.elf

all: $(addsuffix .hex, $(_TARGETS))

objects: $(OBJECTS)

%.o:	%.c
	$(COMPILE) -c $< -o $@ $(FLAGS)

%.flash: %.hex
	sudo python -c 'import sys, serial, time; ser = serial.Serial(sys.argv[1],57600); ser.setDTR(0); time.sleep(0.1); ser.setDTR(1); ser.close()' /dev/ttyUSB0
	sudo $(AVRDUDE) -C/usr/share/arduino/hardware/tools/avrdude.conf -q -q -cstk500v1 -P/dev/ttyUSB0 -b57600 -D -U flash:w:$<

%.flash-usbasp:	%.hex
	sudo $(AVRDUDE) -cusbasp -U flash:w:$<

fuse:
	sudo $(AVRDUDE) -cusbasp $(FUSES)

clean:
	rm -f src/*.hex examples/*.hex src/*.elf examples/*.elf src/*.o examples/*.o $(OBJECTS) $(VOBJECTS) lib/handler.h

%.elf: FORCE
	echo "$(PUR)Copy configs$(NC)"
	cp -f config/mcp2515/mcp2515_config.h lib/mcp2515/src/mcp2515_config.h
	echo "$(PUR)Building objects$(NC)"
	make objects
	echo "$(PUR)Copying variable include file$(NC)"
	cp -f $(basename $@).h lib/handler.h
	echo "$(PUR)Building main file$(NC)"
	make --always-make $(basename $@).o
	echo "$(PUR)Building objects files with variable includes$(NC)"
	make --always-make $(VOBJECTS)
	echo "$(PUR)Building $(basename $@) binary$(NC)"
	$(COMPILE) -std=gnu99 -Wl,-gc-sections -o $@ $(OBJECTS) $(basename $@).o $(VOBJECTS)

%.hex: %.elf
	rm -f $@
	avr-objcopy -j .text -j .data -O ihex $(basename $@).elf $@
	echo "$(PUR)$(basename $@) binary$(NC)"
	avr-size $(basename $@).elf --mcu=$(DEVICE) --format=avr

# .PHONY did not end up working so I used the old varient FORCE
FORCE:
