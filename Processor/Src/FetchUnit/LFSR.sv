module LFSR
#(
    parameter WIDTH = 32
)
(
    input logic clk,
    input logic rst,
    input logic [WIDTH-1 : 0] seed,
    input logic update,
    output logic [WIDTH-1 : 0] randomval
);

logic [WIDTH - 1:0] r;
logic cap;

always_ff @(posedge clk) begin
    if(rst) begin
        r <= seed; 
    end else if(update) begin
        r <= (r >> 1) | (32'(cap) << (32 - 1));
    end
end

always_comb begin
    cap = r[31] ^ r[21] ^ r[1] ^ r[0];
    randomval = r;
end
endmodule : LFSR