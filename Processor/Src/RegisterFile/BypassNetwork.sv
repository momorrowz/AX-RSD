// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


//
// --- Bypass network
//

import BasicTypes::*;
import PipelineTypes::*;
import BypassTypes::*;

typedef struct packed // struct BypassOperand
{
    PRegDataPath value;
} BypassOperand;


module BypassStage(
    input  logic clk, rst, 
    input  PipelineControll ctrl,
    input  BypassOperand in, 
    output BypassOperand out 
);
    BypassOperand body;
    
    always_ff@( posedge clk )               // synchronous rst 
    begin
        if( rst || ctrl.clear ) begin              // rst 
            body.value.data <= 0;
            body.value.valid <= 0;
        end
        else if( ctrl.stall ) begin         // write data
            body <= body;
        end
        else begin
            body <= in;
        end
    end
    
    assign out = body;
endmodule


module BypassNetwork( 
    BypassNetworkIF.BypassNetwork port,
    ControllerIF.BypassNetwork ctrl
);
    function automatic PRegDataPath SelectData( 
    input
        BypassSelect sel,
        BypassOperand intEX [ INT_ISSUE_WIDTH ],
        BypassOperand intWB [ INT_ISSUE_WIDTH ],
        BypassOperand memMA [ LOAD_ISSUE_WIDTH ],
        BypassOperand memWB [ LOAD_ISSUE_WIDTH ]
    );
        if( sel.stg == BYPASS_STAGE_INT_EX )
            return intEX[sel.lane.intLane].value;
        else   if( sel.stg == BYPASS_STAGE_INT_WB )
            return intWB[sel.lane.intLane].value;
        else   if( sel.stg == BYPASS_STAGE_MEM_MA )
            return memMA[sel.lane.memLane].value;
        else   if( sel.stg == BYPASS_STAGE_MEM_WB )
            return memWB[sel.lane.memLane].value;
        else
            return '0;
        
    endfunction 

`ifdef RSD_MARCH_BYPASS_COMPLEX_FP
    function automatic PRegDataPath SelectData_IntComplexMem( 
    input
        BypassSelect sel,
        BypassOperand intEX [ INT_ISSUE_WIDTH ],
        BypassOperand intWB [ INT_ISSUE_WIDTH ],
        BypassOperand memMA [ LOAD_ISSUE_WIDTH ],
        BypassOperand memWB [ LOAD_ISSUE_WIDTH ],
        BypassOperand complexEX2 [ COMPLEX_ISSUE_WIDTH ],
        BypassOperand complexWB [ COMPLEX_ISSUE_WIDTH ]
    );
        if( sel.stg == BYPASS_STAGE_INT_EX )
            return intEX[sel.lane.intLane].value;
        else   if( sel.stg == BYPASS_STAGE_INT_WB )
            return intWB[sel.lane.intLane].value;
        else   if( sel.stg == BYPASS_STAGE_MEM_MA )
            return memMA[sel.lane.memLane].value;
        else   if( sel.stg == BYPASS_STAGE_MEM_WB )
            return memWB[sel.lane.memLane].value;
        else   if( sel.stg == BYPASS_STAGE_COMPLEX_EX2 )
            return complexEX2[sel.lane.complexLane].value;
        else   if( sel.stg == BYPASS_STAGE_COMPLEX_WB )
            return complexWB[sel.lane.complexLane].value;
        else
            return '0;
        
    endfunction 

`ifdef RSD_MARCH_FP_PIPE
    function automatic PRegDataPath SelectData_IntComplexMemFP(
    input
        BypassSelect sel,
        BypassOperand intEX [ INT_ISSUE_WIDTH ],
        BypassOperand intWB [ INT_ISSUE_WIDTH ],
        BypassOperand memMA [ LOAD_ISSUE_WIDTH ],
        BypassOperand memWB [ LOAD_ISSUE_WIDTH ],
        BypassOperand complexEX2 [ COMPLEX_ISSUE_WIDTH ],
        BypassOperand complexWB [ COMPLEX_ISSUE_WIDTH ],
`ifdef RSD_MARCH_LOW_LATENCY_FP
        BypassOperand fpEX0 [ FP_ISSUE_WIDTH ],
        BypassOperand fpEX1 [ FP_ISSUE_WIDTH ],
        BypassOperand fpEX2 [ FP_ISSUE_WIDTH ],
        BypassOperand fpEX3 [ FP_ISSUE_WIDTH ],
`endif
        BypassOperand fpEX4 [ FP_ISSUE_WIDTH ],
        BypassOperand fpWB [ FP_ISSUE_WIDTH ]
    );
        if( sel.stg == BYPASS_STAGE_INT_EX )
            return intEX[sel.lane.intLane].value;
        else   if( sel.stg == BYPASS_STAGE_INT_WB )
            return intWB[sel.lane.intLane].value;
        else   if( sel.stg == BYPASS_STAGE_MEM_MA )
            return memMA[sel.lane.memLane].value;
        else   if( sel.stg == BYPASS_STAGE_MEM_WB )
            return memWB[sel.lane.memLane].value;
        else   if( sel.stg == BYPASS_STAGE_COMPLEX_EX2 )
            return complexEX2[sel.lane.complexLane].value;
        else   if( sel.stg == BYPASS_STAGE_COMPLEX_WB )
            return complexWB[sel.lane.complexLane].value;
