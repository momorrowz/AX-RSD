// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


import BasicTypes::*;
import ActiveListIndexTypes::*;
import PipelineTypes::*;
import BypassTypes::*;

//
// --- Bypass controller
//
// BypassController outputs control information that controlls BypassNetwork.
// BypassController is connected to a register read stage.
//

typedef struct packed // struct BypassCtrlOperand
{
    PRegNumPath dstRegNum;
    logic writeReg;
} BypassCtrlOperand;


module BypassCtrlStage(
    input  logic clk, rst, 
    input  PipelineControll ctrl,
    input  BypassCtrlOperand in, 
    output BypassCtrlOperand out 
);
    BypassCtrlOperand body;
    
    always_ff@( posedge clk )               // synchronous rst 
    begin
        if( rst || ctrl.clear ) begin              // rst 
            body.dstRegNum <= 0;
            body.writeReg  <= FALSE;
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

module BypassController( 
    BypassNetworkIF.BypassController port,
    ControllerIF.BypassController ctrl
);

    function automatic BypassSelect SelectReg( 
    input
        PRegNumPath regNum,
        logic read,
        BypassCtrlOperand intEX [ INT_ISSUE_WIDTH ],
        BypassCtrlOperand intWB [ INT_ISSUE_WIDTH ],
        BypassCtrlOperand memMA [ LOAD_ISSUE_WIDTH ],
        BypassCtrlOperand memWB [ LOAD_ISSUE_WIDTH ]
    );
        BypassSelect ret;
        ret.valid = FALSE;
        //ret.stg = BYPASS_STAGE_DEFAULT;
        ret.stg = BYPASS_STAGE_INT_EX;
        ret.lane.intLane = 0;
        ret.lane.memLane = 0;
        // Not implemented 
        ret.lane.complexLane = 0; 
`ifdef RSD_MARCH_FP_PIPE
        ret.lane.fpLane = 0; 
`endif

        for ( int i = 0; i < INT_ISSUE_WIDTH; i++ ) begin
            if ( read && intEX[i].writeReg && regNum == intEX[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_INT_EX;
                ret.lane.intLane = i;
                break;
            end
            if ( read && intWB[i].writeReg && regNum == intWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_INT_WB;
                ret.lane.intLane = i;
                break;
            end
        end
        
        for ( int i = 0; i < LOAD_ISSUE_WIDTH; i++ ) begin
            if ( read && memMA[i].writeReg && regNum == memMA[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_MEM_MA;
                ret.lane.memLane = i;
                break;
            end
            if ( read && memWB[i].writeReg && regNum == memWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_MEM_WB;
                ret.lane.memLane = i;
                break;
            end
        end
        
        return ret;
    endfunction

`ifdef RSD_MARCH_BYPASS_COMPLEX_FP
    function automatic BypassSelect SelectReg_IntComplexMem( 
    input
        PRegNumPath regNum,
        logic read,
        BypassCtrlOperand intEX [ INT_ISSUE_WIDTH ],
        BypassCtrlOperand intWB [ INT_ISSUE_WIDTH ],
        BypassCtrlOperand memMA [ LOAD_ISSUE_WIDTH ],
        BypassCtrlOperand memWB [ LOAD_ISSUE_WIDTH ],
        BypassCtrlOperand complexEX2 [COMPLEX_ISSUE_WIDTH ],
        BypassCtrlOperand complexWB [ COMPLEX_ISSUE_WIDTH ]
    );
        BypassSelect ret;
        ret.valid = FALSE;
        //ret.stg = BYPASS_STAGE_DEFAULT;
        ret.stg = BYPASS_STAGE_INT_EX;
        ret.lane.intLane = 0;
        ret.lane.memLane = 0;
        // Not implemented 
        ret.lane.complexLane = 0; 
`ifdef RSD_MARCH_FP_PIPE
        ret.lane.fpLane = 0; 
`endif

        for ( int i = 0; i < INT_ISSUE_WIDTH; i++ ) begin
            if ( read && intEX[i].writeReg && regNum == intEX[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_INT_EX;
                ret.lane.intLane = i;
                break;
            end
            if ( read && intWB[i].writeReg && regNum == intWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_INT_WB;
                ret.lane.intLane = i;
                break;
            end
        end
        
        for ( int i = 0; i < LOAD_ISSUE_WIDTH; i++ ) begin
            if ( read && memMA[i].writeReg && regNum == memMA[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_MEM_MA;
                ret.lane.memLane = i;
                break;
            end
            if ( read && memWB[i].writeReg && regNum == memWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_MEM_WB;
                ret.lane.memLane = i;
                break;
            end
        end

        for ( int i = 0; i < COMPLEX_ISSUE_WIDTH; i++ ) begin
            if ( read && complexEX2[i].writeReg && regNum == complexEX2[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_COMPLEX_EX2;
                ret.lane.complexLane = i;
                break;
            end
            if ( read && complexWB[i].writeReg && regNum == complexWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_COMPLEX_WB;
                ret.lane.complexLane = i;
                break;
            end
        end
        
        return ret;
    endfunction

`ifdef RSD_MARCH_FP_PIPE
        function automatic BypassSelect SelectReg_IntComplexMemFP( 
    input
        PRegNumPath regNum,
        logic read,
        BypassCtrlOperand intEX [ INT_ISSUE_WIDTH ],
        BypassCtrlOperand intWB [ INT_ISSUE_WIDTH ],
        BypassCtrlOperand memMA [ LOAD_ISSUE_WIDTH ],
        BypassCtrlOperand memWB [ LOAD_ISSUE_WIDTH ],
        BypassCtrlOperand complexEX2 [COMPLEX_ISSUE_WIDTH ],
        BypassCtrlOperand complexWB [ COMPLEX_ISSUE_WIDTH ],
        BypassCtrlOperand fpEX4 [FP_ISSUE_WIDTH ],
        BypassCtrlOperand fpWB [ FP_ISSUE_WIDTH ]
    );
        BypassSelect ret;
        ret.valid = FALSE;
        //ret.stg = BYPASS_STAGE_DEFAULT;
        ret.stg = BYPASS_STAGE_INT_EX;
        ret.lane.intLane = 0;
        ret.lane.memLane = 0;
        // Not implemented 
        ret.lane.complexLane = 0; 
`ifdef RSD_MARCH_FP_PIPE
        ret.lane.fpLane = 0; 
`endif

        for ( int i = 0; i < INT_ISSUE_WIDTH; i++ ) begin
            if ( read && intEX[i].writeReg && regNum == intEX[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_INT_EX;
                ret.lane.intLane = i;
                break;
            end
            if ( read && intWB[i].writeReg && regNum == intWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_INT_WB;
                ret.lane.intLane = i;
                break;
            end
        end
        
        for ( int i = 0; i < LOAD_ISSUE_WIDTH; i++ ) begin
            if ( read && memMA[i].writeReg && regNum == memMA[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_MEM_MA;
                ret.lane.memLane = i;
                break;
            end
            if ( read && memWB[i].writeReg && regNum == memWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_MEM_WB;
                ret.lane.memLane = i;
                break;
            end
        end

        for ( int i = 0; i < COMPLEX_ISSUE_WIDTH; i++ ) begin
            if ( read && complexEX2[i].writeReg && regNum == complexEX2[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_COMPLEX_EX2;
                ret.lane.complexLane = i;
                break;
            end
            if ( read && complexWB[i].writeReg && regNum == complexWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_COMPLEX_WB;
                ret.lane.complexLane = i;
                break;
            end
        end

        for ( int i = 0; i < FP_ISSUE_WIDTH; i++ ) begin
            if ( read && fpEX4[i].writeReg && regNum == fpEX4[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_FP_EX4;
                ret.lane.fpLane = i;
                break;
            end
            if ( read && fpWB[i].writeReg && regNum == fpWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_FP_WB;
                ret.lane.fpLane = i;
                break;
            end
        end
        
        return ret;
    endfunction

        function automatic BypassSelect SelectReg_MemFP( 
    input
        PRegNumPath regNum,
        logic read,
        BypassCtrlOperand memMA [ LOAD_ISSUE_WIDTH ],
        BypassCtrlOperand memWB [ LOAD_ISSUE_WIDTH ],
        BypassCtrlOperand fpEX4 [ FP_ISSUE_WIDTH ],
        BypassCtrlOperand fpWB [ FP_ISSUE_WIDTH ]
    );
        BypassSelect ret;
        ret.valid = FALSE;
        //ret.stg = BYPASS_STAGE_DEFAULT;
        ret.stg = BYPASS_STAGE_INT_EX;
        ret.lane.intLane = 0;
        ret.lane.memLane = 0;
        // Not implemented 
        ret.lane.complexLane = 0; 
`ifdef RSD_MARCH_FP_PIPE
        ret.lane.fpLane = 0; 
`endif
        for ( int i = 0; i < LOAD_ISSUE_WIDTH; i++ ) begin
            if ( read && memMA[i].writeReg && regNum == memMA[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_MEM_MA;
                ret.lane.memLane = i;
                break;
            end
            if ( read && memWB[i].writeReg && regNum == memWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_MEM_WB;
                ret.lane.memLane = i;
                break;
            end
        end

        for ( int i = 0; i < FP_ISSUE_WIDTH; i++ ) begin
            if ( read && fpEX4[i].writeReg && regNum == fpEX4[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_FP_EX4;
                ret.lane.fpLane = i;
                break;
            end
            if ( read && fpWB[i].writeReg && regNum == fpWB[i].dstRegNum ) begin
                ret.valid = TRUE;
                ret.stg = BYPASS_STAGE_FP_WB;
                ret.lane.fpLane = i;
                break;
            end
        end
        
        return ret;
    endfunction
`endif
`endif

    logic clk, rst;
    
    assign clk = port.clk;
    assign rst = port.rst;
    
    //
    // Back-end Pipeline Structure
    //
    // Int:     IS RR EX WB
    // Complex: IS RR EX0 EX1 EX2 WB
    // Mem:     IS RR EX MT MA WB
    // FP:      IS RR EX0 EX1 EX2 EX3 EX4 WB
    BypassCtrlOperand intRR [ INT_ISSUE_WIDTH ];
    BypassCtrlOperand intEX [ INT_ISSUE_WIDTH ];
    BypassCtrlOperand intWB [ INT_ISSUE_WIDTH ];
    BypassCtrlOperand memRR [ LOAD_ISSUE_WIDTH ];
    BypassCtrlOperand memEX [ LOAD_ISSUE_WIDTH ];
    BypassCtrlOperand memMT [ LOAD_ISSUE_WIDTH ];
    BypassCtrlOperand memMA [ LOAD_ISSUE_WIDTH ];
    BypassCtrlOperand memWB [ LOAD_ISSUE_WIDTH ];
`ifdef RSD_MARCH_BYPASS_COMPLEX_FP
    BypassCtrlOperand complexRR [ COMPLEX_ISSUE_WIDTH ];
    BypassCtrlOperand complexEX0 [ COMPLEX_ISSUE_WIDTH ];
    BypassCtrlOperand complexEX1 [ COMPLEX_ISSUE_WIDTH ];
    BypassCtrlOperand complexEX2 [ COMPLEX_ISSUE_WIDTH ];
    BypassCtrlOperand complexWB [ COMPLEX_ISSUE_WIDTH ];
`ifdef RSD_MARCH_FP_PIPE
    BypassCtrlOperand fpRR [ FP_ISSUE_WIDTH ];
    BypassCtrlOperand fpEX0 [ FP_ISSUE_WIDTH ];
    BypassCtrlOperand fpEX1 [ FP_ISSUE_WIDTH ];
    BypassCtrlOperand fpEX2 [ FP_ISSUE_WIDTH ];
    BypassCtrlOperand fpEX3 [ FP_ISSUE_WIDTH ];
    BypassCtrlOperand fpEX4 [ FP_ISSUE_WIDTH ];
    BypassCtrlOperand fpWB [ FP_ISSUE_WIDTH ];
`endif
`endif

    for ( genvar i = 0; i < INT_ISSUE_WIDTH; i++ ) begin : stgInt
        BypassCtrlStage stgIntRR( clk, rst, ctrl.backEnd, intRR[i], intEX[i] );
        BypassCtrlStage stgIntEX( clk, rst, ctrl.backEnd, intEX[i], intWB[i] );
    end

    for ( genvar i = 0; i < LOAD_ISSUE_WIDTH; i++ ) begin : stgMem
        BypassCtrlStage stgMemRR( clk, rst, ctrl.backEnd, memRR[i], memEX[i] );
        BypassCtrlStage stgMemEX( clk, rst, ctrl.backEnd, memEX[i], memMT[i] );
        BypassCtrlStage stgMemMT( clk, rst, ctrl.backEnd, memMT[i], memMA[i] );
        BypassCtrlStage stgMemMA( clk, rst, ctrl.backEnd, memMA[i], memWB[i] );
    end
`ifdef RSD_MARCH_BYPASS_COMPLEX_FP
    for ( genvar i = 0; i < COMPLEX_ISSUE_WIDTH; i++ ) begin : stgcomplex
        BypassCtrlStage stgComplexRR( clk, rst, ctrl.backEnd, complexRR[i], complexEX0[i] );
        BypassCtrlStage stgComplexEX0( clk, rst, ctrl.backEnd, complexEX0[i], complexEX1[i] );
        BypassCtrlStage stgComplexEX1( clk, rst, ctrl.backEnd, complexEX1[i], complexEX2[i] );
        BypassCtrlStage stgComplexEX2( clk, rst, ctrl.backEnd, complexEX2[i], complexWB[i] );
    end
`ifdef RSD_MARCH_FP_PIPE
    for ( genvar i = 0; i < FP_ISSUE_WIDTH; i++ ) begin : stgfp
        BypassCtrlStage stgFPRR( clk, rst, ctrl.backEnd, fpRR[i], fpEX0[i] );
        BypassCtrlStage stgFPEX0( clk, rst, ctrl.backEnd, fpEX0[i], fpEX1[i] );
        BypassCtrlStage stgFPEX1( clk, rst, ctrl.backEnd, fpEX1[i], fpEX2[i] );
        BypassCtrlStage stgFPEX2( clk, rst, ctrl.backEnd, fpEX2[i], fpEX3[i] );
        BypassCtrlStage stgFPEX3( clk, rst, ctrl.backEnd, fpEX3[i], fpEX4[i] );
        BypassCtrlStage stgFPEX4( clk, rst, ctrl.backEnd, fpEX4[i], fpWB[i] );
    end
`endif
`endif
    
    BypassControll intBypassCtrl [ INT_ISSUE_WIDTH ];
`ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
    BypassControll complexBypassCtrl [ COMPLEX_ISSUE_WIDTH ];
`endif
    BypassControll memBypassCtrl [ MEM_ISSUE_WIDTH ];
`ifdef  RSD_MARCH_FP_PIPE
    BypassControll fpBypassCtrl [ FP_ISSUE_WIDTH ];
`endif

    always_comb begin
        for ( int i = 0; i < INT_ISSUE_WIDTH; i++ ) begin
            intRR[i].dstRegNum = port.intPhyDstRegNum[i];
            intRR[i].writeReg  = port.intWriteReg[i];

`ifndef RSD_MARCH_BYPASS_COMPLEX_FP
            intBypassCtrl[i].rA   = SelectReg ( port.intPhySrcRegNumA[i], port.intReadRegA[i], intEX, intWB, memMA, memWB );
            intBypassCtrl[i].rB   = SelectReg ( port.intPhySrcRegNumB[i], port.intReadRegB[i], intEX, intWB, memMA, memWB );
`else
`ifdef RSD_MARCH_FP_PIPE
            intBypassCtrl[i].rA   = SelectReg_IntComplexMemFP ( port.intPhySrcRegNumA[i], port.intReadRegA[i], intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
            intBypassCtrl[i].rB   = SelectReg_IntComplexMemFP ( port.intPhySrcRegNumB[i], port.intReadRegB[i], intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
`else
            intBypassCtrl[i].rA   = SelectReg_IntComplexMem ( port.intPhySrcRegNumA[i], port.intReadRegA[i], intEX, intWB, memMA, memWB, complexEX2, complexWB );
            intBypassCtrl[i].rB   = SelectReg_IntComplexMem ( port.intPhySrcRegNumB[i], port.intReadRegB[i], intEX, intWB, memMA, memWB, complexEX2, complexWB );
`endif
`endif
        end
        port.intCtrlOut = intBypassCtrl;

`ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
        for ( int i = 0; i < COMPLEX_ISSUE_WIDTH; i++ ) begin
`ifndef RSD_MARCH_BYPASS_COMPLEX_FP
            complexBypassCtrl[i].rA   = SelectReg ( port.complexPhySrcRegNumA[i], port.complexReadRegA[i], intEX, intWB, memMA, memWB );
            complexBypassCtrl[i].rB   = SelectReg ( port.complexPhySrcRegNumB[i], port.complexReadRegB[i], intEX, intWB, memMA, memWB );
`else
            complexRR[i].dstRegNum = port.complexPhyDstRegNum[i];
            complexRR[i].writeReg  = port.complexWriteReg[i];

`ifdef RSD_MARCH_FP_PIPE
            complexBypassCtrl[i].rA   = SelectReg_IntComplexMemFP ( port.complexPhySrcRegNumA[i], port.complexReadRegA[i], intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
            complexBypassCtrl[i].rB   = SelectReg_IntComplexMemFP ( port.complexPhySrcRegNumB[i], port.complexReadRegB[i], intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB);
`else
            complexBypassCtrl[i].rA   = SelectReg_IntComplexMem ( port.complexPhySrcRegNumA[i], port.complexReadRegA[i], intEX, intWB, memMA, memWB, complexEX2, complexWB );
            complexBypassCtrl[i].rB   = SelectReg_IntComplexMem ( port.complexPhySrcRegNumB[i], port.complexReadRegB[i], intEX, intWB, memMA, memWB, complexEX2, complexWB );
`endif
`endif
        end
        port.complexCtrlOut = complexBypassCtrl;
`endif

        for ( int i = 0; i < LOAD_ISSUE_WIDTH; i++ ) begin
            memRR[i].dstRegNum = port.memPhyDstRegNum[i];
            memRR[i].writeReg  = port.memWriteReg[i];
        end

        for ( int i = 0; i < MEM_ISSUE_WIDTH; i++ ) begin
`ifndef RSD_MARCH_BYPASS_COMPLEX_FP
            memBypassCtrl[i].rA   = SelectReg ( port.memPhySrcRegNumA[i], port.memReadRegA[i], intEX, intWB, memMA, memWB );
            memBypassCtrl[i].rB   = SelectReg ( port.memPhySrcRegNumB[i], port.memReadRegB[i], intEX, intWB, memMA, memWB );
`else
`ifdef RSD_MARCH_FP_PIPE
            memBypassCtrl[i].rA   = SelectReg_IntComplexMemFP ( port.memPhySrcRegNumA[i], port.memReadRegA[i], intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
            memBypassCtrl[i].rB   = SelectReg_IntComplexMemFP ( port.memPhySrcRegNumB[i], port.memReadRegB[i], intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
`else
            memBypassCtrl[i].rA   = SelectReg_IntComplexMem ( port.memPhySrcRegNumA[i], port.memReadRegA[i], intEX, intWB, memMA, memWB, complexEX2, complexWB );
            memBypassCtrl[i].rB   = SelectReg_IntComplexMem ( port.memPhySrcRegNumB[i], port.memReadRegB[i], intEX, intWB, memMA, memWB, complexEX2, complexWB );
`endif
`endif
        end
        port.memCtrlOut = memBypassCtrl;

`ifdef RSD_MARCH_FP_PIPE
        for ( int i = 0; i < FP_ISSUE_WIDTH; i++ ) begin
`ifndef RSD_MARCH_BYPASS_COMPLEX_FP
            fpBypassCtrl[i].rA   = SelectReg ( port.fpPhySrcRegNumA[i], port.fpReadRegA[i], intEX, intWB, memMA, memWB );
            fpBypassCtrl[i].rB   = SelectReg ( port.fpPhySrcRegNumB[i], port.fpReadRegB[i], intEX, intWB, memMA, memWB );
            fpBypassCtrl[i].rC   = SelectReg ( port.fpPhySrcRegNumC[i], port.fpReadRegC[i], intEX, intWB, memMA, memWB );
`else
            fpRR[i].dstRegNum = port.fpPhyDstRegNum[i];
            fpRR[i].writeReg  = port.fpWriteReg[i];
            fpBypassCtrl[i].rA   = SelectReg_IntComplexMemFP ( port.fpPhySrcRegNumA[i], port.fpReadRegA[i], intEX, intWB, memMA, memWB, complexEX2, complexWB, fpEX4, fpWB );
            fpBypassCtrl[i].rB   = SelectReg_MemFP ( port.fpPhySrcRegNumB[i], port.fpReadRegB[i], memMA, memWB, fpEX4, fpWB );
            fpBypassCtrl[i].rC   = SelectReg_MemFP ( port.fpPhySrcRegNumC[i], port.fpReadRegC[i], memMA, memWB, fpEX4, fpWB );
`endif
        end
        port.fpCtrlOut = fpBypassCtrl;
`endif
    end

endmodule : BypassController

