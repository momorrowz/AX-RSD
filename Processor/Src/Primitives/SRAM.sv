//
// --- SRAM implementation. (TSMC28nm)
//

// must define UNIT_DELAY for simulation
`include "BasicMacros.sv"

// Simple Dual Port RAM
module SRAM512W272_1R1W #( 
    parameter ENTRY_NUM = 512, 
    parameter ENTRY_BIT_SIZE = 272
)( 
    input logic clk,
    input logic we,
    input logic [$clog2(ENTRY_NUM)-1: 0] wa,
    input logic [ENTRY_BIT_SIZE-1: 0] wv,
    input logic [$clog2(ENTRY_NUM)-1: 0] ra,
    output logic [ENTRY_BIT_SIZE-1: 0] rv
);
    localparam INDEX_BIT_SIZE = $clog2(ENTRY_NUM);
    typedef logic [INDEX_BIT_SIZE-1: 0] Address;
    typedef logic [67:0] Value [3:0];
    
    logic isContention; 
    logic[ENTRY_BIT_SIZE-1:0] preWV;

    logic [1:0] WTSEL;
    logic [1:0] RTSEL;
    logic VG;
    logic VS;
    Address AA;
    logic WEBA;
    logic CEBA;
    logic CLKA;
    Address AB;
    logic WEBB;
    logic CEBB;
    logic CLKB;

    Value DA; 
    Value DB; 
    Value QA;
    Value QB;

    always_ff @( posedge clk ) begin
        preWV <= wv;
        isContention <= (ra == wa) && (we == 1'b1) ? 1'b1 : 1'b0;
    end

    assign WTSEL = 2'b01;
    assign RTSEL = 2'b01;
    assign VG = 1'b1;
    assign VS = 1'b1;
    assign AA = wa;
    assign WEBA = ~we;
    assign CEBA = (we == 1'b1) ? 1'b0 : 1'b1;
    assign CLKA = clk;
    assign AB = ra;
    assign WEBB = 1'b1;
    assign CEBB = (ra == wa) && (we == 1'b1) ? 1'b1 : 1'b0;
    assign CLKB = clk; 

    always_comb begin
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 68; j++) begin
                DA[i][j] = wv[i*68+j];
                DB[i][j] = 1'b0;
                rv[i*68+j] = isContention ? preWV[i*68+j] : QB[i][j];
            end
        end
    end

    
generate
    for (genvar i = 0; i < 4; i++) begin
        TSDN28HPCPA512X68M4M sram
        (
        .WTSEL(WTSEL),
        .RTSEL(RTSEL),
        .VG(VG),
        .VS(VS),
        .AA(AA),
        .DA(DA[i]),
        .WEBA(WEBA),
        .CEBA(CEBA),
        .CLKA(CLKA),
        .AB(AB),
        .DB(DB[i]),
        .WEBB(WEBB),
        .CEBB(CEBB),
        .CLKB(CLKB),
        .QA(QA[i]),
        .QB(QB[i])
      );
    end
endgenerate
   
endmodule : SRAM512W272_1R1W

module SRAM128W256_2RW_BWEB #( 
    parameter ENTRY_NUM = 128, 
    parameter ENTRY_BIT_SIZE = 256,
    parameter ENTRY_BYTE_SIZE = 32,
    parameter PORT_NUM  = 2 // Do NOT change this parameter to synthesize True Dual Port RAM
)( 
    input logic clk,
    input logic [ENTRY_BYTE_SIZE-1: 0] we[PORT_NUM],
    input logic [$clog2(ENTRY_NUM)-1: 0] rwa[PORT_NUM],
    input logic [ENTRY_BIT_SIZE-1: 0] wv[PORT_NUM],
    output logic [ENTRY_BIT_SIZE-1: 0] rv[PORT_NUM]
);
    localparam INDEX_BIT_SIZE = $clog2(ENTRY_NUM);
    typedef logic [INDEX_BIT_SIZE-1: 0] Address;
    typedef logic [31:0] Value [7:0];
    
    logic [1:0] WTSEL;
    logic [1:0] RTSEL;
    logic [1:0] PTSEL;
    Address AA;
    Value DA;
    Value BWEBA;
    logic WEBA;
    logic CEBA;
    logic CLK;
    Address AB;
    Value DB;
    Value BWEBB;
    logic WEBB;
    logic CEBB;
    logic AWT;
    Value QA;
    Value QB;

    always_comb begin
        for (int i = 0; i < 8; i++) begin
            for (int j = 0; j < 8; j++) begin
                for(int b = 0; b < 8; b++) begin
                    BWEBA[i][j*8+b] = ~we[0][i*4+j]; 
                    BWEBB[i][j*8+b] = ~we[1][i*4+j]; 
                end
            end
        end
        for (int i = 0; i < 8; i++) begin
            for (int j = 0; j < 8; j++) begin
                for(int b = 0; b < 8; b++) begin
                    DA[i][j*8+b] = wv[0][i*32+j*8+b];
                    DB[i][j*8+b] = wv[1][i*32+j*8+b];
                    rv[0][i*32+j*8+b] = QA[i][j*8+b];
                    rv[1][i*32+j*8+b] = QB[i][j*8+b];
                end
            end
        end
    end

    assign WTSEL = 2'b00;
    assign RTSEL = 2'b00;
    assign PTSEL = 2'b00;
    assign AA = rwa[0];
    assign WEBA = ~(|we[0]);
    assign CEBA = 1'b0;
    assign CLK = clk;
    assign AB = rwa[1];
    assign WEBB = ~(|we[1]);
    assign CEBB = 1'b0;
    assign AWT = 1'b0;

generate
    for (genvar i = 0; i < 8; i++) begin
        TSDN28HPCPUHDB128X32M4MWA sram
        (
        .WTSEL(WTSEL),
        .RTSEL(RTSEL),
        .PTSEL(PTSEL),
        .AA(AA),
        .DA(DA[i]),
        .BWEBA(BWEBA[i]),
        .WEBA(WEBA),
        .CEBA(CEBA),
        .CLK(CLK),
        .AB(AB),
        .DB(DB[i]),
        .BWEBB(BWEBB[i]),
        .WEBB(WEBB),
        .CEBB(CEBB),
        .AWT(AWT),
        .QA(QA[i]),
        .QB(QB[i])
        );
    end
endgenerate

endmodule : SRAM128W256_2RW_BWEB

module DualSRAM128W8 #( 
    parameter ENTRY_NUM = 128, 
    parameter ENTRY_BIT_SIZE = 8,
    parameter PORT_NUM  = 2 // Do NOT change this parameter to synthesize True Dual Port RAM
)( 
    input logic clk,
    input logic we[PORT_NUM],
    input logic [$clog2(ENTRY_NUM)-1: 0] rwa[PORT_NUM],
    input logic [ENTRY_BIT_SIZE-1: 0] wv[PORT_NUM],
    output logic [ENTRY_BIT_SIZE-1: 0] rv[PORT_NUM]
);
    localparam INDEX_BIT_SIZE = $clog2(ENTRY_NUM);
    typedef logic [INDEX_BIT_SIZE-1: 0] Address;
    typedef logic [ENTRY_BIT_SIZE-1: 0] Value;
    
    logic[1:0] isContention;
    logic[ENTRY_BIT_SIZE-1: 0] preWV;

    logic [1:0] WTSEL;
    logic [1:0] RTSEL;
    logic VG;
    logic VS;
    Address AA;
    Value DA;
    logic WEBA;
    logic CEBA;
    logic CLKA;
    Address AB;
    Value DB;
    logic WEBB;
    logic CEBB;
    logic CLKB;
    Value QA;
    Value QB;

    always_ff @( posedge clk ) begin
        preWV <= (we[0] == 1'b1) ? wv[0] : wv[1];
        isContention[0] <= (rwa[0] == rwa[1]) && (we[1] == 1'b1) ? 1'b1 : 1'b0;
        isContention[1] <= (rwa[0] == rwa[1]) && (we[0] == 1'b1) ? 1'b1 : 1'b0;
    end

    assign WTSEL = 2'b01;
    assign RTSEL = 2'b01;
    assign VG = 1'b1;
    assign VS = 1'b1;
    assign AA = rwa[0];
    assign DA = wv[0];
    assign WEBA = ~we[0];
    assign CEBA = (rwa[0] == rwa[1]) && (we[1] == 1'b1) ? 1'b1 : 1'b0;
    assign CLKA = clk;
    assign AB = rwa[1];
    assign DB = wv[1];
    assign WEBB = ~we[1];
    assign CEBB = (rwa[0] == rwa[1]) && (we[0] == 1'b1) ? 1'b1 : 1'b0;
    assign CLKB = clk; 
    assign rv[0] = isContention[0] ? preWV : QA;
    assign rv[1] = isContention[1] ? preWV : QB;

    TSDN28HPCPA128X8M4M sram1
    (
    .WTSEL(WTSEL),
    .RTSEL(RTSEL),
    .VG(VG),
    .VS(VS),
    .AA(AA),
    .DA(DA),
    .WEBA(WEBA),
    .CEBA(CEBA),
    .CLKA(CLKA),
    .AB(AB),
    .DB(DB),
    .WEBB(WEBB),
    .CEBB(CEBB),
    .CLKB(CLKB),
    .QA(QA),
    .QB(QB)
    );
    
endmodule : DualSRAM128W8
