module setting_display #(
    parameter ADDR = 30'h1085557C
    //parameter ADDR = 30'h10426240
    //parameter ADDR = 30'h104015B8
)(
    input wire clk,
    input wire rst,
    input wire VBLANK,
    output reg CLRVBLNK,
    output reg [29:0] DISPADDR,
    output reg DISPON,
    output reg [2:0] state
);

//reg [2:0] state;

always @(posedge clk) begin
    if(!rst) begin
        state <= 3'b000;
        CLRVBLNK <= 1'b1;
        DISPADDR <= 30'b0;
        DISPON <= 1'b0;
    end else begin
        case(state)
            3'b000: begin
                CLRVBLNK <= 1'b0;
                state <= 3'b001;
            end
            3'b001: begin
                if(VBLANK == 1'b1) state <= 3'b010;
            end
            3'b010: begin
                DISPADDR <= ADDR;
                DISPON <= 1'b1;
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end

endmodule

