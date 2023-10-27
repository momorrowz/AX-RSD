// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


// 
// --- Fetch unit types
//

package FetchUnitTypes;

import MicroArchConf::*;
import BasicTypes::*;
import MemoryMapTypes::*;

//
// BTB
//

localparam BTB_ENTRY_NUM = CONF_BTB_ENTRY_NUM;
localparam AXBTB_ENTRY_NUM = CONF_AXBTB_ENTRY_NUM;

// Entry: 1(valid)+4(BTB_TAG_WIDTH)+13(BTB_TAG_WIDTH) = 18 bits
// The width of a block ram is 18bits, thus the sum of these parameters is set to 18 bits.

// Tag width, only lower bits are checked and the results of the BTB may incorrect.
localparam BTB_TAG_WIDTH = 4;
localparam AXBLTCYCBTB_TAG_WIDTH = 8;                

// BTB have bits with BTB_CONTENTS_ADDR_WIDTH. The remaining address bits are made from the PC.
localparam BTB_CONTENTS_ADDR_WIDTH = 13;     

localparam BUFFER_TAG_WIDTH = BTB_TAG_WIDTH + BTB_CONTENTS_ADDR_WIDTH;

localparam BTB_ENTRY_NUM_BIT_WIDTH = $clog2(BTB_ENTRY_NUM);
localparam AXBTB_ENTRY_NUM_BIT_WIDTH = $clog2(AXBTB_ENTRY_NUM);
typedef logic [BTB_ENTRY_NUM_BIT_WIDTH-1:0] BTB_IndexPath;
typedef logic [AXBTB_ENTRY_NUM_BIT_WIDTH-1:0] AXBTB_IndexPath;
typedef logic [BTB_CONTENTS_ADDR_WIDTH-1:0] BTB_AddrPath;
typedef logic [BTB_TAG_WIDTH-1:0] BTB_TagPath;
typedef logic [BUFFER_TAG_WIDTH-1:0] BUFFER_TagPath;


localparam BTB_QUEUE_SIZE = 32;
localparam BTB_QUEUE_SIZE_BIT_WIDTH = $clog2(BTB_QUEUE_SIZE);
typedef logic [BTB_QUEUE_SIZE_BIT_WIDTH-1:0] BTBQueuePointerPath;

typedef struct packed // struct BTB_Entry
{
    logic valid;
    logic [BTB_TAG_WIDTH-1:0] tag;
    BTB_AddrPath data;
    logic isCondBr;
    logic isRASPushBr;
    logic isRASPopBr;
} BTB_Entry;

typedef struct packed // struct AXBTB_Entry
{
    logic valid;
    logic [BTB_TAG_WIDTH-1:0] tag;
    BTB_AddrPath data;
} AXBTB_Entry;

typedef struct packed // struct AXBLTCYCBTB_Entry
{
    logic valid;
    logic [AXBLTCYCBTB_TAG_WIDTH-1:0] tag;
    BTB_AddrPath data;
} AXBLTCYCBTB_Entry;

typedef struct packed // struct Buffer_Entry
{
    logic valid;
    logic [BUFFER_TAG_WIDTH-1:0] tag;
} Buffer_Entry;

typedef struct packed // struct PhtQueueEntry
{
    AddrPath wa;            // Write Address
    BTB_Entry wv;                        // result of bpred
} BTBQueueEntry;

typedef struct packed // struct Buffer_Entry
{
    AddrPath wa;
    Buffer_Entry wv;
} BufferQueueEntry;

function automatic BTB_IndexPath ToBTB_Index(PC_Path addr);
    return addr[
        BTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH - 1: 
        INSN_ADDR_BIT_WIDTH
    ];
endfunction

function automatic AXBTB_IndexPath ToAXBTB_Index(PC_Path addr);
    return addr[
        AXBTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH - 1: 
        INSN_ADDR_BIT_WIDTH
    ];
endfunction

function automatic BTB_TagPath ToBTB_Tag(PC_Path addr);
    return addr[
        BTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH + BTB_TAG_WIDTH - 1:
        BTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH
    ];
endfunction

function automatic BTB_TagPath ToAXBTB_Tag(PC_Path addr);
    return addr[
        AXBTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH + BTB_TAG_WIDTH - 1:
        AXBTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH
    ];
endfunction

function automatic BTB_TagPath ToAXBLTCYCBTB_Tag(PC_Path addr);
    return addr[
        AXBTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH + AXBLTCYCBTB_TAG_WIDTH - 1:
        AXBTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH
    ];
endfunction

function automatic BUFFER_TagPath ToBUFFER_Tag(PC_Path addr);
    return addr[
        AXBTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH + BUFFER_TAG_WIDTH - 1:
        AXBTB_ENTRY_NUM_BIT_WIDTH + INSN_ADDR_BIT_WIDTH
    ];
endfunction

function automatic BTB_AddrPath ToBTB_Addr(PC_Path addr);
    return addr[
        INSN_ADDR_BIT_WIDTH + BTB_CONTENTS_ADDR_WIDTH - 1:
        INSN_ADDR_BIT_WIDTH
    ];
endfunction

function automatic PC_Path ToRawAddrFromBTB_Addr(BTB_AddrPath addr, PC_Path pc);
    return 
    {
        pc[PC_WIDTH-1 : BTB_CONTENTS_ADDR_WIDTH + 2],
        addr[BTB_CONTENTS_ADDR_WIDTH-1 : 0],
        2'b0
    };
