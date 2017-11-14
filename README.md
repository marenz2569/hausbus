# Hausbus

## Configuration

The configuration xml file is saved in `config-creator/`. Its schema definition is saved in `config-creator/config.xsd`.

To generate the `.c` and `.h` files, saved in `src/`, execute `./config-create [configuration file]` in the above mentioned directory.

An example is given in `config-creator/config.xml.example`.

## Libraries

- button
- output
- pwm
- tick (Will be executed every 1ms. Do not use variable names a, b and c.)
- code (Add your own function to the c file.)

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
