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
Sheet 3 5
Title ""
Date "2017-06-12"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 5380 3660 0    60   Input ~ 0
V_IN
Text HLabel 6240 3660 2    60   Output ~ 0
V_OUT
$Comp
L TVS D2
U 1 1 593E5F71
P 5670 3960
F 0 "D2" H 5670 4110 50  0000 C CNN
F 1 "P6SMB30CA" H 5670 3810 50  0000 C CNN
F 2 "Diodes_SMD:D_SMB_Handsoldering" H 5670 3960 50  0001 C CNN
F 3 "" H 5670 3960 50  0000 C CNN
	1    5670 3960
	0    -1   -1   0   
$EndComp
$Comp
L D_Schottky D3
U 1 1 593E607E
P 5970 3660
F 0 "D3" H 5970 3760 50  0000 C CNN
F 1 "SK86" H 5970 3560 50  0000 C CNN
F 2 "Diodes_SMD:D_SMC_Handsoldering" H 5970 3660 50  0001 C CNN
F 3 "" H 5970 3660 50  0000 C CNN
	1    5970 3660
	-1   0    0    1   
$EndComp
Wire Wire Line
	5820 3660 5380 3660
Wire Wire Line
	6120 3660 6240 3660
$Comp
L GND #PWR026
U 1 1 593E615B
P 5670 4260
F 0 "#PWR026" H 5670 4010 50  0001 C CNN
F 1 "GND" H 5670 4110 50  0000 C CNN
F 2 "" H 5670 4260 50  0000 C CNN
F 3 "" H 5670 4260 50  0000 C CNN
	1    5670 4260
	1    0    0    -1  
$EndComp
Connection ~ 5670 3660
$EndSCHEMATC
