// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


//
// --- PerformanceCounterIF
//

import BasicTypes::*;
import DebugTypes::*;

interface PerformanceCounterIF( input logic clk, rst );
    
`ifndef RSD_DISABLE_PERFORMANCE_COUNTER
    
    // Hardware counter exported to CSR
    PerfCounterPath perfCounter;
    
    // I Cache misses
    logic icMiss;

    // D cache misses
    logic loadMiss[LOAD_ISSUE_WIDTH];
    logic storeMiss[STORE_ISSUE_WIDTH];
    
    // Speculative memory access
    logic storeLoadForwardingFail;
    logic memDepPredMiss;

    // Branch prediction miss
    logic branchPredMiss;
    logic branchPredMissDetectedOnDecode;

    // Stall
    logic rnStageSendBubbleLower;
    logic isStageStallUpper;
    logic stallByScheduler;
    logic stallByActiveList;
    logic stallByLoadStoreQueue;
    logic inRecovery;
    
    modport PerformanceCounter (
    input
        clk,
        rst,
        icMiss,
        loadMiss,
        storeMiss,
        storeLoadForwardingFail,
        memDepPredMiss,
        branchPredMiss,
        branchPredMissDetectedOnDecode,
        rnStageSendBubbleLower,
        isStageStallUpper,
        stallByScheduler,
        stallByActiveList,
        stallByLoadStoreQueue,
        inRecovery,
    output
        perfCounter
    );

    modport FetchStage(
    output
        icMiss
    );

    modport DecodeStage(
    output
        branchPredMissDetectedOnDecode
    );

    modport RenameStage(
    output
        stallByScheduler,
        stallByActiveList,
        stallByLoadStoreQueue
    );

    modport MemoryTagAccessStage (
    output
        loadMiss
    );
    
    modport RecoveryManager (
    output
        storeLoadForwardingFail,
        memDepPredMiss,
        branchPredMiss,
        inRecovery
    );

    modport StoreCommitter (
    output
        storeMiss
    );

    modport CSR (
    input
        perfCounter
    );
    
    modport Controller (
    input
        rnStageSendBubbleLower,
        isStageStallUpper
    );

`else
    // Dummy to suppress warning.
    PerfCounterPath perfCounter;

    modport PerformanceCounter (
    input
        clk,
    output
        perfCounter
    );
    
    modport FetchStage(input clk);
    modport DecodeStage(input clk);
    modport RenameStage(input clk);
    modport LoadStoreUnit(input clk);
    modport MemoryTagAccessStage(input clk);
    modport RecoveryManager(input clk);
    modport CSR(input clk);
    modport StoreCommitter(input clk);
`endif


endinterface : PerformanceCounterIF
