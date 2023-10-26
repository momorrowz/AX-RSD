import BasicTypes::*;
import MemoryMapTypes::*;
import FetchUnitTypes::*;

module BeginCycleCount #()
(
    NextPCStageIF.BeginCycleCount port,
    FetchStageIF.BeginCycleCount fetch,
    input DataPath cyclecounter, //サイクルカウンタ
    output DataPath begincycle //開始サイクル
);

logic update;

FlipFlopWE#( DATA_WIDTH, DATA_ZERO ) 
    CycleReg( 
        .out( begincycle ), 
        .in ( cyclecounter ),
        .we ( update ), 
        .clk( port.clk ),
        .rst( port.rst )
    );

always_comb begin
    update = FALSE;
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        if (fetch.bufferHit[i]) begin
            update = TRUE;
        end
    end
    for (int i = 0; i < INT_ISSUE_WIDTH; ++i) begin
        if (port.brResult[i].isApBCC && !port.brResult[i].bufHit) begin
            update = TRUE;
        end
    end
end
endmodule : BeginCycleCount