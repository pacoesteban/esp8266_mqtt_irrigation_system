EESchema Schematic File Version 2
LIBS:esp8266_irrigation_system-rescue
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
LIBS:various
LIBS:esp8266_irrigation_system-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
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
L GND #PWR01
U 1 1 580E06AE
P 5150 4350
F 0 "#PWR01" H 5150 4100 50  0001 C CNN
F 1 "GND" H 5150 4200 50  0000 C CNN
F 2 "" H 5150 4350 50  0000 C CNN
F 3 "" H 5150 4350 50  0000 C CNN
	1    5150 4350
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 580E06C4
P 5150 3850
F 0 "C2" H 5175 3950 50  0000 L CNN
F 1 "100n" H 5175 3750 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 5188 3700 50  0001 C CNN
F 3 "" H 5150 3850 50  0000 C CNN
	1    5150 3850
	1    0    0    -1  
$EndComp
NoConn ~ 6200 4050
NoConn ~ 6100 4050
NoConn ~ 6000 4050
NoConn ~ 5800 4050
NoConn ~ 5700 4050
NoConn ~ 5600 4050
Text GLabel 4250 3450 0    60   Input ~ 0
3.3V
Wire Wire Line
	4250 3450 5300 3450
Wire Wire Line
	5150 3700 5150 3450
Connection ~ 5150 3450
Wire Wire Line
	5150 4000 5150 4350
Wire Wire Line
	6500 3450 6650 3450
Wire Wire Line
	6650 3450 6650 4200
Wire Wire Line
	6650 4200 5150 4200
Connection ~ 5150 4200
$Comp
L R R4
U 1 1 580E07D5
P 5000 2750
F 0 "R4" V 5080 2750 50  0000 C CNN
F 1 "10k" V 5000 2750 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 4930 2750 50  0001 C CNN
F 3 "" H 5000 2750 50  0000 C CNN
	1    5000 2750
	0    1    1    0   
$EndComp
$Comp
L R R5
U 1 1 580E081C
P 5000 2950
F 0 "R5" V 5080 2950 50  0000 C CNN
F 1 "10k" V 5000 2950 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 4930 2950 50  0001 C CNN
F 3 "" H 5000 2950 50  0000 C CNN
	1    5000 2950
	0    1    1    0   
$EndComp
Wire Wire Line
	5150 2750 5300 2750
Wire Wire Line
	5150 2950 5300 2950
Wire Wire Line
	4850 2950 4800 2950
Wire Wire Line
	4800 2950 4800 3450
Connection ~ 4800 3450
Wire Wire Line
	4850 2750 4750 2750
Wire Wire Line
	4750 2750 4750 3450
Connection ~ 4750 3450
$Comp
L ESP8266-12F U2
U 1 1 580E07B5
P 5900 3200
F 0 "U2" H 6400 2750 60  0000 C CNN
F 1 "ESP8266-12F" H 5900 3800 60  0000 C CNN
F 2 "More:ESP8266-12F" H 5900 3200 60  0001 C CNN
F 3 "" H 5900 3200 60  0000 C CNN
	1    5900 3200
	1    0    0    -1  
$EndComp
$Comp
L R R7
U 1 1 580E07E0
P 6850 3150
F 0 "R7" V 6930 3150 50  0000 C CNN
F 1 "10k" V 6850 3150 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 6780 3150 50  0001 C CNN
F 3 "" H 6850 3150 50  0000 C CNN
	1    6850 3150
	0    1    1    0   
$EndComp
$Comp
L R R6
U 1 1 580E0837
P 6750 3350
F 0 "R6" V 6830 3350 50  0000 C CNN
F 1 "10k" V 6750 3350 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 6680 3350 50  0001 C CNN
F 3 "" H 6750 3350 50  0000 C CNN
	1    6750 3350
	0    1    1    0   
$EndComp
Wire Wire Line
	6500 3350 6600 3350
Wire Wire Line
	6900 3350 7000 3350
Wire Wire Line
	7000 3350 7000 3600
Wire Wire Line
	7000 3600 6650 3600
Connection ~ 6650 3600
Wire Wire Line
	7050 3150 7050 4650
Wire Wire Line
	7050 4650 4850 4650
Wire Wire Line
	4850 4650 4850 3450
