import BasicTypes::*;
import MemoryMapTypes::*;
import FetchUnitTypes::*;

module BranchDeciderCycle #()
(
    FetchStageIF.BranchDeciderCycle fetch,
    input DataPath cyclecounter, //サイクルカウンタ
    input DataPath cyclecounterh,
    input DataPath begincycle, //開始サイクル
    input DataPath begincycleh,
    input DataPath threshold //閾値レジスタ
);

logic is_taken;

always_comb begin
    is_taken = ({cyclecounterh, cyclecounter} > ({begincycleh, begincycle} + {{DATA_WIDTH{threshold[DATA_WIDTH-1]}}, threshold}));
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        fetch.brDecidCycTaken[i] = (is_taken && fetch.axbltcycbtbHit[i]);
    end
end

endmodule : BranchDeciderCycle
