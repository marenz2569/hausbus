EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Hausbus Breakout"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCP2515-I/ST U1
U 1 1 581E1B66
P 1890 1700
F 0 "U1" H 1490 2475 50  0000 R CNN
F 1 "MCP2515-I/ST" H 2640 2500 50  0000 R TNN
F 2 "Housings_SSOP:TSSOP-20_4.4x6.5mm_Pitch0.65mm" H 1890 800 50  0001 C CIN
F 3 "" H 1990 900 50  0000 C CNN
	1    1890 1700
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR1
U 1 1 581E1CC9
P 1890 900
F 0 "#PWR1" H 1890 750 50  0001 C CNN
F 1 "+5V" H 1890 1040 50  0000 C CNN
F 2 "" H 1890 900 50  0000 C CNN
F 3 "" H 1890 900 50  0000 C CNN
	1    1890 900 
	1    0    0    -1  
$EndComp
Text GLabel 1290 1100 0    60   Input ~ 0
MOSI
Text GLabel 1290 1200 0    60   Output ~ 0
MISO
Text GLabel 1290 1300 0    60   Input ~ 0
SS
Text GLabel 1290 1400 0    60   Input ~ 0
SCK
Text GLabel 1290 2000 0    60   Input ~ 0
CLKO
$Comp
L GND #PWR2
U 1 1 581E1E0A
P 1890 2500
F 0 "#PWR2" H 1890 2250 50  0001 C CNN
F 1 "GND" H 1890 2350 50  0000 C CNN
F 2 "" H 1890 2500 50  0000 C CNN
F 3 "" H 1890 2500 50  0000 C CNN
	1    1890 2500
	1    0    0    -1  
$EndComp
Text GLabel 2490 1700 2    60   Output ~ 0
INT0
$Comp
L PCA82C251 U2
U 1 1 581E8CFE
P 4450 1600
F 0 "U2" H 4250 2150 50  0000 L CNN
F 1 "PCA82C251" H 4250 2050 50  0000 L CNN
F 2 "Housings_SOIC:SOIC-8_3.9x4.9mm_Pitch1.27mm" H 4450 1550 50  0001 C CNN
F 3 "" H 4450 1550 50  0000 C CNN
	1    4450 1600
	1    0    0    -1  
$EndComp
Text GLabel 2490 1200 2    60   BiDi ~ 0
TXD
Text GLabel 2490 1100 2    60   BiDi ~ 0
RXD
Text GLabel 4050 1500 0    60   BiDi ~ 0
TXD
Text GLabel 4050 1900 0    60   BiDi ~ 0
RXD
$Comp
L GND #PWR12
U 1 1 581E917E
P 4850 1900
F 0 "#PWR12" H 4850 1650 50  0001 C CNN
F 1 "GND" H 4850 1750 50  0000 C CNN
F 2 "" H 4850 1900 50  0000 C CNN
F 3 "" H 4850 1900 50  0000 C CNN
	1    4850 1900
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR8
U 1 1 581E91AB
P 4050 1300
F 0 "#PWR8" H 4050 1150 50  0001 C CNN
F 1 "+5V" H 4050 1440 50  0000 C CNN
F 2 "" H 4050 1300 50  0000 C CNN
F 3 "" H 4050 1300 50  0000 C CNN
	1    4050 1300
	0    -1   -1   0   
$EndComp
$Comp
L C C1
U 1 1 581F411E
P 10790 5850
F 0 "C1" H 10815 5950 50  0000 L CNN
F 1 "100nF" H 10815 5750 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 10828 5700 50  0001 C CNN
F 3 "" H 10790 5850 50  0000 C CNN
	1    10790 5850
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR20
U 1 1 581F428F
P 10790 5700
F 0 "#PWR20" H 10790 5550 50  0001 C CNN
F 1 "+5V" H 10790 5840 50  0000 C CNN
F 2 "" H 10790 5700 50  0000 C CNN
F 3 "" H 10790 5700 50  0000 C CNN
	1    10790 5700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR21
U 1 1 581F42AF
P 10790 6000
F 0 "#PWR21" H 10790 5750 50  0001 C CNN
F 1 "GND" H 10790 5850 50  0000 C CNN
F 2 "" H 10790 6000 50  0000 C CNN
F 3 "" H 10790 6000 50  0000 C CNN
	1    10790 6000
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 581F482B
P 10390 5850
F 0 "C2" H 10415 5950 50  0000 L CNN
F 1 "100nF" H 10415 5750 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 10428 5700 50  0001 C CNN
F 3 "" H 10390 5850 50  0000 C CNN
	1    10390 5850
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR16
U 1 1 581F4832
P 10390 5700
F 0 "#PWR16" H 10390 5550 50  0001 C CNN
F 1 "+5V" H 10390 5840 50  0000 C CNN
F 2 "" H 10390 5700 50  0000 C CNN
F 3 "" H 10390 5700 50  0000 C CNN
	1    10390 5700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR17
