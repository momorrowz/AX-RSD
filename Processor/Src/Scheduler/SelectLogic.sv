// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


//
// Select logic
//

import BasicTypes::*;
import SchedulerTypes::*;



module SelectLogic(
    WakeupSelectIF.SelectLogic port,
    RecoveryManagerIF.SelectLogic recovery
);

    IssueQueueOneHotPath intRequest;
    IssueQueueOneHotPath intGrant[INT_ISSUE_WIDTH];
    logic intSelected[ INT_ISSUE_WIDTH ];
    IssueQueueIndexPath intSelectedPtr[ INT_ISSUE_WIDTH ];

`ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
    IssueQueueOneHotPath compRequest;
    IssueQueueOneHotPath compGrant[COMPLEX_ISSUE_WIDTH];
    logic compSelected[ COMPLEX_ISSUE_WIDTH ];
    IssueQueueIndexPath compSelectedPtr[ COMPLEX_ISSUE_WIDTH ];
`endif

`ifdef RSD_MARCH_UNIFIED_LDST_MEM_PIPE
    IssueQueueOneHotPath memRequest;
    IssueQueueOneHotPath memGrant[MEM_ISSUE_WIDTH];
    logic memSelected[ MEM_ISSUE_WIDTH ];
    IssueQueueIndexPath memSelectedPtr[ MEM_ISSUE_WIDTH ];
`else
    IssueQueueOneHotPath loadRequest;
    IssueQueueOneHotPath storeRequest;
    IssueQueueOneHotPath loadGrant[LOAD_ISSUE_WIDTH];
    IssueQueueOneHotPath storeGrant[STORE_ISSUE_WIDTH];
    logic loadSelected[ LOAD_ISSUE_WIDTH ];
    logic storeSelected[ STORE_ISSUE_WIDTH ];
    IssueQueueIndexPath loadSelectedPtr[ LOAD_ISSUE_WIDTH ];
    IssueQueueIndexPath storeSelectedPtr[ STORE_ISSUE_WIDTH ];
`endif

`ifdef RSD_MARCH_FP_PIPE
    IssueQueueOneHotPath fpRequest;
`ifdef RSD_MARCH_MULTIPLE_FP_ISSUE
    IssueQueueOneHotPath fpDivSqrtRequest;
    logic canIssueFPDivSqrt;
`endif
    IssueQueueOneHotPath fpGrant[FP_ISSUE_WIDTH];
    logic fpSelected[ FP_ISSUE_WIDTH ];
    IssueQueueIndexPath fpSelectedPtr[ FP_ISSUE_WIDTH ];
`endif


    // SelectLogic -> WakeupPipelineRegister
    logic portSelected [ ISSUE_WIDTH ];
    IssueQueueIndexPath portSelectedPtr [ ISSUE_WIDTH ];
    IssueQueueOneHotPath portSelectedVector [ ISSUE_WIDTH ];

    // For Recovery Maneger IF
    logic recoverySelected [ ISSUE_WIDTH ];
    IssueQueueIndexPath recoverySelectedPtr [ ISSUE_WIDTH ];

`ifdef CIRCULAR_SELECT_LOGIC
    IssueQueueIndexPath intPrePtr;
`ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
    IssueQueueIndexPath compPrePtr;
`endif
`ifdef RSD_MARCH_UNIFIED_LDST_MEM_PIPE
    IssueQueueIndexPath memPrePtr;
`else
    IssueQueueIndexPath loadPrePtr;
    IssueQueueIndexPath storePrePtr;
`endif
`endif

    // Requests are interleaved.
    // ex. ENTRY_NUM = 4, GRANT_NUM = 2 case:
    //   granted[0] = pick(req[0], req[2]);
    //   granted[0] = pick(req[1], req[3]);
    //
    // This makes its performance slightly worse, but reduces its complexity.
    //InterleavedPicker #(
`ifdef INT_INTERLEAVED_PICKER
    InterleavedPicker #(
`elsif CIRCULAR_SELECT_LOGIC
    CircularPicker #(
`else
    Picker #(
`endif
        .ENTRY_NUM(ISSUE_QUEUE_ENTRY_NUM),
        .GRANT_NUM(INT_ISSUE_WIDTH)
    )
    intPicker(
`ifdef CIRCULAR_SELECT_LOGIC
        .shiftAmount(intPrePtr),
`endif
        .req(intRequest),
        .grant(intGrant),
        .grantPtr(intSelectedPtr),
        .granted(intSelected)
    );


`ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
`ifdef CIRCULAR_SELECT_LOGIC
    CircularPicker #(
`else
    Picker #(
`endif
        .ENTRY_NUM(ISSUE_QUEUE_ENTRY_NUM),
        .GRANT_NUM(COMPLEX_ISSUE_WIDTH)
    )
    compPicker(
`ifdef CIRCULAR_SELECT_LOGIC
        .shiftAmount(compPrePtr),
`endif
        .req(compRequest),
        .grant(compGrant),
        .grantPtr(compSelectedPtr),
        .granted(compSelected)
    );
`endif

`ifdef RSD_MARCH_UNIFIED_LDST_MEM_PIPE
`ifdef CIRCULAR_SELECT_LOGIC
    CircularPicker #(
`else
    Picker #(
`endif
        .ENTRY_NUM(ISSUE_QUEUE_ENTRY_NUM),
        .GRANT_NUM(MEM_ISSUE_WIDTH)
    )
    storePicker(
`ifdef CIRCULAR_SELECT_LOGIC
        .shiftAmount(memPrePtr),
`endif
        .req(memRequest),
        .grant(memGrant),
        .grantPtr(memSelectedPtr),
        .granted(memSelected)
    );
`else
`ifdef CIRCULAR_SELECT_LOGIC
    CircularPicker #(
`else
    Picker #(
`endif
        .ENTRY_NUM(ISSUE_QUEUE_ENTRY_NUM),
        .GRANT_NUM(LOAD_ISSUE_WIDTH)
    )
    loadPicker(
`ifdef CIRCULAR_SELECT_LOGIC
        .shiftAmount(loadPrePtr),
`endif
        .req(loadRequest),
        .grant(loadGrant),
        .grantPtr(loadSelectedPtr),
        .granted(loadSelected)
    );
`ifdef CIRCULAR_SELECT_LOGIC
    CircularPicker #(
`else
    Picker #(
`endif
        .ENTRY_NUM(ISSUE_QUEUE_ENTRY_NUM),
        .GRANT_NUM(STORE_ISSUE_WIDTH)
    )
    storePicker(
`ifdef CIRCULAR_SELECT_LOGIC
        .shiftAmount(storePrePtr),
`endif
        .req(storeRequest),
        .grant(storeGrant),
        .grantPtr(storeSelectedPtr),
        .granted(storeSelected)
    );
`endif

`ifdef RSD_MARCH_FP_PIPE
`ifndef RSD_MARCH_MULTIPLE_FP_ISSUE
`ifdef CIRCULAR_SELECT_LOGIC
    CircularPicker #(
`else
    Picker #(
`endif
`else 
    FPPicker #(
`endif
        .ENTRY_NUM(ISSUE_QUEUE_ENTRY_NUM),
        .GRANT_NUM(FP_ISSUE_WIDTH)
`ifdef RSD_MARCH_MULTIPLE_FP_ISSUE
        ,
        .DIVSQRT_GRANT_NUM(FP_DIVSQRT_ISSUE_WIDTH)
`endif
    )
    fpPicker(
        .req(fpRequest),
`ifdef RSD_MARCH_MULTIPLE_FP_ISSUE
        .divsqrtreq(fpDivSqrtRequest),
        .canissuedivsqrt(canIssueFPDivSqrt),
`endif
        .grant(fpGrant),
        .grantPtr(fpSelectedPtr),
        .granted(fpSelected)
    );
`endif


`ifdef CIRCULAR_SELECT_LOGIC
    always_ff @ (posedge port.clk) begin
        intPrePtr <= intSelected[INT_ISSUE_WIDTH-1] + 1;
`ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
        compPrePtr <= compSelected[COMPLEX_ISSUE_WIDTH-1] + 1;
`endif
`ifdef RSD_MARCH_UNIFIED_LDST_MEM_PIPE
        memPrePtr <= memSelected[MEM_ISSUE_WIDTH-1] + 1;
`else
        loadPrePtr <= loadSelected[LOAD_ISSUE_WIDTH-1] + 1;
        storePrePtr <= storeSelected[STORE_ISSUE_WIDTH-1] + 1;