`ifdef RSD_MARCH_LOW_LATENCY_FP
        else   if( sel.stg == BYPASS_STAGE_FP_EX0 )
            return fpEX0[sel.lane.fpLane].value;
        else   if( sel.stg == BYPASS_STAGE_FP_EX1 )
            return fpEX1[sel.lane.fpLane].value;
        else   if( sel.stg == BYPASS_STAGE_FP_EX2 )
            return fpEX2[sel.lane.fpLane].value;
        else   if( sel.stg == BYPASS_STAGE_FP_EX3 )
            return fpEX3[sel.lane.fpLane].value;
`endif
        else   if( sel.stg == BYPASS_STAGE_FP_EX4 )
            return fpEX4[sel.lane.fpLane].value;
        else   if( sel.stg == BYPASS_STAGE_FP_WB )
            return fpWB[sel.lane.fpLane].value;
        else
            return '0;
    endfunction
    
    function automatic PRegDataPath SelectData_MemFP(
    input
        BypassSelect sel,
        BypassOperand memMA [ LOAD_ISSUE_WIDTH ],
        BypassOperand memWB [ LOAD_ISSUE_WIDTH ],
`ifdef RSD_MARCH_LOW_LATENCY_FP
        BypassOperand fpEX0 [ FP_ISSUE_WIDTH ],
        BypassOperand fpEX1 [ FP_ISSUE_WIDTH ],
        BypassOperand fpEX2 [ FP_ISSUE_WIDTH ],
        BypassOperand fpEX3 [ FP_ISSUE_WIDTH ],
`endif
        BypassOperand fpEX4 [ FP_ISSUE_WIDTH ],
        BypassOperand fpWB [ FP_ISSUE_WIDTH ]
    );
        if( sel.stg == BYPASS_STAGE_MEM_MA )
            return memMA[sel.lane.memLane].value;
        else   if( sel.stg == BYPASS_STAGE_MEM_WB )
            return memWB[sel.lane.memLane].value;
`ifdef RSD_MARCH_LOW_LATENCY_FP
        else   if( sel.stg == BYPASS_STAGE_FP_EX0 )
            return fpEX0[sel.lane.fpLane].value;
        else   if( sel.stg == BYPASS_STAGE_FP_EX1 )
            return fpEX1[sel.lane.fpLane].value;
        else   if( sel.stg == BYPASS_STAGE_FP_EX2 )
            return fpEX2[sel.lane.fpLane].value;
        else   if( sel.stg == BYPASS_STAGE_FP_EX3 )
            return fpEX3[sel.lane.fpLane].value;
`endif
        else   if( sel.stg == BYPASS_STAGE_FP_EX4 )
            return fpEX4[sel.lane.fpLane].value;
        else   if( sel.stg == BYPASS_STAGE_FP_WB )
            return fpWB[sel.lane.fpLane].value;
        else 
            return '0;
    endfunction
`endif
`endif

    BypassOperand intDst [ INT_ISSUE_WIDTH ];
    BypassOperand intEX  [ INT_ISSUE_WIDTH ];
    BypassOperand intWB  [ INT_ISSUE_WIDTH ];
    BypassOperand memDst [ LOAD_ISSUE_WIDTH ];
    BypassOperand memMA  [ LOAD_ISSUE_WIDTH ];
    BypassOperand memWB  [ LOAD_ISSUE_WIDTH ];
`ifdef RSD_MARCH_BYPASS_COMPLEX_FP
    BypassOperand complexDst [ COMPLEX_ISSUE_WIDTH ];
    BypassOperand complexEX2  [ COMPLEX_ISSUE_WIDTH ];
    BypassOperand complexWB  [ COMPLEX_ISSUE_WIDTH ];
`ifdef RSD_MARCH_FP_PIPE
    BypassOperand fpDst [ FP_ISSUE_WIDTH ];
    BypassOperand fpEX4  [ FP_ISSUE_WIDTH ];
    BypassOperand fpWB  [ FP_ISSUE_WIDTH ];
