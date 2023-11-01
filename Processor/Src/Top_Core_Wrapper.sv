`timescale 1ns / 1ps

module Top_Core_Wrapper(
        input logic sysclk,
        input logic resetIn,
        input [7:0] swIn,
        input [3:0] pswIn,
        //input [5:0] pswIn,
        input [34:0] cpmodIn,
        output [36:0] cpmodOut,
        output logic dled
    );
    logic clk;
    
    clk_wiz_0 clk_wiz_0(
        .clk_out1( clk ),
        .clk_in1( sysclk )
    );

    Top_Core topCore(
        .clk( clk ),
        .negResetIn( ~resetIn ),
        .swIn(swIn),
        .pswIn(pswIn),
        .cpmodIn( cpmodIn ),
        .cpmodOut( cpmodOut ),
        .dled( dled )
    );

endmodule
