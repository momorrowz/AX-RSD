#########################################################################
## O N I X module master XDC ( Avnet )
##
## Ver 1.1
##
## written by kadomoto (18/05/08)
##
#######################################################################

###General/Configuration###########################################

set_property CONFIG_VOLTAGE 1.8 [current_design];
set_property CFGBVS GND [current_design];
set_property BITSTREAM.GENERAL.COMPRESS true [current_design];



###Clocks##########################################################

#set_property PACKAGE_PIN AU46                [get_ports SYSCLK_300M_P]
#set_property IOSTANDARD DIFF_SSTL12          [get_ports SYSCLK_300M_P]
#set_property PACKAGE_PIN AU47                [get_ports SYSCLK_300M_N]
#set_property IOSTANDARD DIFF_SSTL12          [get_ports SYSCLK_300M_N]
#set_property DIFF_TERM_ADV TERM_NONE         [get_ports SYSCLK_300M_P]
#create_clock -period 3.333 -name SYSCLK_300M [get_ports SYSCLK_300M_P]
#
#set_property PACKAGE_PIN AY23                [get_ports CLK_SLR0_P]
#set_property PACKAGE_PIN BA23                [get_ports CLK_SLR0_N]
#set_property IOSTANDARD LVDS                 [get_ports CLK_SLR0_P]
#set_property DIFF_TERM_ADV TERM_NONE         [get_ports CLK_SLR0_P]
#create_clock -period 30.00 -name CLK_SLR0    [get_ports CLK_SLR0_P]
#
#set_property PACKAGE_PIN BK27                [get_ports CLK_SLR1_P]
#set_property PACKAGE_PIN BL27                [get_ports CLK_SLR1_N]
#set_property IOSTANDARD LVDS_25              [get_ports CLK_SLR1_P]
#set_property DIFF_TERM_ADV TERM_NONE         [get_ports CLK_SLR1_P]
#create_clock -period 3.333 -name CLK_SLR1    [get_ports CLK_SLR1_P]

set_property PACKAGE_PIN L38                 [get_ports CLK_SLR2_P]
set_property PACKAGE_PIN L39                 [get_ports CLK_SLR2_N]
set_property IOSTANDARD LVDS                 [get_ports CLK_SLR2_P]
set_property DIFF_TERM_ADV TERM_NONE         [get_ports CLK_SLR2_P]
create_clock -period 8.00 -name CLK_SLR2     [get_ports CLK_SLR2_P]


