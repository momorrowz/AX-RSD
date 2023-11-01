import CommuteTypes::*;

/* should refactor impl*/
module Cable (
input
    logic clk,
    CtoMPort cpmodOut,
    MtoCPort mpmodOut,
output
    MtoCPort cpmodIn,
    CtoMPort mpmodIn
);  
    //parameter RST_DIFF = 330;
    //送受信にかかるレイテンシを適当に設定
    parameter MTOC_LATENCY = 105; //max(MTOC_LATENCY_A ... H)
    parameter MTOC_LATENCY_A = 67;
    parameter MTOC_LATENCY_B = 89;
    parameter MTOC_LATENCY_C = 23;
    parameter MTOC_LATENCY_D = 36;
    parameter MTOC_LATENCY_E = 99;
    parameter MTOC_LATENCY_F = 27;
    parameter MTOC_LATENCY_G = 105;
    parameter MTOC_LATENCY_H = 27;
    parameter CTOM_LATENCY = 113; //max(CTOM_LATENCY_A ... C)
    parameter CTOM_LATENCY_A = 25;
    parameter CTOM_LATENCY_B = 113;
    parameter CTOM_LATENCY_C = 89;
    logic [MTOC_PORT_NUM-1:0] mToc [MTOC_LATENCY:0] ;
    logic [CTOM_PORT_NUM-1:0] cTom [CTOM_LATENCY:0] ;

    always_ff@( negedge clk ) begin
        mToc[0] <= mpmodOut;
        for(int i = 0; i < MTOC_LATENCY_A; i++) mToc[i+1][0] <= mToc[i][0];
        for(int i = 0; i < MTOC_LATENCY_B; i++) mToc[i+1][1] <= mToc[i][1];
        for(int i = 0; i < MTOC_LATENCY_C; i++) mToc[i+1][2] <= mToc[i][2];
        for(int i = 0; i < MTOC_LATENCY_D; i++) mToc[i+1][3] <= mToc[i][3];
        for(int i = 0; i < MTOC_LATENCY_F; i++) mToc[i+1][4] <= mToc[i][4];
        for(int i = 0; i < MTOC_LATENCY_G; i++) mToc[i+1][5] <= mToc[i][5];
        for(int i = 0; i < MTOC_LATENCY_H; i++) mToc[i+1][6] <= mToc[i][6];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][7] <= mToc[i][7];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][8] <= mToc[i][8];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][9] <= mToc[i][9];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][10] <= mToc[i][10];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][11] <= mToc[i][11];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][12] <= mToc[i][12];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][13] <= mToc[i][13];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][14] <= mToc[i][14];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][15] <= mToc[i][15];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][16] <= mToc[i][16];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][17] <= mToc[i][17];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][18] <= mToc[i][18];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][19] <= mToc[i][19];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][20] <= mToc[i][20];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][21] <= mToc[i][21];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][22] <= mToc[i][22];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][23] <= mToc[i][23];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][24] <= mToc[i][24];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][25] <= mToc[i][25];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][26] <= mToc[i][26];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][27] <= mToc[i][27];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][28] <= mToc[i][28];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][29] <= mToc[i][29];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][30] <= mToc[i][30];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][31] <= mToc[i][31];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][32] <= mToc[i][32];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][33] <= mToc[i][33];
		for(int i = 0; i < MTOC_LATENCY_E; i++) mToc[i+1][34] <= mToc[i][34];
        //for(int i = 0; i < MTOC_LATENCY_E; i++) begin
        //    for(int j = 8; j < MTOC_PORT_NUM; j++) begin
        //        mToc[i+1][j] <= mToc[i][j];
        //    end
        //end
        cpmodIn[0] <= mToc[MTOC_LATENCY_A][0];
        cpmodIn[1] <= mToc[MTOC_LATENCY_B][1];
        cpmodIn[2] <= mToc[MTOC_LATENCY_C][2];
        cpmodIn[3] <= mToc[MTOC_LATENCY_D][3];
        cpmodIn[4] <= mToc[MTOC_LATENCY_F][4];
        cpmodIn[5] <= mToc[MTOC_LATENCY_G][5];
        cpmodIn[6] <= mToc[MTOC_LATENCY_H][6];
        for(int j = 7; j < MTOC_PORT_NUM; j++) cpmodIn[j] <= mToc[MTOC_LATENCY_E][j];
        
        cTom[0] <= cpmodOut;
        for(int i = 0; i < CTOM_LATENCY_B; i++) cTom[i+1][0] <= cTom[i][0];
        for(int i = 0; i < CTOM_LATENCY_C; i++) cTom[i+1][1] <= cTom[i][1];
        for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][2] <= cTom[i][2];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][3] <= cTom[i][3];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][4] <= cTom[i][4];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][5] <= cTom[i][5];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][6] <= cTom[i][6];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][7] <= cTom[i][7];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][8] <= cTom[i][8];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][9] <= cTom[i][9];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][10] <= cTom[i][10];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][11] <= cTom[i][11];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][12] <= cTom[i][12];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][13] <= cTom[i][13];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][14] <= cTom[i][14];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][15] <= cTom[i][15];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][16] <= cTom[i][16];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][17] <= cTom[i][17];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][18] <= cTom[i][18];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][19] <= cTom[i][19];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][20] <= cTom[i][20];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][21] <= cTom[i][21];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][22] <= cTom[i][22];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][23] <= cTom[i][23];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][24] <= cTom[i][24];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][25] <= cTom[i][25];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][26] <= cTom[i][26];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][27] <= cTom[i][27];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][28] <= cTom[i][28];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][29] <= cTom[i][29];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][30] <= cTom[i][30];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][31] <= cTom[i][31];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][32] <= cTom[i][32];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][33] <= cTom[i][33];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][34] <= cTom[i][34];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][35] <= cTom[i][35];
		for(int i = 0; i < CTOM_LATENCY_A; i++) cTom[i+1][36] <= cTom[i][36];
        //for(int i = 0; i < CTOM_LATENCY_A; i++) begin
        //    for(int j = 3; j < CTOM_PORT_NUM; j++) begin
        //        cTom[i+1][j] <= cTom[i][j];
        //    end
        //end
        mpmodIn[0] <= cTom[CTOM_LATENCY_B][0];
        mpmodIn[1] <= cTom[CTOM_LATENCY_C][1];
        //mpmodIn[3] <= cTom[MTOC_LATENCY_A][3];
        for(int j = 2; j < CTOM_PORT_NUM; j++) mpmodIn[j] <= cTom[CTOM_LATENCY_A][j];
        //$display("cout:%b, cin:%b",cpmodOut, cpmodIn);
    end

endmodule : Cable
