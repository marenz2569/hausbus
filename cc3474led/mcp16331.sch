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
Sheet 4 5
Title ""
Date "2017-06-12"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 4100 3320 0    60   Input ~ 0
V_IN
$Comp
L MCP16301 U1
U 1 1 593EC621
P 5440 3620
F 0 "U1" H 5140 4170 50  0000 L CNN
F 1 "MCP16331" H 5140 4070 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-23-6" H 5440 3120 50  0001 C CNN
F 3 "" H 5140 4170 50  0000 C CNN
	1    5440 3620
	1    0    0    -1  
$EndComp
$Comp
L C C8
U 1 1 593EC6E8
P 4910 3680
F 0 "C8" H 4935 3780 50  0000 L CNN
F 1 "100n" H 4935 3580 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 4948 3530 50  0001 C CNN
F 3 "" H 4910 3680 50  0000 C CNN
	1    4910 3680
	1    0    0    -1  
$EndComp
$Comp
L ZENER_Small D4
U 1 1 593EC8BA
P 4500 3420
F 0 "D4" H 4500 3520 50  0000 C CNN
F 1 "BZX84C 8V2" V 4340 3420 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23_Handsoldering" H 4500 3420 50  0001 C CNN
F 3 "" H 4500 3420 50  0000 C CNN
	1    4500 3420
	0    1    1    0   
$EndComp
$Comp
L R_Small R8
U 1 1 593ECA9F
P 4740 3800
F 0 "R8" V 4660 3760 50  0000 L CNN
F 1 "10k" V 4730 3740 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4740 3800 50  0001 C CNN
F 3 "" H 4740 3800 50  0000 C CNN
	1    4740 3800
	-1   0    0    1   
$EndComp
$Comp
L CP C7
U 1 1 593ECCAD
P 4260 3620
F 0 "C7" H 4285 3720 50  0000 L CNN
F 1 "100u" H 4285 3520 50  0000 L CNN
F 2 "Capacitors_SMD:CP_Elec_10x10.5" H 4298 3470 50  0001 C CNN
F 3 "" H 4260 3620 50  0000 C CNN
	1    4260 3620
	1    0    0    -1  
$EndComp
$Comp
L R_Small R7
U 1 1 593ECA36
P 4600 3520
F 0 "R7" V 4670 3490 50  0000 L CNN
F 1 "10k" V 4600 3460 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 4600 3520 50  0001 C CNN
F 3 "" H 4600 3520 50  0000 C CNN
	1    4600 3520
	0    1    1    0   
$EndComp
$Comp
L D_Schottky D5
U 1 1 593ED222
P 6040 3830
F 0 "D5" H 6040 3930 50  0000 C CNN
F 1 "SK86" H 6040 3730 50  0000 C CNN
F 2 "Diodes_SMD:D_SMC_Handsoldering" H 6040 3830 50  0001 C CNN
F 3 "" H 6040 3830 50  0000 C CNN
	1    6040 3830
	0    1    1    0   
$EndComp
$Comp
L C_Small C9
U 1 1 593ED3B8
P 6040 3290
F 0 "C9" H 6050 3360 50  0000 L CNN
F 1 "100n" H 6050 3210 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 6040 3290 50  0001 C CNN
F 3 "" H 6040 3290 50  0000 C CNN
	1    6040 3290
	-1   0    0    1   
$EndComp
$Comp
L D_Schottky_x2_ACom_KKA D6
U 1 1 593ED562
P 6790 3160
F 0 "D6" H 6840 3060 50  0000 C CNN
F 1 "BAS70-06" H 6790 3260 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-23_Handsoldering" H 6790 3160 50  0001 C CNN
F 3 "" H 6790 3160 50  0000 C CNN
	1    6790 3160
	1    0    0    -1  
$EndComp
$Comp
L INDUCTOR L2
U 1 1 593ED619
P 6370 3420
F 0 "L2" V 6320 3420 50  0000 C CNN
F 1 "L-PIS4728 33u" V 6470 3420 50  0000 C CNN
F 2 "Choke_SMD:Choke_SMD_Wuerth-WE-PD-Typ-LS_Handsoldering" H 6370 3420 50  0001 C CNN
F 3 "" H 6370 3420 50  0000 C CNN
	1    6370 3420
	0    1    1    0   
$EndComp
$Comp
L R_Small R_top1
U 1 1 593ED8D0
P 6790 3520
F 0 "R_top1" V 6860 3430 50  0000 L CNN
F 1 "43k" V 6790 3450 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 6790 3520 50  0001 C CNN
F 3 "" H 6790 3520 50  0000 C CNN
	1    6790 3520
	1    0    0    -1  
$EndComp
$Comp
L R_Small R_bot1
U 1 1 593ED9A2
P 6790 3720
F 0 "R_bot1" V 6860 3560 50  0000 L CNN
F 1 "8k2" V 6790 3650 50  0000 L CNN
F 2 "Resistors_SMD:R_0805_HandSoldering" H 6790 3720 50  0001 C CNN
F 3 "" H 6790 3720 50  0000 C CNN
	1    6790 3720
	1    0    0    -1  
$EndComp
$Comp
L C_Small C10
U 1 1 593EDA20
P 7030 3720
F 0 "C10" H 7040 3790 50  0000 L CNN
F 1 "n.b." H 7040 3640 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 7030 3720 50  0001 C CNN
F 3 "" H 7030 3720 50  0000 C CNN
	1    7030 3720
	1    0    0    -1  
$EndComp
$Comp
L CP C12
U 1 1 593EDEF1
P 7580 3720
F 0 "C12" H 7605 3820 50  0000 L CNN
F 1 "100u" H 7605 3620 50  0000 L CNN
F 2 "Capacitors_SMD:CP_Elec_10x10.5" H 7618 3570 50  0001 C CNN
F 3 "" H 7580 3720 50  0000 C CNN
	1    7580 3720
	1    0    0    -1  