Connection ~ 4850 3450
Text GLabel 6800 2750 2    39   Input ~ 0
RX
Text GLabel 6800 2850 2    39   Input ~ 0
TX
Wire Wire Line
	6500 2750 6800 2750
Wire Wire Line
	6500 2850 6800 2850
$Comp
L CONN_02X03 P2
U 1 1 580E0A01
P 8900 2200
F 0 "P2" H 8900 2400 50  0000 C CNN
F 1 "Serial" H 8900 2000 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x03_Pitch2.54mm" H 8900 1000 50  0001 C CNN
F 3 "" H 8900 1000 50  0000 C CNN
	1    8900 2200
	1    0    0    -1  
$EndComp
Text GLabel 5100 2550 0    60   Input ~ 0
RST
Wire Wire Line
	5100 2550 5200 2550
Wire Wire Line
	5200 2550 5200 2750
Connection ~ 5200 2750
Text GLabel 7200 3050 2    60   Input ~ 0
DTR
Text GLabel 8400 2100 0    60   Input ~ 0
RST
Text GLabel 9400 2100 2    60   Input ~ 0
DTR
Text GLabel 9450 2250 2    60   Input ~ 0
TX
Text GLabel 9450 2400 2    60   Input ~ 0
RX
$Comp
L GND #PWR02
U 1 1 580E0B11
P 8550 2450
F 0 "#PWR02" H 8550 2200 50  0001 C CNN
F 1 "GND" H 8550 2300 50  0000 C CNN
F 2 "" H 8550 2450 50  0000 C CNN
F 3 "" H 8550 2450 50  0000 C CNN
	1    8550 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7000 3150 7050 3150
Wire Wire Line
	6700 3150 6500 3150
Wire Wire Line
	7200 3050 6650 3050
Wire Wire Line
	6650 3050 6650 3150
Connection ~ 6650 3150
Text GLabel 6900 2950 2    47   Input ~ 0
DHT22
Text GLabel 5150 3250 0    31   Input ~ 0
INFO_LED
Text GLabel 5150 3150 0    31   Input ~ 0
WATER_VALVE
Wire Wire Line
	6500 3050 6550 3050
Wire Wire Line
	6550 3050 6550 3000
Wire Wire Line
	6550 3000 6850 3000
Wire Wire Line
	6850 3000 6850 2950
Wire Wire Line
	6850 2950 6900 2950
NoConn ~ 6500 2950
NoConn ~ 6500 3250
NoConn ~ 5300 3050
Text GLabel 4650 3300 0    39   Input ~ 0
MOISTURE_SENSOR
$Comp
L MIC39100-3.3WS U1
U 1 1 580E12F0
P 3850 1400
F 0 "U1" H 3850 950 60  0000 C CNN
F 1 "MIC39100-3.3WS" H 3850 1750 60  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-223" H 3850 1400 60  0001 C CNN
F 3 "" H 3850 1400 60  0000 C CNN
	1    3850 1400
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X02 P1
U 1 1 580E13A1
P 1400 1300
F 0 "P1" H 1400 1450 50  0000 C CNN
F 1 "12V_POWER" V 1500 1300 50  0000 C CNN
F 2 "Connect:bornier2" H 1400 1300 50  0001 C CNN
F 3 "" H 1400 1300 50  0000 C CNN
	1    1400 1300
	-1   0    0    1   
$EndComp
$Comp
L PWR_FLAG #FLG03
U 1 1 580E1419
P 1650 1050
F 0 "#FLG03" H 1650 1145 50  0001 C CNN
F 1 "PWR_FLAG" H 1650 1230 50  0000 C CNN
F 2 "" H 1650 1050 50  0000 C CNN
F 3 "" H 1650 1050 50  0000 C CNN
	1    1650 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1650 1250 1650 1050
Connection ~ 1650 1250
Wire Wire Line
	4300 1450 4350 1450
Wire Wire Line
	4350 1450 4350 1750
Connection ~ 3850 1750
$Comp
L GND #PWR04
U 1 1 580E1510
P 2050 1850
F 0 "#PWR04" H 2050 1600 50  0001 C CNN
F 1 "GND" H 2050 1700 50  0000 C CNN
F 2 "" H 2050 1850 50  0000 C CNN
F 3 "" H 2050 1850 50  0000 C CNN
	1    2050 1850
	1    0    0    -1  
