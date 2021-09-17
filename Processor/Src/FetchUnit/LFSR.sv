module LFSR
#(
    parameter WIDTH = 32
)
(
    input logic clk,
    input logic rst,
    input logic [WIDTH-1 : 0] seed,
    output logic [WIDTH-1 : 0] randomval
);

logic [WIDTH - 1:0] r;
logic cap;

always @(posedge clk) begin
    if(rst) begin
        r <= seed; 
    end else begin
        r <= (r >> 1) | (32'(cap) << (32 - 1));
    end
end

assign cap = r[31] ^ r[29] ^ r[28] ^ 1'b1;
assign randomval = r;
endmodule : LFSR