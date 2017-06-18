EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:dc-dc
LIBS:transistors
LIBS:lt3473
LIBS:conn
LIBS:cc3473led-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 5
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CONN_01X10 P3
U 1 1 5945E77A
P 5290 3990
F 0 "P3" H 5290 4540 50  0000 C CNN
F 1 "CONN_01X10" V 5390 3990 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x10_Pitch2.54mm" H 5290 3990 50  0001 C CNN
F 3 "" H 5290 3990 50  0000 C CNN
	1    5290 3990
	-1   0    0    1   
$EndComp
$Comp
L CONN_01X10 P4
U 1 1 5945E892
P 6370 3990
F 0 "P4" H 6370 4540 50  0000 C CNN
F 1 "CONN_01X10" V 6470 3990 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x10_Pitch2.54mm" H 6370 3990 50  0001 C CNN
F 3 "" H 6370 3990 50  0000 C CNN
	1    6370 3990
	1    0    0    -1  
$EndComp
Text HLabel 5490 3540 2    60   BiDi ~ 0
B2
Text HLabel 5490 3640 2    60   BiDi ~ 0
B1
Text HLabel 5490 3740 2    60   BiDi ~ 0
D6
Text HLabel 5490 3840 2    60   BiDi ~ 0
D5
Text HLabel 5490 4140 2    60   BiDi ~ 0
D4
Text HLabel 5490 4240 2    60   BiDi ~ 0
D3
Text HLabel 5490 4340 2    60   BiDi ~ 0
D1
Text HLabel 5490 4440 2    60   BiDi ~ 0
D0
Text HLabel 6170 3540 0    60   BiDi ~ 0
ADC6
Text HLabel 6170 3640 0    60   BiDi ~ 0
ADC7
Text HLabel 6170 3740 0    60   BiDi ~ 0
C0
Text HLabel 6170 3840 0    60   BiDi ~ 0
C1
Text HLabel 6170 4140 0    60   BiDi ~ 0
C2
Text HLabel 6170 4240 0    60   BiDi ~ 0
C3
Text HLabel 6170 4340 0    60   BiDi ~ 0
C4
Text HLabel 6170 4440 0    60   BiDi ~ 0
C5
Text HLabel 6170 3940 0    60   Input ~ 0
5V
$Comp
L GND #PWR036
U 1 1 5945EE7D
P 5940 4590
F 0 "#PWR036" H 5940 4340 50  0001 C CNN
F 1 "GND" H 5940 4440 50  0000 C CNN
F 2 "" H 5940 4590 50  0000 C CNN
F 3 "" H 5940 4590 50  0000 C CNN
	1    5940 4590
	1    0    0    -1  
$EndComp
Text HLabel 5490 3940 2    60   Input ~ 0
5V
$Comp
L GND #PWR037
U 1 1 5945EFD5
P 5720 4590
F 0 "#PWR037" H 5720 4340 50  0001 C CNN
F 1 "GND" H 5720 4440 50  0000 C CNN
F 2 "" H 5720 4590 50  0000 C CNN
F 3 "" H 5720 4590 50  0000 C CNN
	1    5720 4590
	1    0    0    -1  
$EndComp
Wire Wire Line
	5490 4040 5720 4040
Wire Wire Line
	5720 4040 5720 4590
Wire Wire Line
	6170 4040 5940 4040
Wire Wire Line
	5940 4040 5940 4590
$Comp
L GND #PWR038
U 1 1 5946F6C8
P 6820 4590
F 0 "#PWR038" H 6820 4340 50  0001 C CNN
F 1 "GND" H 6820 4440 50  0000 C CNN
F 2 "" H 6820 4590 50  0000 C CNN
F 3 "" H 6820 4590 50  0000 C CNN
	1    6820 4590
	1    0    0    -1  
$EndComp
Wire Wire Line
	6820 4590 6820 4090
$Comp
L CP C13
U 1 1 5946F6FB
P 6820 3940
F 0 "C13" H 6845 4040 50  0000 L CNN
F 1 "10u" H 6845 3840 50  0000 L CNN
F 2 "Capacitors_Tantalum_SMD:CP_Tantalum_Case-A_EIA-3216-18_Reflow" H 6858 3790 50  0001 C CNN
F 3 "" H 6820 3940 50  0000 C CNN
	1    6820 3940
	1    0    0    -1  
$EndComp
Text HLabel 6680 3310 0    60   Input ~ 0
5V
Wire Wire Line
	6680 3310 6820 3310
Wire Wire Line
	6820 3310 6820 3790
$EndSCHEMATC
