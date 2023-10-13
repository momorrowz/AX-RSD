// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


//
// The interface of a CSR unit.
//


import BasicTypes::*;
import MemoryMapTypes::*;
import OpFormatTypes::*;
import MicroOpTypes::*;
import SchedulerTypes::*;
import ActiveListIndexTypes::*;
import CSR_UnitTypes::*;
import FetchUnitTypes::*;

interface CSR_UnitIF(
    input logic clk, rst, rstStart, reqExternalInterrupt, 
    ExternalInterruptCodePath externalInterruptCode,
    output logic [ AX_LEVEL_WIDTH-1:0 ] axLevel,     
    output DataPath axThreshold //approximate blt cycle
);

    logic csrWE;  // CSR write enable
    CSR_NumberPath csrNumber;   // CSR number
    CSR_Code csrCode;           // CSR operation code (ex. set, clear...)
    DataPath csrReadOut;        // a register value read from CSR 
    DataPath csrWriteIn;        // a value to be written to CSR
    CSR_BodyPath csrWholeOut;   // whole values of CSR

    // Exception = trap or fault
    // Trap request
    logic   triggerExcpt;
    ExecutionState excptCause;
    PC_Path excptCauseAddr;     // EBREAK/ECALL 時の mepc
    AddrPath excptTargetAddr;   // Trap vector or MRET return target
    AddrPath excptCauseDataAddr;     // fault 発生時のデータアドレス

    // Interrupt
    logic triggerInterrupt;
    CSR_CAUSE_InterruptCodePath interruptCode;
    PC_Path interruptRetAddr;

    // Timer interrupt request
    logic reqTimerInterrupt;

    // Latched code, see the cooments in the CSR.
    ExternalInterruptCodePath externalInterruptCodeInCSR;

    // Used in updating minstret
    CommitLaneCountPath commitNum;

`ifdef RSD_MARCH_FP_PIPE
    Rounding_Mode frm;
    logic fflagsWE;
    FFlags_Path fflagsData;
`endif

    modport MemoryExecutionStage(
    input
        clk, rst, rstStart,
        csrReadOut,
    output 
        csrWE,
        csrNumber,
        csrCode,
        csrWriteIn
    );

`ifdef RSD_MARCH_FP_PIPE
    modport FPExecutionStage(
    input
        frm
    );
`endif

    // 割り込みは以下の流れで要求が流れる
    // IO_Unit -> reqTimerInterrupt ->
    // CSR_Unit -> csrReg.mie.MTIE ->
    // InterruptController -> triggerInterrupt -> 
    // FetchStage and CSR_Unit
    modport IO_Unit(
    output 
        reqTimerInterrupt
    );

    // For counter update
    modport CommitStage (
    output
        commitNum
`ifdef RSD_MARCH_FP_PIPE
        ,
        fflagsWE,
        fflagsData
`endif
    );


    modport RecoveryManager(
    input
        excptTargetAddr,
    output
        triggerExcpt,
        excptCauseAddr,
        excptCause,
        excptCauseDataAddr
    );

    modport CSR_Unit(
    input
        clk, rst, rstStart,
        csrWE,
        csrNumber,
        csrCode,
        csrWriteIn,
        triggerExcpt,
        excptCauseAddr,
        excptCause,
        excptCauseDataAddr,
        commitNum,
        reqTimerInterrupt,
        reqExternalInterrupt,
        externalInterruptCode,
        triggerInterrupt,
        interruptCode,
        interruptRetAddr,
`ifdef RSD_MARCH_FP_PIPE
        fflagsWE,
        fflagsData,
`endif
    output 
`ifdef RSD_MARCH_FP_PIPE
        frm,
`endif
        csrWholeOut,
        csrReadOut,
        excptTargetAddr,
        externalInterruptCodeInCSR,
        axLevel
        axThreshold
    );

    modport InterruptController(
    input
        clk, rst, rstStart,
        csrWholeOut,
        externalInterruptCodeInCSR,
    output
        triggerInterrupt,
        interruptRetAddr,
        interruptCode
    );

endinterface
