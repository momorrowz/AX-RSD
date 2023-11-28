// Copyright 2019- RSD contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.


//
// Branch target buffer for approximate begin cycle count
//

import BasicTypes::*;
import MemoryMapTypes::*;
import FetchUnitTypes::*;

module Buffer(
    NextPCStageIF.BUFFER port,
    FetchStageIF.BUFFER fetch
);

    // BTB access
    logic btbWE[INT_ISSUE_WIDTH];
    AXBTB_IndexPath btbWA[INT_ISSUE_WIDTH];
    Buffer_Entry btbWV[INT_ISSUE_WIDTH];
    AXBTB_IndexPath btbRA[FETCH_WIDTH];
    Buffer_Entry btbRV[FETCH_WIDTH];
    
    // Output
    // PC_Path btbOut[FETCH_WIDTH];
    logic btbHit[FETCH_WIDTH];
    
    PC_Path pcIn;
    
    PC_Path [FETCH_WIDTH-1 : 0] tagReg;
    PC_Path [FETCH_WIDTH-1 : 0] nextTagReg;
    
    logic pushBtbQueue, popBtbQueue;
    logic full, empty;

    BufferQueueEntry btbQueue[BTB_QUEUE_SIZE];
    BTBQueuePointerPath headPtr, tailPtr;
    BufferQueueEntry btbQueueWV;

    logic IsPhtBankConflict[INT_ISSUE_WIDTH];

    generate
        BlockMultiBankRAM #(
            .ENTRY_NUM( AXBTB_ENTRY_NUM ),
            .ENTRY_BIT_SIZE( $bits( Buffer_Entry ) ),
            .READ_NUM( FETCH_WIDTH ),
            .WRITE_NUM( INT_ISSUE_WIDTH )
        ) 
        btbEntryArray( 
            .clk(port.clk),
            .we(btbWE),
            .wa(btbWA),
            .wv(btbWV),
            .ra(btbRA),
            .rv(btbRV)
        );

        QueuePointer #(
            .SIZE( BTB_QUEUE_SIZE )
        )
        btbQueuePointer(
            .clk(port.clk),
            .rst(port.rst),
            .push(pushBtbQueue),
            .pop(popBtbQueue),
            .full(full),
            .empty(empty),
            .headPtr(headPtr),
            .tailPtr(tailPtr)    
        );
    endgenerate
    
    
    // Counter for reset sequence.
    BTB_IndexPath resetIndex;
    always_ff @(posedge port.clk) begin
        if(port.rstStart) begin
            resetIndex <= 0;
        end
        else begin
            resetIndex <= resetIndex + 1;
        end
        
        if (port.rst) begin
            tagReg <= '0;
        end
        else begin
            tagReg <= nextTagReg;
        end
    end

    always_ff @(posedge port.clk) begin
        // Push btb Queue
        if (pushBtbQueue) begin
            btbQueue[tailPtr] <= btbQueueWV;
        end 
    end


    always_comb begin
        
        pcIn = port.predNextPC;
        
        // Address inputs for read entry.
        for (int i = 0; i < FETCH_WIDTH; i++) begin
            btbRA[i] = ToAXBTB_Index(pcIn + i*INSN_BYTE_WIDTH);
            nextTagReg[i] = pcIn + i*INSN_BYTE_WIDTH;
        end
            
        // Make logic for using at other module.
        for (int i = 0; i < FETCH_WIDTH; i++) begin
            btbHit[i] = btbRV[i].valid && (btbRV[i].tag == ToBUFFER_Tag(tagReg[i]));
            // btbOut[i] = ToRawAddrFromBTB_Addr(btbRV[i].data, tagReg[i]);
        end

        // Write request from IntEx Stage
        for (int i = 0; i < INT_ISSUE_WIDTH; i++) begin
            btbWE[i] = port.brResult[i].valid && port.brResult[i].isApBCC;
            btbWA[i] = ToAXBTB_Index(port.brResult[i].brAddr);
            btbWV[i].tag = ToBUFFER_Tag(port.brResult[i].brAddr);
            // btbWV[i].data = ToBTB_Addr(port.brResult[i].nextAddr);
            btbWV[i].valid = TRUE;
        end

        pushBtbQueue = FALSE;
        // check whether bank conflict occurs
        btbQueueWV.wv = '0;
        btbQueueWV.wa = '0;
        for (int i = 1; i < INT_ISSUE_WIDTH; i++) begin
            if (btbWE[i]) begin
                for (int j = 0; j < i; j++) begin
                    if (!btbWE[j]) begin // check only valid write
                        continue;
                    end

                    if (IsBankConflict(btbWA[i], btbWA[j])) begin
                        // Detect bank conflict
                        // push this write access to queue
                        btbWE[i] = FALSE;
                        pushBtbQueue = TRUE;
                        btbQueueWV.wv = btbWV[i];
                        btbQueueWV.wa = btbWA[i];
                        break;
                    end
                end
            end
        end

        // Write request from BTB Queue
        popBtbQueue = FALSE;
        for (int i = 0; i < INT_ISSUE_WIDTH; i++) begin
            IsPhtBankConflict[i] = FALSE;
        end
        if (!empty) begin
            for (int i = 0; i < INT_ISSUE_WIDTH; i++) begin //: outer
                // Find idle write port 
                if (btbWE[i]) begin
                    continue;
                end
                // Check whether bank conflict occurs
                for (int j = 0; j < INT_ISSUE_WIDTH; j++) begin
                    if (i == j || !btbWE[j]) begin
                        continue;
                    end

                    if (IsBankConflict(btbQueue[headPtr].wa, btbWA[j])) begin
                        // Detect bank conflict
                        // skip popping BTB queue
                        //disable outer;
                        IsPhtBankConflict[i] = TRUE;
                    end
                end
                if(IsPhtBankConflict[i]) break;
                // Write request from BTB queue
                popBtbQueue = TRUE;
                btbWE[i] = TRUE;
                btbWA[i] = btbQueue[headPtr].wa;
                btbWV[i] = btbQueue[headPtr].wv;
            end
        end

        
        // In reset sequence, the write port 0 is used for initializing, and 
        // the other write ports are disabled.
        if (port.rst) begin
            for (int i = 0; i < INT_ISSUE_WIDTH; i++) begin
                btbWE[i] = (i == 0) ? TRUE : FALSE;
                btbWA[i] = resetIndex;
                btbWV[i].tag = 0;
                // btbWV[i].data = 0;
                btbWV[i].valid = FALSE;
            end

            // To avoid writing to the same bank (avoid error message)
            for (int i = 0; i < FETCH_WIDTH; i++) begin
                btbRA[i] = i;
            end
            
            pushBtbQueue = FALSE;
            popBtbQueue = FALSE;
        end

        // fetch.bufferOut = btbOut;
        fetch.bufferHit = btbHit;
        
    end


endmodule : Buffer