$EndComp
$Comp
L C C11
U 1 1 593EE15C
P 7300 3720
F 0 "C11" H 7325 3820 50  0000 L CNN
F 1 "100n" H 7325 3620 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805_HandSoldering" H 7338 3570 50  0001 C CNN
F 3 "" H 7300 3720 50  0000 C CNN
	1    7300 3720
	1    0    0    -1  
$EndComp
Wire Wire Line
	4100 3320 5040 3320
Wire Wire Line
	4910 3320 4910 3530
Wire Wire Line
	4910 3830 4910 4030
Connection ~ 4910 3320
Connection ~ 4500 3320
Wire Wire Line
	4260 3470 4260 3320
Connection ~ 4260 3320
Wire Wire Line
	4260 3770 4260 4030
Wire Wire Line
	4740 3420 4740 3700
Wire Wire Line
	4740 3520 4700 3520
Wire Wire Line
	4740 3420 5040 3420
Connection ~ 4740 3520
Wire Wire Line
	4740 3900 4740 4030
Wire Wire Line
	5440 4020 5440 4030
Wire Wire Line
	6040 3980 6040 4030
Wire Wire Line
	6040 3390 6040 3680
Wire Wire Line
	5840 3420 6070 3420
Connection ~ 6040 3420
Wire Wire Line
	5840 3320 5840 3160
Wire Wire Line
	5840 3160 6490 3160
Wire Wire Line
	6040 3190 6040 3160
Connection ~ 6040 3160
Wire Wire Line
	6670 3420 7830 3420
Wire Wire Line
	6790 3420 6790 3360
Wire Wire Line
	5840 3620 7030 3620
Connection ~ 6790 3420
Connection ~ 6790 3620
Wire Wire Line
	6790 3820 6790 4030
Wire Wire Line
	7030 3820 7030 4030
Wire Wire Line
	7300 3570 7300 3420
Connection ~ 7300 3420
Wire Wire Line
	7580 3420 7580 3570
Wire Wire Line
	7300 3870 7300 4030
Wire Wire Line
	7580 3870 7580 4030
Text HLabel 7830 3420 2    60   Output ~ 0
V_OUT
Connection ~ 7580 3420
$Comp
L GND #PWR027
U 1 1 593EE975
P 6040 4030
F 0 "#PWR027" H 6040 3780 50  0001 C CNN
F 1 "GND" H 6040 3880 50  0000 C CNN
F 2 "" H 6040 4030 50  0000 C CNN
F 3 "" H 6040 4030 50  0000 C CNN
	1    6040 4030
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR028
U 1 1 593EE9B4
P 5440 4030
F 0 "#PWR028" H 5440 3780 50  0001 C CNN
F 1 "GND" H 5440 3880 50  0000 C CNN
F 2 "" H 5440 4030 50  0000 C CNN
F 3 "" H 5440 4030 50  0000 C CNN
	1    5440 4030
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR029
U 1 1 593EE9EC
P 4910 4030
F 0 "#PWR029" H 4910 3780 50  0001 C CNN
F 1 "GND" H 4910 3880 50  0000 C CNN
F 2 "" H 4910 4030 50  0000 C CNN
F 3 "" H 4910 4030 50  0000 C CNN
	1    4910 4030
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR030
U 1 1 593EEA6F
P 4740 4030
F 0 "#PWR030" H 4740 3780 50  0001 C CNN
F 1 "GND" H 4740 3880 50  0000 C CNN
F 2 "" H 4740 4030 50  0000 C CNN
F 3 "" H 4740 4030 50  0000 C CNN
	1    4740 4030
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR031
U 1 1 593EEAA7
P 4260 4030
F 0 "#PWR031" H 4260 3780 50  0001 C CNN
F 1 "GND" H 4260 3880 50  0000 C CNN
F 2 "" H 4260 4030 50  0000 C CNN
F 3 "" H 4260 4030 50  0000 C CNN
	1    4260 4030
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR032
U 1 1 593EEB75
P 6790 4030
F 0 "#PWR032" H 6790 3780 50  0001 C CNN
F 1 "GND" H 6790 3880 50  0000 C CNN
F 2 "" H 6790 4030 50  0000 C CNN
F 3 "" H 6790 4030 50  0000 C CNN
	1    6790 4030
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR033
U 1 1 593EEBAD
P 7030 4030
F 0 "#PWR033" H 7030 3780 50  0001 C CNN
F 1 "GND" H 7030 3880 50  0000 C CNN
F 2 "" H 7030 4030 50  0000 C CNN
F 3 "" H 7030 4030 50  0000 C CNN
	1    7030 4030
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR034
U 1 1 593EEC3F
P 7300 4030
F 0 "#PWR034" H 7300 3780 50  0001 C CNN
F 1 "GND" H 7300 3880 50  0000 C CNN
F 2 "" H 7300 4030 50  0000 C CNN
F 3 "" H 7300 4030 50  0000 C CNN
	1    7300 4030
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR035
U 1 1 593EEC77
P 7580 4030
F 0 "#PWR035" H 7580 3780 50  0001 C CNN
F 1 "GND" H 7580 3880 50  0000 C CNN
F 2 "" H 7580 4030 50  0000 C CNN
F 3 "" H 7580 4030 50  0000 C CNN
	1    7580 4030
	1    0    0    -1  
$EndComp
Text Notes 6960 3330 0    60   ~ 0
V_OUT = 0.8V(R_top1/R_bot1 + 1)
$EndSCHEMATC