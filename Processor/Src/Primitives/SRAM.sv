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
    typedef logic [63:0] Value [3:0];
    
    logic [1:0] WTSEL;
    logic [1:0] RTSEL;
    logic [1:0] PTSEL;
    logic isWrite[PORT_NUM], isWriteReg[PORT_NUM];
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
    always_ff @(posedge clk) begin
        for (int i = 0; i < PORT_NUM; i++) begin
            isWriteReg[i] <= isWrite[i];
        end
    end

    always_comb begin
        for (int i = 0; i < PORT_NUM; i++) begin
            isWrite[i] = |we[i];
        end
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 8; j++) begin
                for(int b = 0; b < 8; b++) begin
                    BWEBA[i][j*8+b] = isWrite[0] ? ~we[1][i*8+j] : ~we[0][i*8+j]; 
                    BWEBB[i][j*8+b] = isWrite[0] ? ~we[0][i*8+j] : ~we[1][i*8+j]; 
                end
            end
        end
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 8; j++) begin
                for(int b = 0; b < 8; b++) begin
                    DA[i][j*8+b] = isWrite[0] ? wv[1][i*64+j*8+b] : wv[0][i*64+j*8+b];
                    DB[i][j*8+b] = isWrite[0] ? wv[0][i*64+j*8+b] : wv[1][i*64+j*8+b];
                    rv[0][i*64+j*8+b] = isWriteReg[0] ? QB[i][j*8+b] : QA[i][j*8+b];
                    rv[1][i*64+j*8+b] = isWriteReg[0] ? QA[i][j*8+b] : QB[i][j*8+b];
                end
            end
        end
    end

    assign WTSEL = 2'b00;
    assign RTSEL = 2'b00;
    assign PTSEL = 2'b00;
    assign AA = isWrite[0] ? rwa[1] : rwa[0];
    assign WEBA = isWrite[0] ? ~isWrite[1] : ~isWrite[0];
    assign CEBA = 1'b0;
    assign CLK = clk;
    assign AB = isWrite[0] ? rwa[0] : rwa[1];
    assign WEBB = isWrite[0] ? ~isWrite[0] : ~isWrite[1];
    assign CEBB = 1'b0;
    assign AWT = 1'b0;

    generate
        for (genvar i = 0; i < 4; i++) begin
            TSDN28HPCPUHDB128X64M4MWA sram
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

module MultiBankSRAM #(
    parameter ENTRY_NUM = 4096, 
    parameter ENTRY_BIT_SIZE = 21,
    parameter READ_NUM  = 4,
    parameter WRITE_NUM = 4
)( 
    input  logic clk,
    input  logic we[WRITE_NUM],
    input  logic [$clog2(ENTRY_NUM)-1: 0] wa[WRITE_NUM],
    input  logic [ENTRY_BIT_SIZE-1: 0] wv[WRITE_NUM],
    input  logic [$clog2(ENTRY_NUM)-1: 0] ra[READ_NUM],
    output logic [ENTRY_BIT_SIZE-1: 0] rv[READ_NUM]
);
    
    localparam INDEX_BIT_SIZE = $clog2(ENTRY_NUM);
    typedef logic [INDEX_BIT_SIZE-1: 0] Address;
    typedef logic [ENTRY_BIT_SIZE-1: 0] Value;

    localparam BANK_NUM_BIT_WIDTH = $clog2(READ_NUM > WRITE_NUM ? READ_NUM : WRITE_NUM);
    localparam BANK_NUM = 1 << BANK_NUM_BIT_WIDTH;

    generate
        MultiBankSRAM_Body#(ENTRY_NUM, ENTRY_BIT_SIZE, READ_NUM, WRITE_NUM)
            rBank(clk, we, wa, wv, ra, rv);
    endgenerate

`ifndef RSD_SYNTHESIS
    // For Debug
    // This signal will be written in a test bench, so set public for verilator.
    Value debugValue[ ENTRY_NUM ] /*verilator public*/;
    initial begin
        for (int i = 0; i < ENTRY_NUM; i++) begin
            for (int j = 0; j < ENTRY_BIT_SIZE; j++) begin
                debugValue[i][j] = 0;
            end
        end
    end

    Value rvReg[READ_NUM];
    always_ff @(posedge clk) begin
        for (int i = 0; i < READ_NUM; i++) begin
            rvReg[i] <= debugValue[ ra[i] ];
        end
        for (int i = 0; i < WRITE_NUM; i++) begin
            if (we[i])
                debugValue[ wa[i] ] <= wv[i];
        end

    end

    generate
        for (genvar i = 0; i < READ_NUM; i++) begin
            `RSD_ASSERT_CLK_FMT(
                clk,
                rvReg[i] == rv[i],
                ("The read output of a port(%x) is incorrect", i)
            );
        end
    endgenerate