endfunction

///
/// RAS
//

localparam RAS_ENTRY_NUM = CONF_RAS_ENTRY_NUM;
localparam RAS_ENTRY_NUM_BIT_WIDTH = $clog2(RAS_ENTRY_NUM);
typedef logic [RAS_ENTRY_NUM_BIT_WIDTH-1:0] RAS_IndexPath;
typedef struct packed // struct RAS_CheckpointData
{
    RAS_IndexPath stackTopPtr;
    RAS_IndexPath queueTailPtr;
} RAS_CheckpointData;


//
// GShare
//

localparam BRANCH_GLOBAL_HISTORY_BIT_WIDTH = CONF_BRANCH_GLOBAL_HISTORY_BIT_WIDTH;
typedef logic [BRANCH_GLOBAL_HISTORY_BIT_WIDTH-1 : 0] BranchGlobalHistoryPath;


//
// PHT
//

localparam PHT_ENTRY_NUM = CONF_PHT_ENTRY_NUM;
localparam PHT_ENTRY_NUM_BIT_WIDTH = $clog2(PHT_ENTRY_NUM);
typedef logic [PHT_ENTRY_NUM_BIT_WIDTH-1:0] PHT_IndexPath;

localparam PHT_ENTRY_WIDTH = 2;
localparam PHT_ENTRY_MAX = (1 << PHT_ENTRY_WIDTH) - 1;
typedef logic [PHT_ENTRY_WIDTH-1:0] PHT_EntryPath;


localparam PHT_QUEUE_SIZE = 32;
localparam PHT_QUEUE_SIZE_BIT_WIDTH = $clog2(PHT_QUEUE_SIZE);
typedef logic [PHT_QUEUE_SIZE_BIT_WIDTH-1:0] PhtQueuePointerPath;

typedef struct packed // struct PhtQueueEntry
{
    AddrPath wa;            // Write Address
    PHT_EntryPath wv;    // result of bpred
} PhtQueueEntry;

localparam IS_BANK_CONFLICT_BANK_NUM = FETCH_WIDTH > INT_ISSUE_WIDTH ? FETCH_WIDTH : INT_ISSUE_WIDTH;
localparam IS_BANK_CONFLICT_BANK_NUM_BIT_WIDTH = $clog2(IS_BANK_CONFLICT_BANK_NUM);
function automatic logic IsBankConflict(PHT_IndexPath addr1, PHT_IndexPath addr2);
    if (addr1[IS_BANK_CONFLICT_BANK_NUM_BIT_WIDTH-1:0] == addr2[IS_BANK_CONFLICT_BANK_NUM_BIT_WIDTH-1:0]) begin
        return TRUE;
    end
    else begin
        return FALSE;
    end
endfunction

//
// BranchDecider
//

localparam AX_LEVEL_WIDTH = CONF_AX_LEVEL_WIDTH;
localparam LFSR_WIDTH = CONF_LFSR_WIDTH;
localparam LFSR_SEED = CONF_LFSR_SEED;
typedef logic [LFSR_WIDTH-1:0] LFSRDataPath;

//
// Result/prediction
//

typedef struct packed // struct BranchResult
{
    PC_Path brAddr;     // The address of a executed branch.
    PC_Path nextAddr;   // The next address of a executed branch.
    logic execTaken;    // The execution result of a branch's direction.
    logic predTaken;    // The prediction result of a branch's direction.
    logic isCondBr;     // Whether this branch is conditional one or not.
    logic isRASPushBr;  // Whether this branch is call or not. (TODO: coroutine call)
    logic isRASPopBr;   // Whether this branch is return one or not. (TODO: coroutine call)
    logic mispred;      // Whether the prediction result of this branch is incorrect.
    logic valid;        // Whether this result is valid or not.

    BranchGlobalHistoryPath globalHistory;  // The global history of branches.
    PHT_IndexPath phtIndex;                 // PHT index used for update
    PHT_EntryPath phtPrevValue;             // PHT's counter value
    RAS_CheckpointData rasCheckpoint;       // RAS's top&tail pointer
    logic isApBr;          // Whether this branch is ap.branch.
    logic decidTaken;      // Whether ap.branch is taken or not.
    logic isApBLTCyc;                       // Whether this branch is ap.bltcycle.
    logic isApBCC;    // Whether this branch is ap.bltcycle.
    logic bufHit;                        // Whether buffer is hit or not.
    logic decidCycTaken;    // Whether ap.bltcycle is taken or not.
} BranchResult;

typedef struct packed // struct BranchPred
{
    PC_Path predAddr;            // Predicted address
    logic predTaken;                        // result of bpred
    
    BranchGlobalHistoryPath globalHistory;  // The global history of branches.
    PHT_IndexPath phtIndex;                 // PHT index used for the prediction
    PHT_EntryPath phtPrevValue;             // PHT's counter value
    RAS_CheckpointData rasCheckpoint;       // RAS's top&tail pointer
    logic isApBr;                           // Whether this branch is ap.branch.
    logic isApBLT;                          // Whether this branch is ap.blt.
    logic isApBLTCyc;                       // Whether this branch is ap.bltcycle.
    logic isApBCC;                          // Whether this is ap.begincyclecount.
    logic bufHit;                        // Whether buffer is hit or not.
    logic decidTaken;                       // Whether ap.branch is taken or not.
    logic decidCycTaken;    // Whether ap.bltcycle is taken or not.
} BranchPred;

endpackage : FetchUnitTypes
