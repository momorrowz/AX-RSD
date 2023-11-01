# set_property PACKAGE_PIN Y9 [get_ports {clk}];  # "GCLK"

set_property PACKAGE_PIN T22 [get_ports {ledOut[0]}]
set_property PACKAGE_PIN T21 [get_ports {ledOut[1]}]
set_property PACKAGE_PIN U22 [get_ports {ledOut[2]}]
set_property PACKAGE_PIN U21 [get_ports {ledOut[3]}]
set_property PACKAGE_PIN V22 [get_ports {ledOut[4]}]
set_property PACKAGE_PIN W22 [get_ports {ledOut[5]}]
set_property PACKAGE_PIN U19 [get_ports {ledOut[6]}]
set_property PACKAGE_PIN U14 [get_ports {ledOut[7]}]

#set_property PACKAGE_PIN P16 [get_ports {pswIn[0]}];  # "BTNC"
#set_property PACKAGE_PIN R16 [get_ports {pswIn[1]}];  # "BTND"
#set_property PACKAGE_PIN N15 [get_ports {pswIn[2]}];  # "BTNL"
#set_property PACKAGE_PIN R18 [get_ports {pswIn[3]}];  # "BTNR"
#set_property PACKAGE_PIN T18 [get_ports {pswIn[4]}];  # "BTNU"

#set_property PACKAGE_PIN F22 [get_ports {swIn[0]}]
#set_property PACKAGE_PIN G22 [get_ports {swIn[1]}]
#set_property PACKAGE_PIN H22 [get_ports {swIn[2]}]
#set_property PACKAGE_PIN F21 [get_ports {swIn[3]}]
#set_property PACKAGE_PIN H19 [get_ports {swIn[4]}]
#set_property PACKAGE_PIN H18 [get_ports {swIn[5]}]
#set_property PACKAGE_PIN H17 [get_ports {swIn[6]}]
#set_property PACKAGE_PIN M15 [get_ports {swIn[7]}]

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13 
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN Y11  [get_ports {mpmodOut[8]}];  # "JA1"
#set_property PACKAGE_PIN AA8  [get_ports {mpmodOut[9]}];  # "JA10"
#set_property PACKAGE_PIN AA11 [get_ports {mpmodIn[3]}];  # "JA2"
#set_property PACKAGE_PIN Y10  [get_ports {mpmodIn[4]}];  # "JA3"
#set_property PACKAGE_PIN AA9  [get_ports {JA4}];  # "JA4"
#set_property PACKAGE_PIN AB11 [get_ports {mpmodIn[0]}];  # "JA7"
#set_property PACKAGE_PIN AB10 [get_ports {mpmodIn[1]}];  # "JA8"
#set_property PACKAGE_PIN AB9  [get_ports {mpmodIn[2]}];  # "JA9"


# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN W12 [get_ports {mpmodOut[4]}];  # "JB1"
#set_property PACKAGE_PIN W11 [get_ports {mpmodOut[5]}];  # "JB2"
#set_property PACKAGE_PIN V10 [get_ports {mpmodOut[6]}];  # "JB3"
#set_property PACKAGE_PIN W8  [get_ports {mpmodOut[7]}];  # "JB4"
#set_property PACKAGE_PIN V12 [get_ports {mpmodOut[0]}];  # "JB7"
#set_property PACKAGE_PIN W10 [get_ports {mpmodOut[1]}];  # "JB8"
#set_property PACKAGE_PIN V9  [get_ports {mpmodOut[2]}];  # "JB9"
#set_property PACKAGE_PIN V8  [get_ports {mpmodOut[3]}];  # "JB10"