$EndComp
Text GLabel 4800 1250 2    60   Input ~ 0
3.3V
Wire Wire Line
	4300 1250 4800 1250
$Comp
L C C1
U 1 1 580E15DF
P 4650 1500
F 0 "C1" H 4675 1600 50  0000 L CNN
F 1 "10uF" H 4675 1400 50  0000 L CNN
F 2 "Capacitors_ThroughHole:CP_Radial_D5.0mm_P2.50mm" H 4688 1350 50  0001 C CNN
F 3 "" H 4650 1500 50  0000 C CNN
	1    4650 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 1350 4650 1250
Connection ~ 4650 1250
Wire Wire Line
	4650 1750 4650 1650
Connection ~ 4350 1750
$Comp
L LED-RESCUE-esp8266_irrigation_system D2
U 1 1 580E1A3D
P 2750 800
F 0 "D2" H 2750 900 50  0000 C CNN
F 1 "LED" H 2750 700 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 2750 800 50  0001 C CNN
F 3 "" H 2750 800 50  0000 C CNN
	1    2750 800 
	-1   0    0    1   
$EndComp
$Comp
L R R2
U 1 1 580E1A94
P 2250 800
F 0 "R2" V 2330 800 50  0000 C CNN
F 1 "1k" V 2250 800 50  0000 C CNN
F 2 "Resistors_SMD:R_1206_HandSoldering" V 2180 800 50  0001 C CNN
F 3 "" H 2250 800 50  0000 C CNN
	1    2250 800 
	0    1    1    0   
$EndComp
$Comp
L GND #PWR05
U 1 1 580E1ACD
P 3250 850
F 0 "#PWR05" H 3250 600 50  0001 C CNN
F 1 "GND" H 3250 700 50  0000 C CNN
F 2 "" H 3250 850 50  0000 C CNN
F 3 "" H 3250 850 50  0000 C CNN
	1    3250 850 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1900 1250 1900 600 
Wire Wire Line
	1900 800  2100 800 
Connection ~ 1900 1250
Wire Wire Line
	2400 800  2550 800 
Wire Wire Line
	2950 800  3250 800 
Wire Wire Line
	3250 800  3250 850 
Text GLabel 1700 5550 0    60   Input ~ 0
INFO_LED
$Comp
L R R1
U 1 1 580E1E32
P 2100 5550
F 0 "R1" V 2180 5550 50  0000 C CNN
F 1 "220" V 2100 5550 50  0000 C CNN
F 2 "Resistors_ThroughHole:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 2030 5550 50  0001 C CNN
F 3 "" H 2100 5550 50  0000 C CNN
	1    2100 5550
	0    1    1    0   
$EndComp
$Comp
L LED-RESCUE-esp8266_irrigation_system D1
U 1 1 580E1E89
P 2650 5550
F 0 "D1" H 2650 5650 50  0000 C CNN
F 1 "LED" H 2650 5450 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 2650 5550 50  0001 C CNN
F 3 "" H 2650 5550 50  0000 C CNN
	1    2650 5550
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR06
U 1 1 580E1F36
P 3550 5950
F 0 "#PWR06" H 3550 5700 50  0001 C CNN
F 1 "GND" H 3550 5800 50  0000 C CNN
F 2 "" H 3550 5950 50  0000 C CNN
F 3 "" H 3550 5950 50  0000 C CNN
	1    3550 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1700 5550 1950 5550
Wire Wire Line
	2250 5550 2450 5550
Text GLabel 2550 4600 0    60   Input ~ 0
WATER_VALVE
$Comp
L SW_PUSH SW1
U 1 1 580E241A
P 5850 2350
F 0 "SW1" H 6000 2460 50  0000 C CNN
F 1 "SW_PUSH" H 5850 2270 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 5850 2350 50  0001 C CNN
F 3 "" H 5850 2350 50  0000 C CNN
	1    5850 2350
	1    0    0    -1  
$EndComp
Text GLabel 2150 600  2    60   Input ~ 0
12V
Wire Wire Line
	1900 600  2150 600 