`ifdef RSD_MARCH_LOW_LATENCY_FP
    BypassOperand fpDst_0 [ FP_ISSUE_WIDTH ];
    BypassOperand fpDst_2 [ FP_ISSUE_WIDTH ];
    BypassOperand fpEX0  [ FP_ISSUE_WIDTH ];
    BypassOperand fpEX1  [ FP_ISSUE_WIDTH ];
    BypassOperand fpEX2  [ FP_ISSUE_WIDTH ];
    BypassOperand fpEX3  [ FP_ISSUE_WIDTH ];
`endif
`endif
`endif
    generate 
        for ( genvar i = 0; i < INT_ISSUE_WIDTH; i++ ) begin : stgInt
            BypassStage stgIntEX( port.clk, port.rst, ctrl.backEnd, intDst[i], intEX[i] );
            BypassStage stgIntWB( port.clk, port.rst, ctrl.backEnd, intEX[i],  intWB[i] );
        end
        
        for ( genvar i = 0; i < LOAD_ISSUE_WIDTH; i++ ) begin : stgMem
            BypassStage stgMemMA( port.clk, port.rst, ctrl.backEnd, memDst[i], memMA[i] );
            BypassStage stgMemWB( port.clk, port.rst, ctrl.backEnd, memMA[i],  memWB[i] );
        end
        
`ifdef RSD_MARCH_BYPASS_COMPLEX_FP
        for ( genvar i = 0; i < COMPLEX_ISSUE_WIDTH; i++ ) begin : stgComplex
            BypassStage stgComplexEX2( port.clk, port.rst, ctrl.backEnd, complexDst[i], complexEX2[i] );
            BypassStage stgComplexWB( port.clk, port.rst, ctrl.backEnd, complexEX2[i],  complexWB[i] );
        end
        
`ifdef RSD_MARCH_FP_PIPE
        for ( genvar i = 0; i < FP_ISSUE_WIDTH; i++ ) begin : stgFP
`ifdef RSD_MARCH_LOW_LATENCY_FP
            BypassStage stgFPEX0( port.clk, port.rst, ctrl.backEnd, fpDst_0[i], fpEX0[i] );
            BypassStage stgFPEX1( port.clk, port.rst, ctrl.backEnd, fpEX0[0], fpEX1[i] );
            BypassStage stgFPEX2( port.clk, port.rst, ctrl.backEnd, fpDst_2[i], fpEX2[i] );
            BypassStage stgFPEX3( port.clk, port.rst, ctrl.backEnd, fpEX2[0], fpEX3[i] );
`endif
            BypassStage stgFPEX4( port.clk, port.rst, ctrl.backEnd, fpDst[i], fpEX4[i] );
            BypassStage stgFPWB( port.clk, port.rst, ctrl.backEnd, fpEX4[i],  fpWB[i] );
        end
`endif
`endif
    endgenerate
    
    always_comb begin

        for ( int i = 0; i < INT_ISSUE_WIDTH; i++ ) begin
            intDst[i].value = port.intDstRegDataOut[i];