# ----------------------------------------------------------------------------
# JD Pmod - Bank 13
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN W7 [get_ports {mpmodIn[5]}];  # "JD1_N"
#set_property PACKAGE_PIN V7 [get_ports {mpmodIn[6]}];  # "JD1_P"
#set_property PACKAGE_PIN V4 [get_ports {mpmodIn[7]}];  # "JD2_N"
#set_property PACKAGE_PIN V5 [get_ports {mpmodIn[8]}];  # "JD2_P"
#set_property PACKAGE_PIN W5 [get_ports {mpmodOut[10]}];  # "JD3_N"
#set_property PACKAGE_PIN W6 [get_ports {mpmodOut[11]}];  # "JD3_P"
#set_property PACKAGE_PIN U5 [get_ports {mpmodOut[12]}];  # "JD4_N"
#set_property PACKAGE_PIN U6 [get_ports {mpmodOut[13]}];  # "JD4_P"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 34
## ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN L19 [get_ports {mpmodOut[31]}];  # "FMC-CLK0_N"
set_property PACKAGE_PIN L18 [get_ports {mpmodOut[33]}];  # "FMC-CLK0_P"
set_property PACKAGE_PIN M20 [get_ports {mpmodOut[25]}];  # "FMC-LA00_CC_N"
set_property PACKAGE_PIN M19 [get_ports {mpmodOut[30]}];  # "FMC-LA00_CC_P"
set_property PACKAGE_PIN N20 [get_ports {mpmodOut[18]}];  # "FMC-LA01_CC_N"
set_property PACKAGE_PIN N19 [get_ports {mpmodOut[22]}];  # "FMC-LA01_CC_P" - corrected 6/6/16 GE
set_property PACKAGE_PIN P18 [get_ports {mpmodOut[23]}];  # "FMC-LA02_N"
set_property PACKAGE_PIN P17 [get_ports {mpmodOut[28]}];  # "FMC-LA02_P"
set_property PACKAGE_PIN P22 [get_ports {mpmodOut[14]}];  # "FMC-LA03_N"
set_property PACKAGE_PIN N22 [get_ports {mpmodOut[20]}];  # "FMC-LA03_P"
set_property PACKAGE_PIN M22 [get_ports {mpmodOut[11]}];  # "FMC-LA04_N"
set_property PACKAGE_PIN M21 [get_ports {mpmodOut[16]}];  # "FMC-LA04_P"
set_property PACKAGE_PIN K18 [get_ports {mpmodOut[3]}];  # "FMC-LA05_N"
set_property PACKAGE_PIN J18 [get_ports {mpmodOut[9]}];  # "FMC-LA05_P"
set_property PACKAGE_PIN L22 [get_ports {mpmodOut[6]}];  # "FMC-LA06_N"
set_property PACKAGE_PIN L21 [get_ports {mpmodOut[12]}];  # "FMC-LA06_P"
set_property PACKAGE_PIN T17 [get_ports {mpmodOut[27]}];  # "FMC-LA07_N"
set_property PACKAGE_PIN T16 [get_ports {mpmodOut[0]}];  # "FMC-LA07_P"
set_property PACKAGE_PIN J22 [get_ports {mpmodOut[29]}];  # "FMC-LA08_N"
set_property PACKAGE_PIN J21 [get_ports {mpmodOut[4]}];  # "FMC-LA08_P"
set_property PACKAGE_PIN R21 [get_ports {mpmodOut[19]}];  # "FMC-LA09_N"
set_property PACKAGE_PIN R20 [get_ports {mpmodOut[26]}];  # "FMC-LA09_P"
set_property PACKAGE_PIN T19 [get_ports {mpmodOut[17]}];  # "FMC-LA10_N"
set_property PACKAGE_PIN R19 [get_ports {mpmodOut[24]}];  # "FMC-LA10_P"
set_property PACKAGE_PIN N18 [get_ports {mpmodOut[10]}];  # "FMC-LA11_N"
set_property PACKAGE_PIN N17 [get_ports {mpmodOut[15]}];  # "FMC-LA11_P"
set_property PACKAGE_PIN P21 [get_ports {mpmodOut[13]}];  # "FMC-LA12_N"
set_property PACKAGE_PIN P20 [get_ports {mpmodOut[21]}];  # "FMC-LA12_P"
set_property PACKAGE_PIN M17 [get_ports {mpmodOut[5]}];  # "FMC-LA13_N"
set_property PACKAGE_PIN L17 [get_ports {mpmodOut[8]}];  # "FMC-LA13_P"
set_property PACKAGE_PIN K20 [get_ports {mpmodIn[2]}];  # "FMC-LA14_N"
set_property PACKAGE_PIN K19 [get_ports {mpmodOut[2]}];  # "FMC-LA14_P"
set_property PACKAGE_PIN J17 [get_ports {mpmodIn[4]}];  # "FMC-LA15_N"
set_property PACKAGE_PIN J16 [get_ports {mpmodOut[1]}];  # "FMC-LA15_P"
set_property PACKAGE_PIN K21 [get_ports {mpmodIn[0]}];  # "FMC-LA16_N"
set_property PACKAGE_PIN J20 [get_ports {mpmodOut[7]}];  # "FMC-LA16_P"

