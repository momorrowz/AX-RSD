import BasicTypes::*;
import MemoryMapTypes::*;
import FetchUnitTypes::*;

module BranchDeciderCycle #()
(
    NextPCStageIF.BranchDecider port,
    FetchStageIF.BranchDecider fetch,
    input logic [AX_LEVEL_WIDTH-1:0] csr_val //近似度合
);


logic [LFSR_WIDTH-1:0] randomval, seed;
logic is_taken;
logic update, hit;


always_comb begin
    is_taken = ((32'(csr_val) << (LFSR_WIDTH - AX_LEVEL_WIDTH)) > randomval);
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        fetch.brDecidTaken[i] = (is_taken && fetch.axbtbHit[i]);
    end
    update = FALSE;
    //AXBTBがヒットして,それより前の命令が分岐と予測しなければLFSRを更新
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        if(fetch.axbtbHit[i]) begin
            update = TRUE;
            for(int j = 0; j < i; ++j) begin
                if(fetch.brPredTaken[j]) begin
                    update = FALSE;
                    break;
                end
            end
            break;
        end
    end
end

endmodule : BranchDeciderCycle
