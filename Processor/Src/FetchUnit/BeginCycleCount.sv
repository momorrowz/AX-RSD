import BasicTypes::*;
import MemoryMapTypes::*;
import FetchUnitTypes::*;

module BeginCycleCount #()
(
    FetchStageIF.BeginCycleCount fetch,
    input DataPath cyclecounter, //サイクルカウンタ
    input DataPath begincycle, //開始サイクル
);
always_comb begin
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        if (fetch.bufferHit[i]) begin
            begincycle = cyclecounter 
        end
    end
end
endmodule : BeginCycleCount