`ifndef RSD_MARCH_BYPASS_COMPLEX_FP            
            port.intSrcRegDataOutA[i] = SelectData( port.intCtrlIn[i].rA,   intEX, intWB, memMA, memWB );
            port.intSrcRegDataOutB[i] = SelectData( port.intCtrlIn[i].rB,   intEX, intWB, memMA, memWB );
`else
`ifdef RSD_MARCH_FP_PIPE
`ifndef RSD_MARCH_LOW_LATENCY_FP
            port.intSrcRegDataOutA[i] = SelectData_IntComplexMemFP( port.intCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
            port.intSrcRegDataOutB[i] = SelectData_IntComplexMemFP( port.intCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
`else
            port.intSrcRegDataOutA[i] = SelectData_IntComplexMemFP( port.intCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
            port.intSrcRegDataOutB[i] = SelectData_IntComplexMemFP( port.intCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
`endif
`else
            port.intSrcRegDataOutA[i] = SelectData_IntComplexMem( port.intCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB );
            port.intSrcRegDataOutB[i] = SelectData_IntComplexMem( port.intCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB );
`endif
`endif
        end
        
`ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
        for ( int i = 0; i < COMPLEX_ISSUE_WIDTH; i++ ) begin
`ifndef RSD_MARCH_BYPASS_COMPLEX_FP            
            port.complexSrcRegDataOutA[i] = SelectData( port.complexCtrlIn[i].rA,   intEX, intWB, memMA, memWB );
            port.complexSrcRegDataOutB[i] = SelectData( port.complexCtrlIn[i].rB,   intEX, intWB, memMA, memWB );
`else
            complexDst[i].value = port.complexDstRegDataOut[i];
`ifdef RSD_MARCH_FP_PIPE
`ifndef RSD_MARCH_LOW_LATENCY_FP
            port.complexSrcRegDataOutA[i] = SelectData_IntComplexMemFP( port.complexCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
            port.complexSrcRegDataOutB[i] = SelectData_IntComplexMemFP( port.complexCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
`else
            port.complexSrcRegDataOutA[i] = SelectData_IntComplexMemFP( port.complexCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
            port.complexSrcRegDataOutB[i] = SelectData_IntComplexMemFP( port.complexCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
`endif
`else
            port.complexSrcRegDataOutA[i] = SelectData_IntComplexMem( port.complexCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB );
            port.complexSrcRegDataOutB[i] = SelectData_IntComplexMem( port.complexCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB );
`endif
`endif
        end
`endif
        
        for ( int i = 0; i < LOAD_ISSUE_WIDTH; i++ ) begin
            memDst[i].value = port.memDstRegDataOut[i];
        end
            
        for ( int i = 0; i < MEM_ISSUE_WIDTH; i++ ) begin
`ifndef RSD_MARCH_BYPASS_COMPLEX_FP
            port.memSrcRegDataOutA[i] = SelectData( port.memCtrlIn[i].rA,   intEX, intWB, memMA, memWB );
            port.memSrcRegDataOutB[i] = SelectData( port.memCtrlIn[i].rB,   intEX, intWB, memMA, memWB );
`else
`ifdef RSD_MARCH_FP_PIPE
`ifndef RSD_MARCH_LOW_LATENCY_FP
            port.memSrcRegDataOutA[i] = SelectData_IntComplexMemFP( port.memCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
            port.memSrcRegDataOutB[i] = SelectData_IntComplexMemFP( port.memCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
`else
            port.memSrcRegDataOutA[i] = SelectData_IntComplexMemFP( port.memCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
            port.memSrcRegDataOutB[i] = SelectData_IntComplexMemFP( port.memCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
`endif
`else
            port.memSrcRegDataOutA[i] = SelectData_IntComplexMem( port.memCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB );
            port.memSrcRegDataOutB[i] = SelectData_IntComplexMem( port.memCtrlIn[i].rB,   intEX, intWB, memMA, memWB, complexEX2, complexWB);
`endif
`endif
        end

`ifdef RSD_MARCH_FP_PIPE
        for ( int i = 0; i < FP_ISSUE_WIDTH; i++ ) begin
`ifndef RSD_MARCH_BYPASS_COMPLEX_FP
            port.fpSrcRegDataOutA[i] = SelectData( port.fpCtrlIn[i].rA,   intEX, intWB, memMA, memWB );
            port.fpSrcRegDataOutB[i] = SelectData( port.fpCtrlIn[i].rB,   intEX, intWB, memMA, memWB );
            port.fpSrcRegDataOutC[i] = SelectData( port.fpCtrlIn[i].rC,   intEX, intWB, memMA, memWB );
`else
            fpDst[i].value = port.fpDstRegDataOut[i];
`ifndef RSD_MARCH_LOW_LATENCY_FP
            port.fpSrcRegDataOutA[i] = SelectData_IntComplexMemFP( port.fpCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
            port.fpSrcRegDataOutB[i] = SelectData_MemFP( port.fpCtrlIn[i].rB,   memMA, memWB, fpEX4, fpWB );
            port.fpSrcRegDataOutC[i] = SelectData_MemFP( port.fpCtrlIn[i].rC,   memMA, memWB, fpEX4, fpWB );
`else
            fpDst_0[i].value = port.fpDstRegDataOut[i+FP_ISSUE_WIDTH];
            fpDst_2[i].value = port.fpDstRegDataOut[i+FP_ISSUE_WIDTH*2];
            port.fpSrcRegDataOutA[i] = SelectData_IntComplexMemFP( port.fpCtrlIn[i].rA,   intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
            port.fpSrcRegDataOutB[i] = SelectData_MemFP( port.fpCtrlIn[i].rB,   memMA, memWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
            port.fpSrcRegDataOutC[i] = SelectData_MemFP( port.fpCtrlIn[i].rC,   memMA, memWB, fpEX0, fpEX1, fpEX2, fpEX3, fpEX4, fpWB );
`endif
`endif
        end
`endif
    end

endmodule : BypassNetwork