`endif

endmodule : MultiBankSRAM

module MultiBankSRAM_Body #(
    parameter ENTRY_NUM = 4096, 
    parameter ENTRY_BIT_SIZE = 21, 
    parameter READ_NUM  = 4,
    parameter WRITE_NUM = 4
)( 
    input  logic clk,
    input  logic we[WRITE_NUM],
    input  logic [$clog2(ENTRY_NUM)-1: 0] wa[WRITE_NUM],
    input  logic [ENTRY_BIT_SIZE-1: 0] wv[WRITE_NUM],
    input  logic [$clog2(ENTRY_NUM)-1: 0] ra[READ_NUM],
    output logic [ENTRY_BIT_SIZE-1: 0] rv[READ_NUM]
);
    
    localparam BANK_NUM_BIT_WIDTH = $clog2(READ_NUM > WRITE_NUM ? READ_NUM : WRITE_NUM);
    localparam BANK_NUM = 1 << BANK_NUM_BIT_WIDTH;
    localparam PACK_NUM = ENTRY_NUM / BANK_NUM / 256;
    localparam PACK_NUM_BIT_WIDTH = $clog2(PACK_NUM);
    localparam INDEX_BIT_SIZE = $clog2(ENTRY_NUM);
    typedef logic [INDEX_BIT_SIZE-1: 0] Address;
    typedef logic [PACK_NUM * ENTRY_BIT_SIZE-1: 0] Value;
    
    
    Address waBank[BANK_NUM];
    Address raBank[BANK_NUM];
    Value rvBank[BANK_NUM];
    Value wvBank[BANK_NUM];
    logic [PACK_NUM-1:0] weBank[BANK_NUM];

    Address raReg[BANK_NUM];

    // Raise error if the number of entries is not a multiple of 
    // the number of banks
    `RSD_STATIC_ASSERT(
        ENTRY_NUM % BANK_NUM == 0,
        "Set the number of entries a multiple of the number of banks."
    );
    
    generate
        for (genvar i = 0; i < BANK_NUM; i++) begin
            SRAM256_2RW_BWEB #(ENTRY_NUM / (BANK_NUM * PACK_NUM), ENTRY_BIT_SIZE * PACK_NUM, PACK_NUM)
                rBank(
                    clk, 
                    weBank[i], 
                    waBank[i][INDEX_BIT_SIZE-1 : BANK_NUM_BIT_WIDTH + PACK_NUM_BIT_WIDTH], 
                    wvBank[i], 
                    raBank[i][INDEX_BIT_SIZE-1 : BANK_NUM_BIT_WIDTH + PACK_NUM_BIT_WIDTH], 
                    rvBank[i]
                );
        end
    endgenerate
    
    always_ff @(posedge clk) begin
        for (int i = 0; i < BANK_NUM; i++) begin
            raReg[i] <= ra[i];
        end
    end
    
    always_comb begin
        for (int b = 0; b < BANK_NUM; b++) begin
            waBank[b] = wa[0];  // Don't care
            for (int p = 0; p < PACK_NUM; p++) begin
                weBank[b][p] = '0;     // It must be 0.
                wvBank[b][(p * ENTRY_BIT_SIZE) +: ENTRY_BIT_SIZE] = wv[0];
                for (int i = 0; i < WRITE_NUM; i++) begin
                    if (we[i] && wa[i][BANK_NUM_BIT_WIDTH-1 : 0] == b && wa[i][PACK_NUM_BIT_WIDTH+BANK_NUM_BIT_WIDTH-1 : BANK_NUM_BIT_WIDTH] == p) begin
                        weBank[b][p] = we[i];
                        waBank[b] = wa[i];
                        wvBank[b][(p * ENTRY_BIT_SIZE) +: ENTRY_BIT_SIZE] = wv[i];
                        break;
                    end
                end
            end
        end

        for (int b = 0; b < BANK_NUM; b++) begin
            raBank[b] = ra[0]; // Don't care
            for (int i = 0; i < READ_NUM; i++) begin
                if (ra[i][BANK_NUM_BIT_WIDTH-1 : 0] == b) begin
                    raBank[b] = ra[i];
                    break;
                end
            end
        end

        for (int i = 0; i < READ_NUM; i++) begin
            rv[i] = rvBank[0][ENTRY_BIT_SIZE-1:0];  // Don't care
            for (int p = 0; p < PACK_NUM; p++) begin
                for (int b = 0; b < BANK_NUM; b++) begin
                    if (raReg[i][BANK_NUM_BIT_WIDTH-1 : 0] == b && raReg[i][PACK_NUM_BIT_WIDTH+BANK_NUM_BIT_WIDTH-1:BANK_NUM_BIT_WIDTH] == p) begin
                        rv[i] = rvBank[b][(p * ENTRY_BIT_SIZE) +: ENTRY_BIT_SIZE];
                        break;
                    end
                end
            end
        end
    end

    generate
        for (genvar j = 0; j < WRITE_NUM; j++) begin
            for (genvar i = 0; i < WRITE_NUM; i++) begin
                `RSD_ASSERT_CLK_FMT(
                    clk,
                    !(we[i] && we[j] && wa[i][BANK_NUM_BIT_WIDTH-1 : 0] == wa[j][BANK_NUM_BIT_WIDTH-1 : 0] && i != j),
                    ("Multiple ports(%x,%x) write to the same bank.", i, j)
                );
            end
        end
        for (genvar j = 0; j < READ_NUM; j++) begin
            for (genvar i = 0; i < READ_NUM; i++) begin
                `RSD_ASSERT_CLK_FMT(
                    clk,
                   !(ra[i][BANK_NUM_BIT_WIDTH-1 : 0] == ra[j][BANK_NUM_BIT_WIDTH-1 : 0] && i != j),
                    ("Multiple ports(%x,%x) read from the same bank.", i, j)
                );
            end
        end
    endgenerate

