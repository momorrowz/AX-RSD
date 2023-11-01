set_property PACKAGE_PIN Y9 [get_ports {sysclk}];  # "GCLK"

set_property PACKAGE_PIN T22 [get_ports {dled}];  # "LD0"
#set_property PACKAGE_PIN T21 [get_ports {led[1]}];  # "LD1"
#set_property PACKAGE_PIN U22 [get_ports {led[2]}];  # "LD2"
#set_property PACKAGE_PIN U21 [get_ports {led[3]}];  # "LD3"
#set_property PACKAGE_PIN V22 [get_ports {led[4]}];  # "LD4"
#set_property PACKAGE_PIN W22 [get_ports {led[5]}];  # "LD5"
#set_property PACKAGE_PIN U19 [get_ports {led[6]}];  # "LD6"
#set_property PACKAGE_PIN U14 [get_ports {led[7]}];  # "LD7"

set_property PACKAGE_PIN P16 [get_ports {resetIn}];  # "BTNC"
set_property PACKAGE_PIN R16 [get_ports {pswIn[0]}];  # "BTND"
set_property PACKAGE_PIN N15 [get_ports {pswIn[1]}];  # "BTNL"
set_property PACKAGE_PIN R18 [get_ports {pswIn[2]}];  # "BTNR"
set_property PACKAGE_PIN T18 [get_ports {pswIn[3]}];  # "BTNU"

set_property PACKAGE_PIN F22 [get_ports {swIn[0]}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {swIn[1]}];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {swIn[2]}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {swIn[3]}];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {swIn[4]}];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {swIn[5]}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {swIn[6]}];  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {swIn[7]}];  # "SW7"

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13 
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN Y11  [get_ports {cpmodIn[4]}];  # "JA1" 
#set_property PACKAGE_PIN AA11 [get_ports {cpmodIn[5]}];  # "JA2" 
#set_property PACKAGE_PIN Y10  [get_ports {cpmodIn[6]}];  # "JA3" 
#set_property PACKAGE_PIN AA9  [get_ports {cpmodIn[7]}];  # "JA4" 
#set_property PACKAGE_PIN AB11 [get_ports {cpmodIn[0]}];  # "JA7" 
#set_property PACKAGE_PIN AB10 [get_ports {cpmodIn[1]}];  # "JA8" 
#set_property PACKAGE_PIN AB9  [get_ports {cpmodIn[2]}];  # "JA9" 
#set_property PACKAGE_PIN AA8  [get_ports {cpmodIn[3]}];  # "JA10" 


# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN W12 [get_ports {cpmodOut[0]}];  # "JB1" 
#set_property PACKAGE_PIN W11 [get_ports {cpmodOut[1]}];  # "JB2" 
#set_property PACKAGE_PIN V10 [get_ports {cpmodOut[2]}];  # "JB3"
#set_property PACKAGE_PIN W8 [get_ports {cpmodIn[9]}];  # "JB4"
#set_property PACKAGE_PIN V12 [get_ports {cpmodOut[0]}];  # "JB7"
#set_property PACKAGE_PIN W10 [get_ports {cpmodOut[1]}];  # "JB8"
#set_property PACKAGE_PIN V9 [get_ports {cpmodOut[2]}];  # "JB9"
#set_property PACKAGE_PIN V8 [get_ports {negResetIn}];  # "JB10"

