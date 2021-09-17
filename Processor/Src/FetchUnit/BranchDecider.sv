import BasicTypes::*;
import MemoryMapTypes::*;
import FetchUnitTypes::*;

module BranchDecider #(
    parameter LFSR_WIDTH = 32,
    parameter AX_LEVEL_WIDTH = 5,
    parameter SEED = 32'h1
)
(
    NextPCStageIF.BranchDecider port,
    FetchStageIF.BranchDecider next,
    //input logic clk,
    //input logic rst,
    input logic [AX_LEVEL_WIDTH-1:0] csr_val //近似度合
    //output logic is_taken
);


logic [LFSR_WIDTH-1:0] randomval[FETCH_WIDTH], seed[FETCH_WIDTH];
logic is_taken[FETCH_WIDTH];

generate
    for(genvar i = 0; i < FETCH_WIDTH; ++i) begin
        LFSR #(
            .WIDTH(LFSR_WIDTH)
        ) l0 (
            .clk(port.clk),
            .rst(port.rst),
            .seed(seed[i]),
            .randomval(randomval[i])
        );
    end
endgenerate
always_comb begin
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        is_taken[i] = ((32'(csr_val) << (LFSR_WIDTH - AX_LEVEL_WIDTH)) > randomval[i]);
        next.brDecidTaken[i] = (is_taken[i] && next.axbtbHit[i]);
    end
end

initial begin
    for(int i = 0; i < FETCH_WIDTH; ++i) begin
        seed[i] = SEED;
    end
end

/*
LFSR #(
    .WIDTH(LFSR_WIDTH)
) l0 (
    .clk(port.clk),
    .rst(port.rst),
    .seed(seed),
    .randomval(randomval)
);
*/

endmodule : BranchDecider