U 1 1 581F4838
P 10390 6000
F 0 "#PWR17" H 10390 5750 50  0001 C CNN
F 1 "GND" H 10390 5850 50  0000 C CNN
F 2 "" H 10390 6000 50  0000 C CNN
F 3 "" H 10390 6000 50  0000 C CNN
	1    10390 6000
	1    0    0    -1  
$EndComp
Text GLabel 4850 1600 2    60   BiDi ~ 0
CANLOW
Text GLabel 4850 1500 2    60   BiDi ~ 0
CANHIGH
$Comp
L GND #PWR19
U 1 1 5820DE03
P 10460 4950
F 0 "#PWR19" H 10460 4700 50  0001 C CNN
F 1 "GND" H 10460 4800 50  0000 C CNN
F 2 "" H 10460 4950 50  0000 C CNN
F 3 "" H 10460 4950 50  0000 C CNN
	1    10460 4950
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR18
U 1 1 5820DE6F
P 10460 4850
F 0 "#PWR18" H 10460 4700 50  0001 C CNN
F 1 "+5V" H 10460 4990 50  0000 C CNN
F 2 "" H 10460 4850 50  0000 C CNN
F 3 "" H 10460 4850 50  0000 C CNN
	1    10460 4850
	0    -1   -1   0   
$EndComp
Text GLabel 9630 4950 0    60   BiDi ~ 0
CANLOW
Text GLabel 9630 4850 0    60   BiDi ~ 0
CANHIGH
$Comp
L R R1
U 1 1 5820F03F
P 10040 4160
F 0 "R1" V 10120 4160 50  0000 C CNN
F 1 "120R" V 10040 4160 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 9970 4160 50  0001 C CNN
F 3 "" H 10040 4160 50  0000 C CNN
	1    10040 4160
	0    1    1    0   
$EndComp
Text GLabel 9890 4160 0    60   BiDi ~ 0
CANHIGH
Text GLabel 10190 4160 2    60   BiDi ~ 0
CANLOW
Text GLabel 4010 3950 2    60   Input ~ 0
MISO
Text GLabel 4010 3850 2    60   Output ~ 0
MOSI
Text GLabel 4010 4050 2    60   Output ~ 0
SCK
Text GLabel 4010 3750 2    60   Output ~ 0
SS
Text GLabel 4010 3550 2    60   Output ~ 0
CLKO
Text GLabel 4010 4150 2    60   Input ~ 0
OSC1
Text GLabel 4010 4250 2    60   Input ~ 0
OSC2
Text GLabel 9140 5640 0    60   Input ~ 0
OSC1
Text GLabel 9440 5640 2    60   Input ~ 0
OSC2
$Comp
L GND #PWR15
U 1 1 5826628A
P 9300 5940
F 0 "#PWR15" H 9300 5690 50  0001 C CNN
F 1 "GND" H 9300 5790 50  0000 C CNN
F 2 "" H 9300 5940 50  0000 C CNN
F 3 "" H 9300 5940 50  0000 C CNN
	1    9300 5940
	1    0    0    -1  
$EndComp
$Comp
L CRYSTAL Y1
U 1 1 582662B2
P 9290 5640
F 0 "Y1" H 9290 5790 50  0000 C CNN
F 1 "16MHz" H 9290 5490 50  0000 C CNN
F 2 "Crystals:Crystal_HC49-U_Vertical" H 9290 5640 50  0001 C CNN
F 3 "" H 9290 5640 50  0000 C CNN
	1    9290 5640
	1    0    0    -1  
$EndComp
$Comp
L C C4
U 1 1 582663C3
P 9440 5790
F 0 "C4" H 9465 5890 50  0000 L CNN
F 1 "22pF" H 9465 5690 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 9478 5640 50  0001 C CNN
F 3 "" H 9440 5790 50  0000 C CNN
	1    9440 5790
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 5826644C
P 9140 5790
F 0 "C3" H 9165 5890 50  0000 L CNN
F 1 "22pF" H 9165 5690 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 9178 5640 50  0001 C CNN
F 3 "" H 9140 5790 50  0000 C CNN
	1    9140 5790
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR5
U 1 1 58266FD2
P 2110 5850
F 0 "#PWR5" H 2110 5600 50  0001 C CNN
F 1 "GND" H 2110 5700 50  0000 C CNN
F 2 "" H 2110 5850 50  0000 C CNN
F 3 "" H 2110 5850 50  0000 C CNN
	1    2110 5850
	1    0    0    -1  
