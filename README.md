# Hausbus

## Configuration

The configuration xml file is saved in `config-creator/`. Its schema definition is saved in `config-creator/config.xsd`.

To generate the `.c` and `.h` files, saved in `src/`, execute `./config-create [configuration file]` in the above mentioned directory.

An example is given in `config-creator/config.xml.example`.

## Functions

function | note | forbidden variable names
--- | --- | ---
button | execute code on press, unpress or click count events | el
output |
pwm |
tick | code will be executed every 1ms | a, b, c
code | add your own functions to the c file

## Debugging

- **check the fuses!**

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