Connection ~ 1900 800 
$Comp
L IRF540N Q1
U 1 1 580E2B6F
P 3450 4550
F 0 "Q1" H 3700 4625 50  0000 L CNN
F 1 "IRF540N" H 3700 4550 50  0000 L CNN
F 2 "Power_Integrations:TO-220" H 3700 4475 50  0000 L CIN
F 3 "" H 3450 4550 50  0000 L CNN
	1    3450 4550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2850 5550 3550 5550
Wire Wire Line
	3550 4750 3550 5950
Connection ~ 3550 5550
$Comp
L INDUCTOR L1
U 1 1 580E3277
P 3550 3900
F 0 "L1" V 3500 3900 50  0000 C CNN
F 1 "INDUCTOR" V 3650 3900 50  0000 C CNN
F 2 "Connect:bornier2" H 3550 3900 50  0001 C CNN
F 3 "" H 3550 3900 50  0000 C CNN
	1    3550 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 4200 3550 4350
Text GLabel 3300 3450 0    60   Input ~ 0
12V
$Comp
L D D3
U 1 1 580E34FE
P 3850 3900
F 0 "D3" H 3850 4000 50  0000 C CNN
F 1 "D" H 3850 3800 50  0000 C CNN
F 2 "Diodes_ThroughHole:D_A-405_P10.16mm_Horizontal" H 3850 3900 50  0001 C CNN
F 3 "" H 3850 3900 50  0000 C CNN
	1    3850 3900
	0    1    1    0   
$EndComp
Wire Wire Line
	3300 3450 3850 3450
Wire Wire Line
	3550 3450 3550 3600
Wire Wire Line
	3850 3450 3850 3750
Connection ~ 3550 3450
Wire Wire Line
	3850 4050 3850 4250
Wire Wire Line
	3850 4250 3550 4250
Connection ~ 3550 4250
$Comp
L CONN_01X03 P3
U 1 1 580E3DEF
P 9650 3600
F 0 "P3" H 9650 3800 50  0000 C CNN
F 1 "DHT22_CONN" V 9750 3600 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x03_Pitch2.54mm" H 9650 3600 50  0001 C CNN
F 3 "" H 9650 3600 50  0000 C CNN
	1    9650 3600
	1    0    0    -1  
$EndComp
Text GLabel 9150 3500 0    60   Input ~ 0
3.3V
Text GLabel 9150 3650 0    60   Input ~ 0
DHT22
$Comp
L GND #PWR07
U 1 1 580E3EFA
P 9350 3850
F 0 "#PWR07" H 9350 3600 50  0001 C CNN
F 1 "GND" H 9350 3700 50  0000 C CNN
F 2 "" H 9350 3850 50  0000 C CNN
F 3 "" H 9350 3850 50  0000 C CNN
	1    9350 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	9150 3500 9450 3500
Wire Wire Line
	9150 3650 9300 3650
Wire Wire Line
	9300 3650 9300 3600
Wire Wire Line
	9300 3600 9450 3600
Wire Wire Line
	9450 3700 9350 3700
Wire Wire Line
	9350 3700 9350 3850
$Comp
L PWR_FLAG #FLG08
U 1 1 58120727
P 1650 1500
F 0 "#FLG08" H 1650 1595 50  0001 C CNN
F 1 "PWR_FLAG" H 1650 1680 50  0000 C CNN
F 2 "" H 1650 1500 50  0000 C CNN
F 3 "" H 1650 1500 50  0000 C CNN
	1    1650 1500
	-1   0    0    1   
$EndComp
Wire Wire Line
	1650 1500 1650 1350
Connection ~ 1650 1350
Wire Wire Line
	2550 4600 3250 4600
$Comp
L CONN_01X03 J1
U 1 1 58E76CC5
P 6750 1750
F 0 "J1" H 6750 1950 50  0000 C CNN
F 1 "MOIST_CONN" V 6850 1750 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x03_Pitch2.54mm" H 6750 1750 50  0001 C CNN
F 3 "" H 6750 1750 50  0001 C CNN
	1    6750 1750
	1    0    0    -1  
$EndComp
Text GLabel 6150 1650 0    60   Input ~ 0
5V
Text GLabel 6150 1800 0    60   Input ~ 0
MOISTURE_SENSOR
Wire Wire Line
	6150 1650 6550 1650
Wire Wire Line
	6550 1750 6250 1750
Wire Wire Line
	6250 1750 6250 1800
Wire Wire Line
	6250 1800 6150 1800
$Comp
L GND #PWR09
U 1 1 58E7710F
P 6400 1950
F 0 "#PWR09" H 6400 1700 50  0001 C CNN
F 1 "GND" H 6400 1800 50  0000 C CNN
F 2 "" H 6400 1950 50  0001 C CNN
F 3 "" H 6400 1950 50  0001 C CNN
	1    6400 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 1850 6400 1850
Wire Wire Line
	6400 1850 6400 1950
NoConn ~ 5300 2850
$Comp
L GND #PWR010
U 1 1 58E77A6E
P 6350 2400
F 0 "#PWR010" H 6350 2150 50  0001 C CNN
F 1 "GND" H 6350 2250 50  0000 C CNN
F 2 "" H 6350 2400 50  0001 C CNN
F 3 "" H 6350 2400 50  0001 C CNN
	1    6350 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 2400 6350 2350
Wire Wire Line
	6350 2350 6150 2350
Wire Wire Line
	5550 2350 5250 2350
Wire Wire Line
	5250 2350 5250 2750
Connection ~ 5250 2750
Wire Wire Line
	4650 3300 4850 3300
Wire Wire Line
	4850 3300 4850 3350
Wire Wire Line
	4850 3350 5300 3350
Wire Wire Line
	5150 3250 5300 3250
Wire Wire Line
	5150 3150 5300 3150
Wire Wire Line
	2050 1350 2050 1850
Wire Wire Line
	1600 1350 2050 1350
Wire Wire Line
	2050 1750 4650 1750
$Comp
L C C4
U 1 1 58E78576
P 3300 1500
F 0 "C4" H 3325 1600 50  0000 L CNN
F 1 "100n" H 3325 1400 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3.8mm_W2.6mm_P2.50mm" H 3338 1350 50  0001 C CNN
F 3 "" H 3300 1500 50  0001 C CNN
	1    3300 1500
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 58E78613
P 2250 1500
F 0 "C3" H 2275 1600 50  0000 L CNN
F 1 "1uF" H 2275 1400 50  0000 L CNN
F 2 "Capacitors_ThroughHole:CP_Radial_D5.0mm_P2.50mm" H 2288 1350 50  0001 C CNN
F 3 "" H 2250 1500 50  0001 C CNN
	1    2250 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 1250 2400 1250
Wire Wire Line
	3200 1250 3400 1250
Connection ~ 2050 1750
Wire Wire Line
	3300 1650 3300 1750
Connection ~ 3300 1750
Wire Wire Line
	2800 1550 2800 1750
Connection ~ 2800 1750
Wire Wire Line
	2250 1650 2250 1750
Connection ~ 2250 1750
Wire Wire Line
	2250 1350 2250 1250
Connection ~ 2250 1250
Wire Wire Line
	3300 1100 3300 1350
Connection ~ 3300 1250
Text GLabel 3750 750  2    60   Input ~ 0
5V
Wire Wire Line
	3300 1100 3400 1100
Wire Wire Line
	3400 1100 3400 750 
Wire Wire Line
	3400 750  3750 750 
$Comp
L LM7805CT U3
U 1 1 58E79DA7
P 2800 1300
F 0 "U3" H 2600 1500 50  0000 C CNN
F 1 "LM7805CT" H 2800 1500 50  0000 L CNN
F 2 "TO_SOT_Packages_THT:TO-220_Vertical" H 2800 1400 50  0001 C CIN
F 3 "" H 2800 1300 50  0001 C CNN
	1    2800 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8400 2100 8650 2100
Wire Wire Line
	9400 2100 9150 2100
Wire Wire Line
	9450 2250 9250 2250
Wire Wire Line
	9250 2250 9250 2200
Wire Wire Line
	9250 2200 9150 2200
Wire Wire Line
	9450 2400 9250 2400
Wire Wire Line
	9250 2400 9250 2300
Wire Wire Line
	9250 2300 9150 2300
Wire Wire Line
	8650 2300 8550 2300
Wire Wire Line
	8550 2300 8550 2450
NoConn ~ 8650 2200
$EndSCHEMATC