# ----------------------------------------------------------------------------
# JD Pmod - Bank 13
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN W7 [get_ports {cpmodIn[10]}];  # "JD1_N"
#set_property PACKAGE_PIN V7 [get_ports {cpmodIn[11]}];  # "JD1_P"
#set_property PACKAGE_PIN V4 [get_ports {cpmodIn[12]}];  # "JD2_N"
#set_property PACKAGE_PIN V5 [get_ports {cpmodIn[13]}];  # "JD2_P"
#set_property PACKAGE_PIN W5 [get_ports {cpmodOut[5]}];  # "JD3_N"
#set_property PACKAGE_PIN W6 [get_ports {cpmodOut[6]}];  # "JD3_P"
#set_property PACKAGE_PIN U5 [get_ports {cpmodOut[7]}];  # "JD4_N"
#set_property PACKAGE_PIN U6 [get_ports {cpmodOut[8]}];  # "JD4_P"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 34
## ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN L19 [get_ports {cpmodIn[31]}];  # "FMC-CLK0_N"
set_property PACKAGE_PIN L18 [get_ports {cpmodIn[33]}];  # "FMC-CLK0_P"
set_property PACKAGE_PIN M20 [get_ports {cpmodIn[25]}];  # "FMC-LA00_CC_N"
set_property PACKAGE_PIN M19 [get_ports {cpmodIn[30]}];  # "FMC-LA00_CC_P"
set_property PACKAGE_PIN N20 [get_ports {cpmodIn[18]}];  # "FMC-LA01_CC_N"
set_property PACKAGE_PIN N19 [get_ports {cpmodIn[22]}];  # "FMC-LA01_CC_P" - corrected 6/6/16 GE
set_property PACKAGE_PIN P18 [get_ports {cpmodIn[23]}];  # "FMC-LA02_N"
set_property PACKAGE_PIN P17 [get_ports {cpmodIn[28]}];  # "FMC-LA02_P"
set_property PACKAGE_PIN P22 [get_ports {cpmodIn[14]}];  # "FMC-LA03_N"
set_property PACKAGE_PIN N22 [get_ports {cpmodIn[20]}];  # "FMC-LA03_P"
set_property PACKAGE_PIN M22 [get_ports {cpmodIn[11]}];  # "FMC-LA04_N"
set_property PACKAGE_PIN M21 [get_ports {cpmodIn[16]}];  # "FMC-LA04_P"
set_property PACKAGE_PIN K18 [get_ports {cpmodIn[3]}];  # "FMC-LA05_N"
set_property PACKAGE_PIN J18 [get_ports {cpmodIn[9]}];  # "FMC-LA05_P"
set_property PACKAGE_PIN L22 [get_ports {cpmodIn[6]}];  # "FMC-LA06_N"
set_property PACKAGE_PIN L21 [get_ports {cpmodIn[12]}];  # "FMC-LA06_P"
set_property PACKAGE_PIN T17 [get_ports {cpmodIn[27]}];  # "FMC-LA07_N"
set_property PACKAGE_PIN T16 [get_ports {cpmodIn[0]}];  # "FMC-LA07_P"
set_property PACKAGE_PIN J22 [get_ports {cpmodIn[29]}];  # "FMC-LA08_N"
set_property PACKAGE_PIN J21 [get_ports {cpmodIn[4]}];  # "FMC-LA08_P"
set_property PACKAGE_PIN R21 [get_ports {cpmodIn[19]}];  # "FMC-LA09_N"
set_property PACKAGE_PIN R20 [get_ports {cpmodIn[26]}];  # "FMC-LA09_P"
set_property PACKAGE_PIN T19 [get_ports {cpmodIn[17]}];  # "FMC-LA10_N"
set_property PACKAGE_PIN R19 [get_ports {cpmodIn[24]}];  # "FMC-LA10_P"
set_property PACKAGE_PIN N18 [get_ports {cpmodIn[10]}];  # "FMC-LA11_N"
set_property PACKAGE_PIN N17 [get_ports {cpmodIn[15]}];  # "FMC-LA11_P"
set_property PACKAGE_PIN P21 [get_ports {cpmodIn[13]}];  # "FMC-LA12_N"
set_property PACKAGE_PIN P20 [get_ports {cpmodIn[21]}];  # "FMC-LA12_P"
set_property PACKAGE_PIN M17 [get_ports {cpmodIn[5]}];  # "FMC-LA13_N"
set_property PACKAGE_PIN L17 [get_ports {cpmodIn[8]}];  # "FMC-LA13_P"
set_property PACKAGE_PIN K20 [get_ports {cpmodOut[2]}];  # "FMC-LA14_N"
set_property PACKAGE_PIN K19 [get_ports {cpmodIn[2]}];  # "FMC-LA14_P"
set_property PACKAGE_PIN J17 [get_ports {cpmodOut[4]}];  # "FMC-LA15_N"
set_property PACKAGE_PIN J16 [get_ports {cpmodIn[1]}];  # "FMC-LA15_P"
set_property PACKAGE_PIN K21 [get_ports {cpmodOut[0]}];  # "FMC-LA16_N"
set_property PACKAGE_PIN J20 [get_ports {cpmodIn[7]}];  # "FMC-LA16_P"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 35
## ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN C19 [get_ports {cpmodIn[32]}];  # "FMC-CLK1_N"
set_property PACKAGE_PIN D18 [get_ports {cpmodIn[34]}];  # "FMC-CLK1_P"
set_property PACKAGE_PIN B20 [get_ports {cpmodOut[9]}];  # "FMC-LA17_CC_N"
set_property PACKAGE_PIN B19 [get_ports {cpmodOut[6]}];  # "FMC-LA17_CC_P"
set_property PACKAGE_PIN C20 [get_ports {cpmodOut[22]}];  # "FMC-LA18_CC_N"
set_property PACKAGE_PIN D20 [get_ports {cpmodOut[16]}];  # "FMC-LA18_CC_P"
set_property PACKAGE_PIN G16 [get_ports {cpmodOut[18]}];  # "FMC-LA19_N"
set_property PACKAGE_PIN G15 [get_ports {cpmodOut[11]}];  # "FMC-LA19_P"
set_property PACKAGE_PIN G21 [get_ports {cpmodOut[14]}];  # "FMC-LA20_N"
set_property PACKAGE_PIN G20 [get_ports {cpmodOut[8]}];  # "FMC-LA20_P"
set_property PACKAGE_PIN E20 [get_ports {cpmodOut[1]}];  # "FMC-LA21_N"
set_property PACKAGE_PIN E19 [get_ports {cpmodOut[28]}];  # "FMC-LA21_P"
set_property PACKAGE_PIN F19 [get_ports {cpmodOut[30]}];  # "FMC-LA22_N"
set_property PACKAGE_PIN G19 [get_ports {cpmodOut[25]}];  # "FMC-LA22_P"
set_property PACKAGE_PIN D15 [get_ports {cpmodOut[27]}];  # "FMC-LA23_N"
set_property PACKAGE_PIN E15 [get_ports {cpmodOut[20]}];  # "FMC-LA23_P"
set_property PACKAGE_PIN A19 [get_ports {cpmodOut[17]}];  # "FMC-LA24_N"
set_property PACKAGE_PIN A18 [get_ports {cpmodOut[13]}];  # "FMC-LA24_P"
set_property PACKAGE_PIN C22 [get_ports {cpmodOut[15]}];  # "FMC-LA25_N"
set_property PACKAGE_PIN D22 [get_ports {cpmodOut[7]}];  # "FMC-LA25_P"
set_property PACKAGE_PIN E18 [get_ports {cpmodOut[10]}];  # "FMC-LA26_N"
set_property PACKAGE_PIN F18 [get_ports {cpmodOut[3]}];  # "FMC-LA26_P"
set_property PACKAGE_PIN D21 [get_ports {cpmodOut[12]}];  # "FMC-LA27_N"
set_property PACKAGE_PIN E21 [get_ports {cpmodOut[5]}];  # "FMC-LA27_P"
set_property PACKAGE_PIN A17 [get_ports {cpmodOut[24]}];  # "FMC-LA28_N"
set_property PACKAGE_PIN A16 [get_ports {cpmodOut[21]}];  # "FMC-LA28_P"
set_property PACKAGE_PIN C18 [get_ports {cpmodOut[23]}];  # "FMC-LA29_N"
set_property PACKAGE_PIN C17 [get_ports {cpmodOut[19]}];  # "FMC-LA29_P"
set_property PACKAGE_PIN B15 [get_ports {cpmodOut[33]}];  # "FMC-LA30_N"
set_property PACKAGE_PIN C15 [get_ports {cpmodOut[29]}];  # "FMC-LA30_P"
set_property PACKAGE_PIN B17 [get_ports {cpmodOut[31]}];  # "FMC-LA31_N"
set_property PACKAGE_PIN B16 [get_ports {cpmodOut[26]}];  # "FMC-LA31_P"
set_property PACKAGE_PIN A22 [get_ports {cpmodOut[35]}];  # "FMC-LA32_N"
set_property PACKAGE_PIN A21 [get_ports {cpmodOut[32]}];  # "FMC-LA32_P"
set_property PACKAGE_PIN B22 [get_ports {cpmodOut[34]}];  # "FMC-LA33_N"
set_property PACKAGE_PIN B21 [get_ports {cpmodOut[36]}];  # "FMC-LA33_P"

# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

# Set the bank voltage for IO Bank 34 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