$EndComp
Text GLabel 4010 5350 2    60   Input ~ 0
INT0
$Comp
L +5V #PWR3
U 1 1 582674C7
P 2110 3850
F 0 "#PWR3" H 2110 3700 50  0001 C CNN
F 1 "+5V" H 2110 3990 50  0000 C CNN
F 2 "" H 2110 3850 50  0000 C CNN
F 3 "" H 2110 3850 50  0000 C CNN
	1    2110 3850
	-1   0    0    1   
$EndComp
$Comp
L ATMEGA328P-M IC1
U 1 1 58267C26
P 3010 4650
F 0 "IC1" H 2260 5900 50  0000 L BNN
F 1 "ATMEGA328P-M" H 3410 3250 50  0000 L BNN
F 2 "Housings_QFP:TQFP-32_7x7mm_Pitch0.8mm" H 3010 4650 50  0000 C CIN
F 3 "" H 3010 4650 50  0000 C CNN
	1    3010 4650
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X02 P4
U 1 1 591C3417
P 10660 4900
F 0 "P4" H 10660 5050 50  0000 C CNN
F 1 "CONN_01X02" V 10760 4900 50  0000 C CNN
F 2 "RND_Connectors:2_5.08mm" H 10660 4900 50  0001 C CNN
F 3 "" H 10660 4900 50  0000 C CNN
	1    10660 4900
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X02 P3
U 1 1 591C34A6
P 9830 4900
F 0 "P3" H 9830 5050 50  0000 C CNN
F 1 "CONN_01X02" V 9930 4900 50  0000 C CNN
F 2 "RND_Connectors:2_5.08mm" H 9830 4900 50  0001 C CNN
F 3 "" H 9830 4900 50  0000 C CNN
	1    9830 4900
	1    0    0    -1  
$EndComp
$Comp
L C C5
U 1 1 591C4004
P 2110 4300
F 0 "C5" H 2135 4400 50  0000 L CNN
F 1 "100n" H 2135 4200 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 2148 4150 50  0001 C CNN
F 3 "" H 2110 4300 50  0000 C CNN
	1    2110 4300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR4
U 1 1 591C40A9
P 2110 4450
F 0 "#PWR4" H 2110 4200 50  0001 C CNN
F 1 "GND" H 2110 4300 50  0000 C CNN
F 2 "" H 2110 4450 50  0000 C CNN
F 3 "" H 2110 4450 50  0000 C CNN
	1    2110 4450
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 591C4DB5
P 4160 5000
F 0 "R2" V 4240 5000 50  0000 C CNN
F 1 "10k" V 4160 5000 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 4090 5000 50  0001 C CNN
F 3 "" H 4160 5000 50  0000 C CNN
	1    4160 5000
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR9
U 1 1 591C4FD5
P 4310 5000
F 0 "#PWR9" H 4310 4850 50  0001 C CNN
F 1 "+5V" H 4310 5140 50  0000 C CNN
F 2 "" H 4310 5000 50  0000 C CNN
F 3 "" H 4310 5000 50  0000 C CNN
	1    4310 5000
	0    1    1    0   
$EndComp
$Comp
L CONN_01X10 P1
U 1 1 591C6108
P 4720 5500
F 0 "P1" H 4720 6050 50  0000 C CNN
F 1 "CONN_01X10" V 4820 5500 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x10_Pitch2.54mm" H 4720 5500 50  0001 C CNN
F 3 "" H 4720 5500 50  0000 C CNN
	1    4720 5500
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR11
U 1 1 591C6871
P 4520 5550
F 0 "#PWR11" H 4520 5400 50  0001 C CNN
F 1 "+5V" H 4520 5690 50  0000 C CNN
F 2 "" H 4520 5550 50  0000 C CNN
F 3 "" H 4520 5550 50  0000 C CNN
	1    4520 5550
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR10
U 1 1 591C690A
P 4520 5450
F 0 "#PWR10" H 4520 5200 50  0001 C CNN
F 1 "GND" H 4520 5300 50  0000 C CNN
F 2 "" H 4520 5450 50  0000 C CNN
F 3 "" H 4520 5450 50  0000 C CNN
	1    4520 5450
	0    1    1    0   
$EndComp
Wire Wire Line
	9140 5940 9440 5940
Connection ~ 9300 5940
Wire Wire Line
	2110 5650 2110 5850
Connection ~ 2110 5850
Wire Wire Line
	2110 3550 2110 3850
Connection ~ 2110 3850
Connection ~ 2110 3650
Connection ~ 2110 5750
Wire Wire Line
	4010 5850 4520 5850
