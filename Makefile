DEVICE     = atmega328p
CLOCK      = 16000000
OBJECTS    = lib/mcp2515/src/spi.o lib/mcp2515/src/mcp2515.o src/lib/uart.o src/lib/tick.o
# objects with variable includes, that have to get rebuild each time
VOBJECTS   = src/lib/output.o src/lib/pwm.o src/lib/button.o
# generated by http://www.engbedded.com/fusecalc/
# clockout at PORTB0
FUSES      = -U lfuse:w:0xaf:m -U hfuse:w:0xd9:m -U efuse:w:0x04:m

TARGETS = $(shell ls src/*.c)
override _TARGETS = $(basename $(notdir $(TARGETS)))

LIB =
LIBINCLUDE =
INCLUDE = -Ilib/mcp2515/src
FLAGS = $(LIB) $(LIBINCLUDE) $(INCLUDE)

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
	rm -f $(addsuffix .hex, $(_TARGETS)) $(addsuffix .elf, $(_TARGETS)) $(addprefix src/, $(addsuffix .o, $(_TARGETS))) $(OBJECTS) $(VOBJECTS) src/lib/handler.h

%.elf: FORCE
	echo "$(PUR)Building objects$(NC)"
	make objects
	echo "$(PUR)Copying variable include file$(NC)"
	cp -f src/$(basename $@).h src/lib/handler.h
	echo "$(PUR)Building main file$(NC)"
	make --always-make src/$(basename $@).o
	echo "$(PUR)Building objects files with variable includes$(NC)"
	make --always-make $(VOBJECTS)
	echo "$(PUR)Building $(basename $@) binary$(NC)"
	$(COMPILE) -std=gnu99 -o $@ $(OBJECTS) src/$(basename $@).o $(VOBJECTS)

%.hex: %.elf
	rm -f $@
	avr-objcopy -j .text -j .data -O ihex $(basename $@).elf $@
	echo "$(PUR)$(basename $@) binary$(NC)"
	avr-size $(basename $@).elf --mcu=$(DEVICE) --format=avr

# .PHONY did not end up working so I used the old varient FORCE
FORCE:
