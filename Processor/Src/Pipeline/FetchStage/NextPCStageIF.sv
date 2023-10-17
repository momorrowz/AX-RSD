// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


//
// --- NextPCStageIF
//

import BasicTypes::*;
import PipelineTypes::*;
import FetchUnitTypes::*;
import MemoryMapTypes::*;

interface NextPCStageIF( input logic clk, rst, rstStart );
    
    // PC
    logic    pcWE;
    PC_Path  pcOut;
    PC_Path  pcIn;

    PC_Path  predNextPC;

    // Executed branch results for updating a branch predictor.
    // This signal is written back from a write back stage.
    BranchResult brResult[ INT_ISSUE_WIDTH ];
    // BranchResult brcycResult[ INT_ISSUE_WIDTH ];
    logic recoverBrHistory;
    BranchGlobalHistoryPath recoveredBrHistory;
    RAS_CheckpointData recoveredRasCheckpoint;

    // Interrupt
    PC_Path interruptAddrIn;
    logic interruptAddrWE;

    // I-cache
    PhyAddrPath   icNextReadAddrIn; // Value of icReadAddrIn in next cycle.

    // Pipeline register
    FetchStageRegPath nextStage[ FETCH_WIDTH ];

    modport PC(
    input
        clk, rst, pcWE, pcIn,
    output
        pcOut
    );

    modport ThisStage(
    input
        clk,
        rst,
        pcOut,
        brResult,
        interruptAddrIn,
        interruptAddrWE,
    output
        pcWE,
        pcIn,
        predNextPC,
        icNextReadAddrIn,
        nextStage,
        recoverBrHistory,
        recoveredBrHistory,
        recoveredRasCheckpoint
    );

    modport NextStage(
    input
        predNextPC,
        nextStage
    );

    modport IntegerRegisterWriteStage(
    output
        brResult
    );

     modport RAS(
    input
        clk,
        rst,
        predNextPC,
        recoverBrHistory,
        recoveredRasCheckpoint
    );

    modport BTB(
    input
        clk,
        rst,
        rstStart,
        predNextPC,
        brResult
    );

    modport AXBTB(
    input
        clk,
        rst,
        rstStart,
        predNextPC,
        brResult
    );

    modport BUFFER(
    input
        clk,
        rst,
        rstStart,
        predNextPC,
        brResult
    );

    modport AXBrCycBTB(
    input
        clk,
        rst,
        rstStart,
        predNextPC,
        brResult
    );

    modport BranchPredictor(
    input
        clk,
        rst,
        rstStart,
        predNextPC,
        brResult,
        recoverBrHistory,
        recoveredBrHistory
    );

    modport BranchDecider(
    input
        clk,
        rst,
        rstStart,
        predNextPC,
        brResult
    );

    modport BranchDeciderCycle(
    input
        clk,
        rst,
        rstStart,
        predNextPC,
        brResult
    );

    modport ICache(
    input
        clk,
        rst,
        rstStart,
        icNextReadAddrIn
    );

    modport InterruptController(
    input
        pcOut,
    output
        interruptAddrIn,
        interruptAddrWE
    );


endinterface : NextPCStageIF