### FMC ###########################################
set_property PACKAGE_PIN BM44 [get_ports cpmodIn[25] ]
set_property PACKAGE_PIN BL43 [get_ports cpmodIn[30] ]
set_property PACKAGE_PIN BL45 [get_ports cpmodIn[18] ]
set_property PACKAGE_PIN BL44 [get_ports cpmodIn[22] ]
set_property PACKAGE_PIN BP41 [get_ports cpmodIn[23] ]
set_property PACKAGE_PIN BP40 [get_ports cpmodIn[28] ]
set_property PACKAGE_PIN BM42 [get_ports cpmodIn[14] ]
set_property PACKAGE_PIN BM41 [get_ports cpmodIn[20] ]
set_property PACKAGE_PIN BN39 [get_ports cpmodIn[11] ]
set_property PACKAGE_PIN BN38 [get_ports cpmodIn[16] ]
set_property PACKAGE_PIN BP48 [get_ports cpmodIn[3] ]
set_property PACKAGE_PIN BN48 [get_ports cpmodIn[9] ]
set_property PACKAGE_PIN BK48 [get_ports cpmodIn[6] ]
set_property PACKAGE_PIN BK47 [get_ports cpmodIn[12] ]
set_property PACKAGE_PIN BM40 [get_ports cpmodIn[27] ]
set_property PACKAGE_PIN BM39 [get_ports cpmodIn[0] ]
set_property PACKAGE_PIN BP39 [get_ports cpmodIn[29] ]
set_property PACKAGE_PIN BP38 [get_ports cpmodIn[4] ]
set_property PACKAGE_PIN BM49 [get_ports cpmodIn[19] ]
set_property PACKAGE_PIN BL49 [get_ports cpmodIn[26] ]
set_property PACKAGE_PIN BP49 [get_ports cpmodIn[17] ]
set_property PACKAGE_PIN BN49 [get_ports cpmodIn[24] ]
set_property PACKAGE_PIN BL40 [get_ports cpmodIn[10] ]
set_property PACKAGE_PIN BL39 [get_ports cpmodIn[15] ]
set_property PACKAGE_PIN BN37 [get_ports cpmodIn[13] ]
set_property PACKAGE_PIN BM37 [get_ports cpmodIn[21] ]
set_property PACKAGE_PIN BP51 [get_ports cpmodIn[5] ]
set_property PACKAGE_PIN BP50 [get_ports cpmodIn[8] ]
set_property PACKAGE_PIN BM50 [get_ports cpmodOut[2] ]
set_property PACKAGE_PIN BL50 [get_ports cpmodIn[2] ]
set_property PACKAGE_PIN BN52 [get_ports cpmodOut[4] ]
set_property PACKAGE_PIN BM52 [get_ports cpmodIn[1] ]
set_property PACKAGE_PIN BN51 [get_ports cpmodOut[0] ]
set_property PACKAGE_PIN BM51 [get_ports cpmodIn[7] ]
set_property PACKAGE_PIN BC36 [get_ports cpmodOut[9] ]
set_property PACKAGE_PIN BB36 [get_ports cpmodOut[6] ]
set_property PACKAGE_PIN BC37 [get_ports cpmodOut[22] ]
set_property PACKAGE_PIN BB37 [get_ports cpmodOut[16] ]
set_property PACKAGE_PIN BK35 [get_ports cpmodOut[18] ]
set_property PACKAGE_PIN BJ35 [get_ports cpmodOut[11] ]
set_property PACKAGE_PIN BK37 [get_ports cpmodOut[14] ]
set_property PACKAGE_PIN BK36 [get_ports cpmodOut[8] ]
set_property PACKAGE_PIN BJ36 [get_ports cpmodOut[1] ]
set_property PACKAGE_PIN BH36 [get_ports cpmodOut[28] ]
set_property PACKAGE_PIN BH38 [get_ports cpmodOut[30] ]
set_property PACKAGE_PIN BH37 [get_ports cpmodOut[25] ]
set_property PACKAGE_PIN BG37 [get_ports cpmodOut[27] ]
set_property PACKAGE_PIN BG36 [get_ports cpmodOut[20] ]
set_property PACKAGE_PIN BD36 [get_ports cpmodOut[17] ]
set_property PACKAGE_PIN BD35 [get_ports cpmodOut[13] ]
set_property PACKAGE_PIN BE37 [get_ports cpmodOut[15] ]
set_property PACKAGE_PIN BE36 [get_ports cpmodOut[7] ]
set_property PACKAGE_PIN BF35 [get_ports cpmodOut[10] ]
set_property PACKAGE_PIN BE35 [get_ports cpmodOut[3] ]
set_property PACKAGE_PIN BF38 [get_ports cpmodOut[12] ]
set_property PACKAGE_PIN BF37 [get_ports cpmodOut[5] ]
set_property PACKAGE_PIN BB35 [get_ports cpmodOut[24] ]
set_property PACKAGE_PIN BA35 [get_ports cpmodOut[21] ]
set_property PACKAGE_PIN BD38 [get_ports cpmodOut[23] ]
set_property PACKAGE_PIN BC38 [get_ports cpmodOut[19] ]
set_property PACKAGE_PIN AY36 [get_ports cpmodOut[33] ]
set_property PACKAGE_PIN AW36 [get_ports cpmodOut[29] ]
set_property PACKAGE_PIN AY35 [get_ports cpmodOut[31] ]
set_property PACKAGE_PIN AW35 [get_ports cpmodOut[26] ]
set_property PACKAGE_PIN AU35 [get_ports cpmodOut[35] ]
set_property PACKAGE_PIN AT35 [get_ports cpmodOut[32] ]
set_property PACKAGE_PIN AW39 [get_ports cpmodOut[34] ]
set_property PACKAGE_PIN AW38 [get_ports cpmodOut[36] ]
set_property PACKAGE_PIN BM46 [get_ports cpmodIn[31] ]
set_property PACKAGE_PIN BM45 [get_ports cpmodIn[33] ]
set_property PACKAGE_PIN BM47 [get_ports cpmodIn[32] ]
set_property PACKAGE_PIN BL47 [get_ports cpmodIn[34] ]

set_property IOSTANDARD LVCMOS18 [get_ports cpmod*]

### Push buttons & LEDs ###########################################
set_property PACKAGE_PIN BL25 [get_ports resetIn];
#set_property PACKAGE_PIN BM25 [get_ports GPIO_BUTTON_1]
#set_property PACKAGE_PIN BL24 [get_ports GPIO_BUTTON_2]
#set_property PACKAGE_PIN BL23 [get_ports GPIO_BUTTON_3]
set_property IOSTANDARD LVCMOS33 [get_ports resetIn]
set_property DRIVE 12 [get_ports resetIn]
set_property SLEW SLOW [get_ports resetIn]

set_property PACKAGE_PIN BK28 [ get_ports pswIn[0] ]
set_property PACKAGE_PIN BL28 [ get_ports pswIn[1] ]
set_property PACKAGE_PIN BK26 [ get_ports pswIn[2] ]
set_property PACKAGE_PIN BK25 [ get_ports pswIn[3] ]
#set_property PACKAGE_PIN BN26 [ get_ports FPGA_SW_B4 ]
#set_property PACKAGE_PIN BP26 [ get_ports FPGA_SW_B5 ]
#set_property PACKAGE_PIN BM27 [ get_ports FPGA_SW_B6 ]
#set_property PACKAGE_PIN BN27 [ get_ports FPGA_SW_B7 ]
set_property IOSTANDARD LVCMOS33 [ get_ports pswIn* ]
set_property DRIVE 12 [ get_ports pswIn* ]
set_property SLEW SLOW [ get_ports pswIn* ]

set_property PACKAGE_PIN D40 [get_ports dled]
#set_property PACKAGE_PIN D41 [get_ports FPGA_USER_LED1]
#set_property PACKAGE_PIN E40 [get_ports FPGA_USER_LED2]
#set_property PACKAGE_PIN E41 [get_ports FPGA_USER_LED3]
#set_property PACKAGE_PIN F39 [get_ports FPGA_USER_LED4]
#set_property PACKAGE_PIN F40 [get_ports FPGA_USER_LED5]
#set_property PACKAGE_PIN G39 [get_ports FPGA_USER_LED6]
#set_property PACKAGE_PIN G40 [get_ports FPGA_USER_LED7]
set_property IOSTANDARD LVCMOS18 [get_ports dled]
