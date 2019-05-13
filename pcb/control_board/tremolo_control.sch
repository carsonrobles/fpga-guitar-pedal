EESchema Schematic File Version 4
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 6
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
L Device:R R?
U 1 1 5CC2106D
P 1750 1950
F 0 "R?" H 1820 1996 50  0000 L CNN
F 1 "R" H 1820 1905 50  0000 L CNN
F 2 "" V 1680 1950 50  0001 C CNN
F 3 "~" H 1750 1950 50  0001 C CNN
	1    1750 1950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5CC28E41
P 2050 2200
F 0 "#PWR?" H 2050 1950 50  0001 C CNN
F 1 "GND" H 2055 2027 50  0000 C CNN
F 2 "" H 2050 2200 50  0001 C CNN
F 3 "" H 2050 2200 50  0001 C CNN
	1    2050 2200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5CC28E42
P 1750 2200
F 0 "#PWR?" H 1750 1950 50  0001 C CNN
F 1 "GND" H 1755 2027 50  0000 C CNN
F 2 "" H 1750 2200 50  0001 C CNN
F 3 "" H 1750 2200 50  0001 C CNN
	1    1750 2200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5CC287FA
P 5450 1700
F 0 "#PWR?" H 5450 1450 50  0001 C CNN
F 1 "GND" H 5455 1527 50  0000 C CNN
F 2 "" H 5450 1700 50  0001 C CNN
F 3 "" H 5450 1700 50  0001 C CNN
	1    5450 1700
	1    0    0    -1  
$EndComp
$Comp
L Device:R_POT RV?
U 1 1 5CC28339
P 5450 1450
F 0 "RV?" H 5380 1496 50  0000 R CNN
F 1 "R_POT" H 5380 1405 50  0000 R CNN
F 2 "" H 5450 1450 50  0001 C CNN
F 3 "~" H 5450 1450 50  0001 C CNN
	1    5450 1450
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW?
U 1 1 5CC287FC
P 1450 1300
F 0 "SW?" H 1450 1585 50  0000 C CNN
F 1 "SW_Push" H 1450 1494 50  0000 C CNN
F 2 "" H 1450 1500 50  0001 C CNN
F 3 "" H 1450 1500 50  0001 C CNN
	1    1450 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 1200 5450 1300
Wire Wire Line
	5450 1600 5450 1700
Wire Wire Line
	5700 1450 5600 1450
Wire Wire Line
	1150 1200 1150 1300
Wire Wire Line
	1150 1300 1250 1300
Wire Wire Line
	1750 2100 1750 2200
$Comp
L Device:LED D?
U 1 1 5CC287FD
P 2050 1550
F 0 "D?" V 2088 1433 50  0000 R CNN
F 1 "LED" V 1997 1433 50  0000 R CNN
F 2 "" H 2050 1550 50  0001 C CNN
F 3 "~" H 2050 1550 50  0001 C CNN
	1    2050 1550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2050 1300 2050 1400
Wire Wire Line
	2050 1800 2050 1700
Wire Wire Line
	2050 1300 2150 1300
Connection ~ 2050 1300
$Comp
L Device:R_POT RV?
U 1 1 5CC287FE
P 3800 1450
F 0 "RV?" H 3730 1496 50  0000 R CNN
F 1 "R_POT" H 3730 1405 50  0000 R CNN
F 2 "" H 3800 1450 50  0001 C CNN
F 3 "~" H 3800 1450 50  0001 C CNN
	1    3800 1450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5CC287FF
P 3800 1700
F 0 "#PWR?" H 3800 1450 50  0001 C CNN
F 1 "GND" H 3805 1527 50  0000 C CNN
F 2 "" H 3800 1700 50  0001 C CNN
F 3 "" H 3800 1700 50  0001 C CNN
	1    3800 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3800 1700 3800 1600
Wire Wire Line
	3800 1300 3800 1200
Wire Wire Line
	4050 1450 3950 1450
$Comp
L Device:R R?
U 1 1 5CC28800
P 2050 1950
F 0 "R?" H 2120 1996 50  0000 L CNN
F 1 "R" H 2120 1905 50  0000 L CNN
F 2 "" V 1980 1950 50  0001 C CNN
F 3 "~" H 2050 1950 50  0001 C CNN
	1    2050 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 2100 2050 2200
Wire Wire Line
	1650 1300 1750 1300
Wire Wire Line
	1750 1800 1750 1300
Connection ~ 1750 1300
Wire Wire Line
	1750 1300 2050 1300
Text HLabel 5700 1450 2    50   Output ~ 0
tremolo_speed
Text HLabel 4050 1450 2    50   Output ~ 0
tremolo_intensity
Text HLabel 2150 1300 2    50   Output ~ 0
tremolo_en
Text GLabel 1150 1200 1    50   Input ~ 0
5V
Text GLabel 3800 1200 1    50   Input ~ 0
5V
Text GLabel 5450 1200 1    50   Input ~ 0
5V
$EndSCHEMATC
