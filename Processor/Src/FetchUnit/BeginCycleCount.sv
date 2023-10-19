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

always_comb begin
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        if (fetch.bufferHit[i] || port.brResult[i].isApBCC) begin
            begincycle = cyclecounter; 
        end
    end
end
endmodule : BeginCycleCount