endmodule : MultiBankSRAM_Body

module SRAM256_2RW_BWEB #( 
    parameter ENTRY_NUM = 256, 
    parameter ENTRY_BIT_SIZE = 84,
    parameter ENTRY_BYTE_NUM = 4
)( 
    input logic clk,
    input logic [ENTRY_BYTE_NUM-1: 0] we,
    input logic [$clog2(ENTRY_NUM)-1: 0] wa,
    input logic [ENTRY_BIT_SIZE-1: 0] wv,
    input logic [$clog2(ENTRY_NUM)-1: 0] ra,
    output logic [ENTRY_BIT_SIZE-1: 0] rv
);
    localparam INDEX_BIT_SIZE = $clog2(ENTRY_NUM);
    typedef logic [INDEX_BIT_SIZE-1: 0] Address;
    typedef logic [ENTRY_BIT_SIZE-1:0] Value;
    localparam BYTE_BIT_SIZE = ENTRY_BIT_SIZE / ENTRY_BYTE_NUM;
    
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
        for (int j = 0; j < ENTRY_BYTE_NUM; j++) begin
            for(int b = 0; b < BYTE_BIT_SIZE; b++) begin
                BWEBA[j*BYTE_BIT_SIZE+b] = 1'b1; 
                BWEBB[j*BYTE_BIT_SIZE+b] = ~we[j]; 
            end
        end
        for (int j = 0; j < ENTRY_BYTE_NUM; j++) begin
            for(int b = 0; b < BYTE_BIT_SIZE; b++) begin
                DA[j*BYTE_BIT_SIZE+b] = 1'b0;
                DB[j*BYTE_BIT_SIZE+b] = wv[j*BYTE_BIT_SIZE+b];
                rv[j*BYTE_BIT_SIZE+b] = QA[j*BYTE_BIT_SIZE+b];
            end
        end
    end

    assign WTSEL = 2'b00;
    assign RTSEL = 2'b00;
    assign PTSEL = 2'b00;
    assign AA = ra;
    assign WEBA = 1'b1; // read
    assign CEBA = 1'b0;
    assign CLK = clk;
    assign AB = wa;
    assign WEBB = ~(|we); // write
    assign CEBB = ~(|we);
    assign AWT = 1'b0;

generate
    if(ENTRY_BIT_SIZE == 84) begin
        TSDN28HPCPUHDB256X84M4MWA sram ( .WTSEL(WTSEL), .RTSEL(RTSEL), .PTSEL(PTSEL), .AA(AA), .DA(DA), .BWEBA(BWEBA), .WEBA(WEBA), .CEBA(CEBA), .CLK(CLK), .AB(AB), .DB(DB), .BWEBB(BWEBB), .WEBB(WEBB), .CEBB(CEBB), .AWT(AWT), .QA(QA), .QB(QB) );
    end
    //else if (ENTRY_BIT_SIZE == 64) begin
    else begin
        TSDN28HPCPUHDB256X64M4MWA sram ( .WTSEL(WTSEL), .RTSEL(RTSEL), .PTSEL(PTSEL), .AA(AA), .DA(DA), .BWEBA(BWEBA), .WEBA(WEBA), .CEBA(CEBA), .CLK(CLK), .AB(AB), .DB(DB), .BWEBB(BWEBB), .WEBB(WEBB), .CEBB(CEBB), .AWT(AWT), .QA(QA), .QB(QB) );
    end
endgenerate

endmodule : SRAM256_2RW_BWEB