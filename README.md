# Hausbus

## Configuration

The configuration xml file is saved in `config-creator/`. Its schema definition is saved in `config-creator/config.xsd`.

To generate the `.c` and `.h` files, saved in `src/`, execute `make CONFIG=[path to config file]`.

An example configuration is given in `config-creator/config.xml.example`.

### Functions

function | note | forbidden variable names | tested
--- | --- | --- | ---
button | execute code on press, unpress or click count events | el | :white_check_mark:
output |
pwm ||| :white_check_mark:
tick | code will be executed every 1ms | a, b, c | :white_check_mark:
code | add your own functions to the c file || :white_check_mark:
loop | add your own code to the loop otherwise the controller will be put to idle sleep mode; variables used here must be declared in the `init` function; do not write blocking code, otherwise can messages might not be read || :white_check_mark:
init | add your own code to the init || :white_check_mark:


## Building

Execute `make -j` to build all targets or execute `make -j TARGETS=[list of .c files]`.

## Bootloader

The nodes on the can bus can be flashed via the [can-bootloader from Fabian Greif][3].

## Debugging

- **check the fuses!**
- **check the slave select pin**

## Dependencies

* [Saxon 9.8][1]
* xmllint from libxml2
* [Zsh][2]
* gcc-avr
* binutils-avr
* avr-libc
* python3
* graphviz

[1]: https://sourceforge.net/projects/saxon/files/Saxon-HE/
[2]: http://zsh.sourceforge.org
[3]: http://www.kreatives-chaos.com/artikel/can-bootloader
