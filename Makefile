DEVICE = atmega328p
F_CPU = 16000000
# all files in lib folder
OBJECTS  = $(patsubst %.c, %.o, $(shell ls lib/*.c))
# all files from mcp2515 library
OBJECTS += lib/mcp2515/src/spi.o lib/mcp2515/src/mcp2515.o
# generated by http://www.engbedded.com/fusecalc/
# clockout at PORTB0
FUSES = -U lfuse:w:0xbe:m -U hfuse:w:0xd9:m -U efuse:w:0xff:m

USER_FOLDERS = src examples
VOLATILE_FILES = .o .d

TARGETS = $(shell ls $(addsuffix /*.c, $(USER_FOLDERS)) 2> /dev/null)
override _TARGETS = $(basename $(TARGETS))

CONFIG =
override _CONFIG = $(shell readlink -f $(CONFIG) 2> /dev/null)

CFLAGS = -Wall -Wfatal-errors -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -mrelax
LDFLAGS = -Wl,-gc-sections

AVRDUDE = avrdude -p$(DEVICE)
CC = avr-gcc -Os -flto -DF_CPU=$(F_CPU) -mmcu=$(DEVICE) -std=gnu99 -MD -MP

PUR = \033[0;35m
NC = \033[0m

.PHONY: clean fuse

.PRECIOUS: %.elf

all:
ifeq ($(_CONFIG), )
	$(MAKE) $(addsuffix .hex, $(_TARGETS))
else
	$(MAKE) $(addsuffix .config, $(_CONFIG))
endif

%.o:	%.c
	$(CC) $(CFLAGS) -I$(dir $@) -I$(dir $@)mcp2515/src/ -Ibuild/$(basename $@)/ -Ibuild/$(basename $@)/lib/mcp2515/src/ -c $< -o $@

%.flash: %.hex
	sudo python3 -c 'import sys, serial, time; ser = serial.Serial(sys.argv[1],57600); ser.setDTR(0); time.sleep(0.1); ser.setDTR(1); ser.close()' /dev/ttyUSB0
	sudo $(AVRDUDE) -C/usr/share/arduino/hardware/tools/avrdude.conf -q -q -cstk500v1 -P/dev/ttyUSB0 -b57600 -D -U flash:w:$< -U eeprom:w:$(basename $<).eep

%.flash-usbasp:	%.hex
	sudo $(AVRDUDE) -cusbasp -U flash:w:$< -U eeprom:w:$(basename $<).eep

fuse:
	sudo $(AVRDUDE) -cusbasp $(FUSES)

clean:
	rm -rf build/ $(foreach folder, $(USER_FOLDERS), $(foreach file, $(VOLATILE_FILES), $(folder)/*$(file)))

config-clean: clean
	rm -rf src/*

%.config: config-clean
	cd config-creator/ && $(MAKE) $@

%.elf: FORCE
	mkdir -p build/$(basename $@)
	cp -rf --preserve=all lib build/$(basename $@)
	echo "$(PUR)Copy configs$(NC)"
	cp -f --preserve=all $(basename $@).h build/$(basename $@)/lib/mcp2515/src/mcp2515_config.h
	cp -f --preserve=all $(basename $@).h build/$(basename $@)/lib/bootloader-can/bootloader-avr-mcp2515/config.h
	cp -f --preserve=all $(basename $@).h build/$(basename $@)/lib/handler.h
	echo "$(PUR)Building objects$(NC)"
	$(MAKE) $(addprefix build/$(basename $@)/, $(OBJECTS)) $(basename $@).o
	echo "$(PUR)Building $(basename $@) binary$(NC)"
	$(CC) $(LDFLAGS) -o build/$(basename $@)/$(notdir $@) $(addprefix build/$(basename $@)/, $(OBJECTS)) $(basename $@).o
	echo "$(PUR)Building $(basename $@) bootloader$(NC)"
	cd build/$(basename $@)/lib/bootloader-can/bootloader-avr-mcp2515/ && env -u MFLAGS -u MAKEFLAGS $(MAKE) MCU=$(DEVICE) F_CPU=$(F_CPU)
	cp build/$(basename $@)/lib/bootloader-can/bootloader-avr-mcp2515/bootloader.hex build/$(basename $@)/$(basename $(notdir $@))_bootloader.hex

%.hex: %.elf
	rm -f build/$(basename $@)/$(notdir $@)
	avr-objcopy -j .text -j .data -O ihex build/$(basename $<)/$(notdir $<) build/$(basename $@)/$(notdir $@)
	avr-objcopy -j .eeprom -O ihex build/$(basename $<)/$(notdir $<) build/$(basename $@)/$(basename $(notdir $@)).eep
	echo "$(PUR)$(basename $@) binary$(NC)"
	avr-size --mcu=$(DEVICE) --format=avr build/$(basename $@)/$(basename $(notdir $@)).elf build/$(basename $@)/lib/bootloader-can/bootloader-avr-mcp2515/build/bootloader.elf 

# .PHONY did not end up working so I used the old varient FORCE
FORCE:

include $(wildcard $(foreach target, $(basename $(_TARGETS)), build/$(target)/$(OBJECTS:.o=.d) $(target)/$(OBJECTS:.o=.d)))
