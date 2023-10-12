import BasicTypes::*;
import MemoryMapTypes::*;
import FetchUnitTypes::*;

module BranchDeciderCycle #()
(
    // NextPCStageIF.BranchDeciderCycle port,
    FetchStageIF.BranchDeciderCycle fetch,
    input DataPath cyclecounter, //サイクルカウンタ
    input DataPath begincycle, //開始サイクル
    input DataPath threshold //閾値レジスタ
    // input logic [AX_LEVEL_WIDTH-1:0] csr_val //近似度合
);


// logic [LFSR_WIDTH-1:0] randomval, seed;
logic is_taken, hit;


always_comb begin
    // is_taken = ((32'(csr_val) << (LFSR_WIDTH - AX_LEVEL_WIDTH)) > randomval);
    is_taken = (cyclecounter > (begincycle + threshold))
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        fetch.brDecidCycTaken[i] = (is_taken && fetch.axbrcycbtbHit[i]);
    end
end

endmodule : BranchDeciderCycle