`endif
    end
`endif

    always_comb begin

        for (int i = 0; i < ISSUE_QUEUE_ENTRY_NUM; i++) begin
            intRequest[i] = port.opReady[i] && port.intIssueReq[i];
            `ifdef RSD_MARCH_UNIFIED_LDST_MEM_PIPE
                memRequest[i] = port.opReady[i] && (port.loadIssueReq[i] || port.storeIssueReq[i]);
            `else
                loadRequest[i] = port.opReady[i] && port.loadIssueReq[i];
                storeRequest[i] = port.opReady[i] && port.storeIssueReq[i];
            `endif
            
            `ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
                compRequest[i] = port.opReady[i] && port.complexIssueReq[i];
            `endif
            `ifdef RSD_MARCH_FP_PIPE
                fpRequest[i] = port.opReady[i] && port.fpIssueReq[i];
            `ifdef RSD_MARCH_MULTIPLE_FP_ISSUE
                fpDivSqrtRequest[i] = port.opReady[i] && port.fpDivSqrtIssueReq[i];
                canIssueFPDivSqrt = port.canIssueFPDivSqrt;
            `endif
            `endif
        end


        for (int i = 0; i < INT_ISSUE_WIDTH; i++) begin
            portSelected[i] = intSelected[i];
            portSelectedPtr[i] = intSelectedPtr[i];
            portSelectedVector[i] = intGrant[i];
            recoverySelected[i] = intSelected[i];
            recoverySelectedPtr[i] = intSelectedPtr[i];
        end

`ifndef RSD_MARCH_UNIFIED_MULDIV_MEM_PIPE
        for (int i = 0; i < COMPLEX_ISSUE_WIDTH; i++) begin
            portSelected[i+INT_ISSUE_WIDTH] = compSelected[i];
            portSelectedPtr[i+INT_ISSUE_WIDTH] = compSelectedPtr[i];
            portSelectedVector[i+INT_ISSUE_WIDTH] = compGrant[i];
            recoverySelected[i+INT_ISSUE_WIDTH] = compSelected[i];
            recoverySelectedPtr[i+INT_ISSUE_WIDTH] = compSelectedPtr[i];
        end
`endif

`ifdef RSD_MARCH_UNIFIED_LDST_MEM_PIPE
        for (int i = 0; i < MEM_ISSUE_WIDTH; i++) begin
            portSelected[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = memSelected[i];
            portSelectedPtr[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = memSelectedPtr[i];
            portSelectedVector[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = memGrant[i];
            recoverySelected[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = memSelected[i];
            recoverySelectedPtr[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = memSelectedPtr[i];
        end
`else
        for (int i = 0; i < LOAD_ISSUE_WIDTH; i++) begin
            portSelected[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = loadSelected[i];
            portSelectedPtr[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = loadSelectedPtr[i];
            portSelectedVector[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = loadGrant[i];
            recoverySelected[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = loadSelected[i];
            recoverySelectedPtr[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH] = loadSelectedPtr[i];
        end
        for (int i = 0; i < STORE_ISSUE_WIDTH; i++) begin
            portSelected[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+LOAD_ISSUE_WIDTH] = storeSelected[i];
            portSelectedPtr[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+LOAD_ISSUE_WIDTH] = storeSelectedPtr[i];
            portSelectedVector[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+LOAD_ISSUE_WIDTH] = storeGrant[i];
            recoverySelected[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+LOAD_ISSUE_WIDTH] = storeSelected[i];
            recoverySelectedPtr[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+LOAD_ISSUE_WIDTH] = storeSelectedPtr[i];
        end
`endif

`ifdef RSD_MARCH_FP_PIPE
        for (int i = 0; i < FP_ISSUE_WIDTH; i++) begin
            portSelected[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+MEM_ISSUE_WIDTH] = fpSelected[i];
            portSelectedPtr[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+MEM_ISSUE_WIDTH] = fpSelectedPtr[i];
            portSelectedVector[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+MEM_ISSUE_WIDTH] = fpGrant[i];
            recoverySelected[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+MEM_ISSUE_WIDTH] = fpSelected[i];
            recoverySelectedPtr[i+INT_ISSUE_WIDTH+COMPLEX_ISSUE_WIDTH+MEM_ISSUE_WIDTH] = fpSelectedPtr[i];
        end
`endif

        port.selected = portSelected;
        port.selectedPtr = portSelectedPtr;
        port.selectedVector = portSelectedVector;
        recovery.selected = recoverySelected;
        recovery.selectedPtr = recoverySelectedPtr;
    end

endmodule : SelectLogic

