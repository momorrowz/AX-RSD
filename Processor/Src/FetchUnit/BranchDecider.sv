import BasicTypes::*;
import MemoryMapTypes::*;
import FetchUnitTypes::*;

module BranchDecider #(
    parameter SEED = LFSRSEED
)
(
    NextPCStageIF.BranchDecider port,
    FetchStageIF.BranchDecider fetch,
    input logic [AX_LEVEL_WIDTH-1:0] csr_val //近似度合
);


logic [LFSR_WIDTH-1:0] randomval, seed;
logic is_taken;
logic update, hit;

LFSR #(
    .WIDTH(LFSR_WIDTH)
) l0 (
    .clk(port.clk),
    .rst(port.rst),
    .seed(SEED),
    .randomval(randomval),
    .update(update)
);

always_comb begin
    is_taken = ((32'(csr_val) << (LFSR_WIDTH - AX_LEVEL_WIDTH)) > randomval);
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        fetch.brDecidTaken[i] = (is_taken && fetch.axbtbHit[i]);
    end
    update = 0;
    //AXBTBがヒットして,それより前の命令が分岐と予測しなければLFSRを更新
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        if(fetch.axbtbHit[i]) begin
            update = 1;
            for(int j = 0; j < i; ++j) begin
                if(fetch.btbHit[j] && fetch.brPredTaken[j]) begin
                    update = 0;
                    break;
                end
            end
            break;
        end
    end
end
/*
initial begin
    seed = SEED;
end
*/

endmodule : BranchDecider
