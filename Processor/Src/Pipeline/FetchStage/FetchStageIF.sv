// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


//
// --- FetchStageIF
//

import BasicTypes::*;
import PipelineTypes::*;
import FetchUnitTypes::*;
import MemoryMapTypes::*;

interface FetchStageIF( input logic clk, rst, rstStart );

    // This Stage
    logic  fetchStageIsValid[FETCH_WIDTH];
    PC_Path fetchStagePC[FETCH_WIDTH];

    // BTB
    PC_Path btbOut[FETCH_WIDTH];
    logic btbHit[FETCH_WIDTH];
    logic readIsCondBr[FETCH_WIDTH];
    logic readIsRASPushBr[FETCH_WIDTH];
    logic readIsRASPopBr[FETCH_WIDTH];

    // RAS
    PC_Path rasOut[FETCH_WIDTH];
    RAS_CheckpointData rasCheckpoint[FETCH_WIDTH];  


    //AXBTB
    PC_Path axbtbOut[FETCH_WIDTH];
    logic axbtbHit[FETCH_WIDTH];

    // BUFFER
    PC_Path bufferOut[FETCH_WIDTH];
    logic bufferHit[FETCH_WIDTH];


    //AXBrCycBTB
    PC_Path axbrcycbtbOut[FETCH_WIDTH];
    logic axbrcycbtbHit[FETCH_WIDTH];
    
    // BranchPredictor
    logic updateBrHistory[FETCH_WIDTH];
    logic brPredTaken[FETCH_WIDTH];
    BranchGlobalHistoryPath brGlobalHistory[FETCH_WIDTH];
    PHT_IndexPath phtIndex[FETCH_WIDTH];
    PHT_EntryPath phtPrevValue[FETCH_WIDTH];

    // BranchDecider
    logic brDecidTaken[FETCH_WIDTH];

    // BranchDeciderCycle
    logic brDecidCycTaken[FETCH_WIDTH];

    // I-Cache
    logic     icReadHit [ FETCH_WIDTH ];
    logic     icRE;
    InsnPath  icReadDataOut[ FETCH_WIDTH ];
    PhyAddrPath   icReadAddrIn; // Head addr to fetch

    // Pipeline register
    PreDecodeStageRegPath nextStage[ FETCH_WIDTH ];

    modport ThisStage(
    input
        clk,
        rst,
        icReadHit,
        icReadDataOut,
        btbOut,
        btbHit,
        brPredTaken,
        brGlobalHistory,
        phtIndex,
        phtPrevValue,
        rasCheckpoint,
        axbtbOut,
        brDecidTaken,
    output
        fetchStageIsValid,
        fetchStagePC,
        updateBrHistory,
        nextStage,
        icRE,
        icReadAddrIn
    );

    modport NextPCStage(
    input
        fetchStageIsValid,
        fetchStagePC,
        btbOut,
        btbHit,
        readIsRASPopBr,
        rasOut,
        brPredTaken,
        axbtbOut,
        axbtbHit,
        brDecidTaken
    );

    modport NextStage(
    input
        nextStage
    );

    modport ICache(
    input
        icRE, // Read Enable
        icReadAddrIn,
    output
        icReadHit,
        icReadDataOut
    );

    modport BTB(
    output
        btbOut,
        btbHit,
        readIsCondBr,
        readIsRASPushBr,
        readIsRASPopBr
    );

    modport RAS(
    input
        fetchStageIsValid,
        fetchStagePC,
        btbHit,
        readIsRASPushBr,
        readIsRASPopBr,
        brPredTaken,
    output
        rasOut,
        rasCheckpoint

    );

    modport AXBTB(
    output
        axbtbOut,
        axbtbHit
    );

    modport BUFFER(
    output
        bufferOut,
        bufferHit
    );
    
    modport AXBrCycBTB(
    output
        axbrcycbtbOut,
        axbrcycbtbHit
    );

    modport BranchPredictor(
    input
        updateBrHistory,
        btbOut,
        btbHit,
        readIsCondBr,
    output
        brPredTaken,
        brGlobalHistory,
        phtIndex,
        phtPrevValue
    );

    modport BranchDecider(
    input
        axbtbHit,
        brPredTaken,
    output
        brDecidTaken
    );

    modport BranchDeciderCycle(
    input
        axbrcycbtbHit,
        brPredTaken,
    output
        brDecidCycTaken
    );

    modport BeginCyleCount(
    input
        bufferHit
    );

endinterface : FetchStageIF
