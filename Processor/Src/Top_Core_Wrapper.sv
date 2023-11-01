`timescale 1ns / 1ps

module Top_Core_Wrapper(
        //input logic sysclk,
        input logic CLK_SLR2_P,
        input logic CLK_SLR2_N,
        input logic resetIn,
        //input [7:0] swIn,
        input [3:0] pswIn,
        //input [5:0] pswIn,
        input [34:0] cpmodIn,
        output [36:0] cpmodOut,
        output logic dled
    );
    logic sysclk, clk;
    IBUFGDS #(
        .DIFF_TERM("TRUE"), // Differential Termination
        .IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE" 
        .IOSTANDARD("LVDS") // Specify the input I/O standard
    ) IBUFGDS_inst (
        .O(sysclk), // Clock buffer output
        .I(CLK_SLR2_P), // Diff_p clock buffer input (connect directly to top-level port)
        .IB(CLK_SLR2_N) // Diff_n clock buffer input (connect directly to top-level port)
    );
 
    clk_wiz_0 clk_wiz_0(
        .clk_out1( clk ),
        .clk_in1( sysclk )
    );

    Top_Core topCore(
        .clk( clk ),
        .negResetIn( ~resetIn ),
        .swIn('0),
        .pswIn({1'b0,pswIn}),
        .cpmodIn( cpmodIn ),
        .cpmodOut( cpmodOut ),
        .dled( dled )
    );

endmodule