## ----------------------------------------------------------------------------
## FMC Expansion Connector - Bank 35
## ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN C19 [get_ports {mpmodOut[32]}];  # "FMC-CLK1_N"
set_property PACKAGE_PIN D18 [get_ports {mpmodOut[34]}];  # "FMC-CLK1_P"
set_property PACKAGE_PIN B20 [get_ports {mpmodIn[9]}];  # "FMC-LA17_CC_N"
set_property PACKAGE_PIN B19 [get_ports {mpmodIn[6]}];  # "FMC-LA17_CC_P"
set_property PACKAGE_PIN C20 [get_ports {mpmodIn[22]}];  # "FMC-LA18_CC_N"
set_property PACKAGE_PIN D20 [get_ports {mpmodIn[16]}];  # "FMC-LA18_CC_P"
set_property PACKAGE_PIN G16 [get_ports {mpmodIn[18]}];  # "FMC-LA19_N"
set_property PACKAGE_PIN G15 [get_ports {mpmodIn[11]}];  # "FMC-LA19_P"
set_property PACKAGE_PIN G21 [get_ports {mpmodIn[14]}];  # "FMC-LA20_N"
set_property PACKAGE_PIN G20 [get_ports {mpmodIn[8]}];  # "FMC-LA20_P"
set_property PACKAGE_PIN E20 [get_ports {mpmodIn[1]}];  # "FMC-LA21_N"
set_property PACKAGE_PIN E19 [get_ports {mpmodIn[28]}];  # "FMC-LA21_P"
set_property PACKAGE_PIN F19 [get_ports {mpmodIn[30]}];  # "FMC-LA22_N"
set_property PACKAGE_PIN G19 [get_ports {mpmodIn[25]}];  # "FMC-LA22_P"
set_property PACKAGE_PIN D15 [get_ports {mpmodIn[27]}];  # "FMC-LA23_N"
set_property PACKAGE_PIN E15 [get_ports {mpmodIn[20]}];  # "FMC-LA23_P"
set_property PACKAGE_PIN A19 [get_ports {mpmodIn[17]}];  # "FMC-LA24_N"
set_property PACKAGE_PIN A18 [get_ports {mpmodIn[13]}];  # "FMC-LA24_P"
set_property PACKAGE_PIN C22 [get_ports {mpmodIn[15]}];  # "FMC-LA25_N"
set_property PACKAGE_PIN D22 [get_ports {mpmodIn[7]}];  # "FMC-LA25_P"
set_property PACKAGE_PIN E18 [get_ports {mpmodIn[10]}];  # "FMC-LA26_N"
set_property PACKAGE_PIN F18 [get_ports {mpmodIn[3]}];  # "FMC-LA26_P"
set_property PACKAGE_PIN D21 [get_ports {mpmodIn[12]}];  # "FMC-LA27_N"
set_property PACKAGE_PIN E21 [get_ports {mpmodIn[5]}];  # "FMC-LA27_P"
set_property PACKAGE_PIN A17 [get_ports {mpmodIn[24]}];  # "FMC-LA28_N"
set_property PACKAGE_PIN A16 [get_ports {mpmodIn[21]}];  # "FMC-LA28_P"
set_property PACKAGE_PIN C18 [get_ports {mpmodIn[23]}];  # "FMC-LA29_N"
set_property PACKAGE_PIN C17 [get_ports {mpmodIn[19]}];  # "FMC-LA29_P"
set_property PACKAGE_PIN B15 [get_ports {mpmodIn[33]}];  # "FMC-LA30_N"
set_property PACKAGE_PIN C15 [get_ports {mpmodIn[29]}];  # "FMC-LA30_P"
set_property PACKAGE_PIN B17 [get_ports {mpmodIn[31]}];  # "FMC-LA31_N"
set_property PACKAGE_PIN B16 [get_ports {mpmodIn[26]}];  # "FMC-LA31_P"
set_property PACKAGE_PIN A22 [get_ports {mpmodIn[35]}];  # "FMC-LA32_N"
set_property PACKAGE_PIN A21 [get_ports {mpmodIn[32]}];  # "FMC-LA32_P"
set_property PACKAGE_PIN B22 [get_ports {mpmodIn[34]}];  # "FMC-LA33_N"
set_property PACKAGE_PIN B21 [get_ports {mpmodIn[36]}];  # "FMC-LA33_P"

# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard.
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]]

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

#TMDS_clk
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_n]
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_p]
set_property PACKAGE_PIN T4 [get_ports TMDS_clk_p]
set_property PACKAGE_PIN U4 [get_ports TMDS_clk_n]

#TMDS_data[0]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[0]}]
set_property PACKAGE_PIN R6 [get_ports {TMDS_data_p[0]}]
set_property PACKAGE_PIN T6 [get_ports {TMDS_data_n[0]}]

#TMDS_data[1]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[1]}]
set_property PACKAGE_PIN Y4 [get_ports {TMDS_data_p[1]}]
set_property PACKAGE_PIN AA4 [get_ports {TMDS_data_n[1]}]

#TMDS_data[2]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[2]}]
set_property PACKAGE_PIN AB7 [get_ports {TMDS_data_p[2]}]
set_property PACKAGE_PIN AB6 [get_ports {TMDS_data_n[2]}]

# false path
set_clock_groups -asynchronous -group [get_clocks clk_fpga_1] -group [get_clocks -include_generated_clocks clk_fpga_1 -filter {NAME !~ clk_fpga_1}]

