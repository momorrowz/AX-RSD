# set_property PACKAGE_PIN Y9 [get_ports {clk}];  # "GCLK"

set_property PACKAGE_PIN T22 [get_ports {ledOut[0]}]
set_property PACKAGE_PIN T21 [get_ports {ledOut[1]}]
set_property PACKAGE_PIN U22 [get_ports {ledOut[2]}]
set_property PACKAGE_PIN U21 [get_ports {ledOut[3]}]
set_property PACKAGE_PIN V22 [get_ports {ledOut[4]}]
set_property PACKAGE_PIN W22 [get_ports {ledOut[5]}]
set_property PACKAGE_PIN U19 [get_ports {ledOut[6]}]
set_property PACKAGE_PIN U14 [get_ports {ledOut[7]}]

# set_property PACKAGE_PIN P16 [get_ports {negResetIn}];  # "BTNC"
# set_property PACKAGE_PIN R16 [get_ports {BTND}];  # "BTND"
# set_property PACKAGE_PIN N15 [get_ports {BTNL}];  # "BTNL"
# set_property PACKAGE_PIN R18 [get_ports {BTNR}];  # "BTNR"
# set_property PACKAGE_PIN T18 [get_ports {ibit}];  # "BTNU"

set_property PACKAGE_PIN F22 [get_ports {swIn[0]}]
set_property PACKAGE_PIN G22 [get_ports {swIn[1]}]
set_property PACKAGE_PIN H22 [get_ports {swIn[2]}]
set_property PACKAGE_PIN F21 [get_ports {swIn[3]}]
set_property PACKAGE_PIN H19 [get_ports {swIn[4]}]
set_property PACKAGE_PIN H18 [get_ports {swIn[5]}]
set_property PACKAGE_PIN H17 [get_ports {swIn[6]}]
set_property PACKAGE_PIN M15 [get_ports {swIn[7]}]

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
set_clock_groups -asynchronous -group [get_clocks clk_fpga_1] \
    -group [get_clocks -include_generated_clocks clk_fpga_1 -filter {NAME !~ clk_fpga_1}]