Wire Wire Line
	4520 5750 4010 5750
Wire Wire Line
	4010 5650 4520 5650
Wire Wire Line
	4010 5550 4310 5550
Wire Wire Line
	4310 5550 4310 5350
Wire Wire Line
	4310 5350 4520 5350
Wire Wire Line
	4010 5450 4280 5450
Wire Wire Line
	4280 5450 4280 5250
Wire Wire Line
	4280 5250 4520 5250
Wire Wire Line
	4010 5250 4250 5250
Wire Wire Line
	4250 5250 4250 5150
Wire Wire Line
	4250 5150 4520 5150
Wire Wire Line
	4010 5150 4220 5150
Wire Wire Line
	4220 5150 4220 5050
Wire Wire Line
	4220 5050 4520 5050
Wire Wire Line
	4010 3650 4870 3650
Wire Wire Line
	4870 3650 4870 6070
Wire Wire Line
	4870 6070 4450 6070
Wire Wire Line
	4450 6070 4450 5950
Wire Wire Line
	4450 5950 4520 5950
$Comp
L CONN_01X10 P2
U 1 1 591C5ACA
P 5290 4450
F 0 "P2" H 5290 5000 50  0000 C CNN
F 1 "CONN_01X10" V 5390 4450 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x10_Pitch2.54mm" H 5290 4450 50  0001 C CNN
F 3 "" H 5290 4450 50  0000 C CNN
	1    5290 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4010 4900 5090 4900
Wire Wire Line
	5090 4800 4010 4800
Wire Wire Line
	4010 4700 5090 4700
Wire Wire Line
	5090 4600 4010 4600
Wire Wire Line
	4010 4500 4770 4500
Wire Wire Line
	4770 4500 4770 4300
Wire Wire Line
	4770 4300 5090 4300
Wire Wire Line
	4010 4400 4720 4400
Wire Wire Line
	4720 4400 4720 4200
Wire Wire Line
	4720 4200 5090 4200
$Comp
L GND #PWR14
U 1 1 591C6288
P 5090 4500
F 0 "#PWR14" H 5090 4250 50  0001 C CNN
F 1 "GND" H 5090 4350 50  0000 C CNN
F 2 "" H 5090 4500 50  0000 C CNN
F 3 "" H 5090 4500 50  0000 C CNN
	1    5090 4500
	0    1    1    0   
$EndComp
$Comp
L +5V #PWR13
U 1 1 591C62C0
P 5090 4400
F 0 "#PWR13" H 5090 4250 50  0001 C CNN
F 1 "+5V" H 5090 4540 50  0000 C CNN
F 2 "" H 5090 4400 50  0000 C CNN
F 3 "" H 5090 4400 50  0000 C CNN
	1    5090 4400
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2110 5000 1950 5000
Wire Wire Line
	1950 5000 1950 3280
Wire Wire Line
	1950 3280 4900 3280
Wire Wire Line
	4900 3280 4900 4100
Wire Wire Line
	4900 4100 5090 4100
Wire Wire Line
	5090 4000 4950 4000
Wire Wire Line
	4950 4000 4950 3230
Wire Wire Line
	4950 3230 1900 3230
Wire Wire Line
	1900 3230 1900 4900
Wire Wire Line
	1900 4900 2110 4900
$Comp
L R R3
U 1 1 591C7DA3
P 2640 2300
F 0 "R3" V 2720 2300 50  0000 C CNN
F 1 "10k" V 2640 2300 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 2570 2300 50  0001 C CNN
F 3 "" H 2640 2300 50  0000 C CNN
	1    2640 2300
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR6
U 1 1 591C7DA9
P 2790 2300
F 0 "#PWR6" H 2790 2150 50  0001 C CNN
F 1 "+5V" H 2790 2440 50  0000 C CNN
F 2 "" H 2790 2300 50  0000 C CNN
F 3 "" H 2790 2300 50  0000 C CNN
	1    2790 2300
	0    1    1    0   
$EndComp
$Comp
L R R4
U 1 1 591C81EE
P 3900 1700
F 0 "R4" V 3980 1700 50  0000 C CNN
F 1 "68k" V 3900 1700 50  0000 C CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" V 3830 1700 50  0001 C CNN
F 3 "" H 3900 1700 50  0000 C CNN
	1    3900 1700
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR7
U 1 1 591C8328
P 3750 1700
F 0 "#PWR7" H 3750 1450 50  0001 C CNN
F 1 "GND" H 3750 1550 50  0000 C CNN
F 2 "" H 3750 1700 50  0000 C CNN
F 3 "" H 3750 1700 50  0000 C CNN
	1    3750 1700
	0    1    1    0   
$EndComp
$EndSCHEMATC