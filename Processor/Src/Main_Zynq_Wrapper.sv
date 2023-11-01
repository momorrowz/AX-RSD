// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.



//
// Main_RSD
//
// This is wrapper module for compiling at synplify2017

`ifndef RSD_SYNTHESIS_ATLYS

`include "SysDeps/XilinxMacros.vh"

import BasicTypes::*;
import CacheSystemTypes::*;
import MemoryTypes::*;
import DebugTypes::*;
import MemoryMapTypes::*;
import IO_UnitTypes::*;
import CommuteTypes::*;

module Main_Zynq_Wrapper #(
`ifdef RSD_POST_SYNTHESIS
    parameter MEM_INIT_HEX_FILE = "code.hex"
`else
    parameter MEM_INIT_HEX_FILE = ""
`endif
)(

`ifdef RSD_SYNTHESIS_ZEDBOARD
input
    logic clk,
    logic negResetIn, // 負論理
    CtoMPort mpmodIn,
output
    LED_Path ledOut, // LED Output
    MtoCPort mpmodOut,
`else
// RSD_POST_SYNTHESIS
// RSD_FUNCTIONAL_SIMULATION
input
    logic clk_p, clk_n,
    logic negResetIn, // 負論理
    logic rxd,
    SW_Path swIn, // Switch Input
    PSW_Path pswIn, // Push Switch Input
`endif

`ifndef RSD_SYNTHESIS_VIVADO
output
    DebugRegister debugRegister,
`endif

`ifdef RSD_USE_EXTERNAL_MEMORY
    `EXPAND_AXI4MEMORY_PORT
`endif

`ifdef RSD_SYNTHESIS_ZEDBOARD
    `EXPAND_CONTROL_REGISTER_PORT
`else 
output
    logic serialWE,
    SerialDataPath serialWriteData,
    logic posResetOut, // 正論理
    LED_Path ledOut, // LED Output
    logic txd
`endif
);

`ifdef RSD_SYNTHESIS_VIVADO
   (* DONT_TOUCH="yes"*) logic [$bits(DebugRegister)-1:0] debugRegister;
`endif

`ifdef RSD_USE_EXTERNAL_MEMORY
    Axi4MemoryIF axi4MemoryIF();

    always_comb begin
        // Combine external ports into IF
        `CONNECT_AXI4MEMORY_IF
    end
`endif



`ifdef RSD_SYNTHESIS_ZEDBOARD
    Axi4LiteControlRegisterIF axi4LitePlToPsControlRegisterIF();
    Axi4LiteControlRegisterIF axi4LitePsToPlControlRegisterIF();

    always_comb begin
        // Combine external ports into IF
        `CONNECT_CONTROL_REGISTER_IF
    end
`endif

`ifndef RSD_SYNTHESIS_ZEDBOARD
    MtoCPort mpmodOut;
    MtoCPort cpmodIn;
    CtoMPort mpmodIn;
    CtoMPort cpmodOut;

    Cable cable(
        `ifdef RSD_SYNTHESIS_ZEDBOARD
                .clk(clk),
        `else
                .clk(clk_p),
        `endif
        .cpmodIn( cpmodIn ),
        .mpmodIn( mpmodIn ),
        .cpmodOut( cpmodOut ),
        .mpmodOut( mpmodOut )
    );
`endif

    Main_Zynq #(
        .MEM_INIT_HEX_FILE (MEM_INIT_HEX_FILE)
    ) main (
        mpmodIn,
        mpmodOut,
`ifdef RSD_SYNTHESIS_ZEDBOARD
        clk,
        negResetIn,
        ledOut,
`else
        clk_p,
        clk_n,
        negResetIn,
        rxd,
`endif

//`ifndef RSD_DISABLE_DEBUG_REGISTER
//        debugRegister,
//`endif

`ifdef RSD_USE_EXTERNAL_MEMORY
        axi4MemoryIF,
`endif

`ifdef RSD_SYNTHESIS_ZEDBOARD
        axi4LitePlToPsControlRegisterIF,
        axi4LitePsToPlControlRegisterIF
`else 
        serialWE,
        serialWriteData,
        posResetOut,
        ledOut,
        txd
`endif
    );

`ifndef RSD_SYNTHESIS_ZEDBOARD
    logic dled, rstled;
    Top_Core topCore (
`ifndef RSD_DISABLE_DEBUG_REGISTER
        .debugRegister ( debugRegister ),
`endif
        .negResetIn(negResetIn),
        .dled(dled),
`ifdef RSD_SYNTHESIS_ZEDBOARD
        .clk(clk),
`else
        .clk(clk_p),
`endif
        .swIn(swIn),
        .pswIn(pswIn),
        .cpmodIn(cpmodIn),
        .cpmodOut(cpmodOut)
        );
`endif

endmodule : Main_Zynq_Wrapper

`endif
