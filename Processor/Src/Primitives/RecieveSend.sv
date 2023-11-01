module BufferMultiBusySend #(
    parameter BUSWIDTH = 4,
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4, //power of 2
    parameter BUFFER_SIZE = 32
)(
    input
      logic se,   //Raise to transmit byte
      logic [DATASIZE-1:0] data,  
      logic clk,  
      logic rstn,   
    output
      logic [BUSWIDTH-1:0] sendData, //transmit wire
      logic sending
);
    logic [DATASIZE-1:0] bufferData[BUFFER_SIZE];
    logic [$clog2(BUFFER_SIZE)-1:0] headPtr, tailPtr;
    logic se_i;
    logic [DATASIZE-1:0] data_i;
    logic push, pop, full, empty;
    logic [DATASIZE-1:0] prevdata;  
    
    always_ff @(posedge clk) begin
        if(push) bufferData[tailPtr] <= data;
        prevdata <= data;
    end

    always_comb begin
        if(!rstn) begin
            push = 1'b0;
            pop = 1'b0;
        end
        else if(se && sending && (!full) /*&& prevdata != data*/) begin
            push = 1'b1;
            pop = 1'b0;
        end
        else if( (!empty) && (!sending) )begin
            push = 1'b0;
            pop = 1'b1;
        end
        else begin
            push = 1'b0;
            pop = 1'b0; 
        end
        se_i = pop ? 1'b1 : se;
        data_i = pop ? bufferData[headPtr] : data;
    end
    
    generate
        QueuePointer #(
            .SIZE( BUFFER_SIZE )
        )
        bufQueuePointer(
            .clk(clk),
            .rst(~rstn),
            .push(push),
            .pop(pop),
            .full(full),
            .empty(empty),
            .headPtr(headPtr),
            .tailPtr(tailPtr)    
        );

        MultiBusySend#(
            .BUSWIDTH(BUSWIDTH),
            .DATASIZE(DATASIZE), 
            .CLK_DIV(CLK_DIV)
        ) send (
            .se(se_i),
            .data(data_i),
            .clk(clk),
            .rstn(rstn),
            .sendData(sendData),
            .sending(sending)
        );
    endgenerate

endmodule : BufferMultiBusySend

module BufferMultiSend #(
    parameter BUSWIDTH = 4,
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4, //power of 2
    parameter BUFFER_SIZE = 32
)(
    input
      logic se,   //Raise to transmit byte
      logic [DATASIZE-1:0] data,  
      logic clk,  
      logic rstn,   
    output
      logic [BUSWIDTH-1:0] sendData //transmit wire
);
    logic sending;
    logic [DATASIZE-1:0] bufferData[BUFFER_SIZE];
    logic [$clog2(BUFFER_SIZE)-1:0] headPtr, tailPtr;
    logic se_i;
    logic [DATASIZE-1:0] data_i;
    logic push, pop, full, empty;
    logic [DATASIZE-1:0] prevdata;  
    
    always_ff @(posedge clk) begin
        if(push) bufferData[tailPtr] <= data;
        prevdata <= data;
    end

    always_comb begin
        if(!rstn) begin
            push = 1'b0;
            pop = 1'b0;
        end
        else if(se && sending && (!full) ) begin
            push = 1'b1;
            pop = 1'b0;
        end
        else if( (!empty) && (!sending) )begin
            push = 1'b0;
            pop = 1'b1;
        end
        else begin
            push = 1'b0;
            pop = 1'b0; 
        end
        se_i = pop ? 1'b1 : se;
        data_i = pop ? bufferData[headPtr] : data;
    end
    
    generate
        QueuePointer #(
            .SIZE( BUFFER_SIZE )
        )
        bufQueuePointer(
            .clk(clk),
            .rst(~rstn),
            .push(push),
            .pop(pop),
            .full(full),
            .empty(empty),
            .headPtr(headPtr),
            .tailPtr(tailPtr)    
        );

        MultiBusySend#(
            .BUSWIDTH(BUSWIDTH),
            .DATASIZE(DATASIZE), 
            .CLK_DIV(CLK_DIV)
        ) send (
            .se(se_i),
            .data(data_i),
            .clk(clk),
            .rstn(rstn),
            .sendData(sendData),
            .sending(sending)
        );
    endgenerate

endmodule : BufferMultiSend

module MultiBusySend #(
    parameter BUSWIDTH = 4,
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4 // power of 2
)(
    input
      logic se,   // Raise to transmit byte
      logic [DATASIZE-1:0] data,  
      logic clk,  
      logic rstn,   
    output
      logic [BUSWIDTH-1:0] sendData,    // transmit wires
      logic sending
);
    localparam PACKETSIZE = (DATASIZE - 1) / BUSWIDTH + 1;
    localparam LEFTOVER = DATASIZE - (PACKETSIZE - 1) * BUSWIDTH;
    localparam RCOUNT =  3;
    logic [$clog2(PACKETSIZE+4)-1:0] bitCount;
    logic [DATASIZE+BUSWIDTH-1:0] shifter;

    assign sending = |bitCount;
    
    //分周
    logic [$clog2(CLK_DIV)-1:0] d;
    always_ff @(posedge clk) begin
        if (!rstn) begin
            d <= '0;
        end else begin
            d <= d + 1;
        end
    end
    logic ser_clk;
    assign ser_clk = (d == '1) ? 1 : 0;
    /*
    dataをLSBのほうからBUSWIDTHずつ送信する。空いた部分はゼロ埋め
    */
    always_ff @(posedge clk) begin
      if (!rstn) begin
        sendData <= '1;
        bitCount <= 0;
        shifter <= 0;
      end else begin
        if (se & ~sending) begin
          bitCount <= 1 + PACKETSIZE + 2;
          shifter <= { data[DATASIZE-1:0], {BUSWIDTH{1'b0} }};
        end
        if (sending & ser_clk) begin
          bitCount <= bitCount - 1;
          if (bitCount == RCOUNT) begin
            //sendData <= data[DATASIZE-1: DATASIZE-LEFTOVER];
            sendData <= shifter[DATASIZE-(PACKETSIZE-1)*BUSWIDTH: 0];
            shifter <= '1;
          end else begin
            {shifter, sendData } <= {{BUSWIDTH{1'b1}}, shifter};
          end
        end
      end
    end
  
endmodule : MultiBusySend

module MultiRecieve #(
    parameter BUSWIDTH = 4,
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4, 
    parameter START_BIT_JUDGE_COUNT = 3, 
    parameter CHECK_POINT = 2
)(
    input 
        logic clk,
        logic rstn, 
        logic [BUSWIDTH-1:0] rec,
    output
        logic de,
        logic[DATASIZE-1:0] data 
);
    localparam PACKETSIZE = (DATASIZE - 1) / BUSWIDTH + 1;
    localparam COUNT_MAX = PACKETSIZE * CLK_DIV;
    localparam CHECK_POINT_COUNT = CLK_DIV - START_BIT_JUDGE_COUNT + CHECK_POINT - 2;
    localparam COUNT_LAST = (PACKETSIZE - 1) * CLK_DIV + CHECK_POINT_COUNT;
    localparam LEFTOVER = DATASIZE - (PACKETSIZE - 1) * BUSWIDTH;
    // to avoid simulator warning
    localparam LO = (PACKETSIZE == 1) ? 0 : LEFTOVER;
    localparam BW = (PACKETSIZE == 1) ? 0 : BUSWIDTH;
    
    logic dei;
    logic [1:0] state;
    logic [START_BIT_JUDGE_COUNT-1:0] startbit;
    logic [$clog2(CLK_DIV)-1:0] clkCount;
    logic [$clog2(COUNT_MAX)-1:0] dCount;
    logic [DATASIZE-1:0] recData;
 
    always_ff @(posedge clk) begin
        if(rstn == 1'b0) begin
            startbit <= (1 << START_BIT_JUDGE_COUNT) - 1;
            state <= 2'b00;
            dei <= 1'b0;
            dCount <= 0;
            clkCount <= 0;
            recData <= 0;
        end
        else begin
            startbit <= {startbit[START_BIT_JUDGE_COUNT-2:0], rec[0]};
            case(state)
                2'b00:begin
                    dei <= 1'b0;
                    if(startbit == 0) begin
                        state <= 2'b01;
                        clkCount <= 0;
                        dCount <= 0;
                    end
                end
                2'b01:begin
                    clkCount <= clkCount + 1'b1;//rap around
                    dCount <= dCount + 1'b1;
                    if(clkCount == CHECK_POINT_COUNT) begin
                        if (PACKETSIZE == 1) begin
                            recData <= rec[LEFTOVER-1:0];
                        end else if (dCount == COUNT_LAST) begin
                            recData <= {rec[LEFTOVER-1:0], recData[DATASIZE-1: LO]};
                        end else begin
                            recData <= {rec, recData[DATASIZE-1:BW]};
                        end
                    end
                    if(dCount == COUNT_MAX-1) begin
                        state <= 2'b11;
                        dei <= 1'b1;
                    end
                end
                2'b11:begin
                    clkCount <= clkCount + 1'b1;
                    dCount <= dCount + 1'b1;
                    dei <= 1'b0;
                    if(clkCount == CLK_DIV - 2) begin //
                        state <= 2'b00;
                    end
                end
                default:begin
                    state <= 2'b00;
                end
            endcase
        end
    end
    
    always_ff @(posedge clk) begin
        if(rstn == 1'b0) data <= 0;
        else data <= dei ? recData : data;
        if(rstn == 1'b0) de <= 0;
        else de <= dei;
    end
 
endmodule : MultiRecieve

module MultiSend #(
    parameter BUSWIDTH = 4,
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4 //power of 2
)(
    input
      logic se,   //Raise to transmit byte
      logic [DATASIZE-1:0] data,  
      logic clk,  
      logic rstn,   
    output
      logic [BUSWIDTH-1:0] sendData //transmit wire
);

    logic sending;

    generate
        MultiBusySend#(
            .BUSWIDTH(BUSWIDTH),
            .DATASIZE(DATASIZE), 
            .CLK_DIV(CLK_DIV)
        ) send (
            .se(se),
            .data(data),
            .clk(clk),
            .rstn(rstn),
            .sendData(sendData),
            .sending(sending)
        );
    endgenerate
endmodule : MultiSend

module Recieve #(
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4, 
    parameter START_BIT_JUDGE_COUNT = 3, 
    parameter CHECK_POINT = 2
)(
    input 
        logic clk,
        logic rstn, 
        logic rec,
    output
        logic de,
        logic[DATASIZE-1:0] data 
);
    localparam COUNT_MAX = DATASIZE * CLK_DIV;
    localparam CHECK_POINT_COUNT = CLK_DIV - START_BIT_JUDGE_COUNT + CHECK_POINT - 2;
    localparam DS = (DATASIZE == 1) ? 0 : 1;
    logic dei;
    logic [1:0] state;
    logic [START_BIT_JUDGE_COUNT-1:0] startbit;
    logic [$clog2(CLK_DIV)-1:0] clkCount;
    logic [$clog2(COUNT_MAX)-1:0] dCount;
    logic [DATASIZE-1:0] recData;
 
    always_ff @(posedge clk) begin
        if(rstn == 1'b0) begin
            startbit <= (1 << START_BIT_JUDGE_COUNT) - 1;
            state <= 2'b00;
            dei <= 1'b0;
            dCount <= 0;
            clkCount <= 0;
            recData <= 0;
        end
        else begin
            startbit <= {startbit[START_BIT_JUDGE_COUNT-2:0], rec};
            case(state)
                2'b00:begin
                    dei <= 1'b0;
                    if(startbit == 0) begin
                        state <= 2'b01;
                        clkCount <= 0;
                        dCount <= 0;
                    end
                end
                2'b01:begin
                    clkCount <= clkCount + 1'b1;//rap around
                    dCount <= dCount + 1'b1;
                    if(clkCount == CHECK_POINT_COUNT) begin
                        if(DATASIZE == 1)
                            recData <= rec;
                        else
                            recData <= {rec, recData[DATASIZE-1:DS]};
                    end
                    if(dCount == COUNT_MAX-1) begin
                        state <= 2'b11;
                        dei <= 1'b1;
                    end
                end
                2'b11:begin
                    clkCount <= clkCount + 1'b1;
                    dCount <= dCount + 1'b1;
                    dei <= 1'b0;
                    if(clkCount == CLK_DIV - 2) begin //
                        state <= 2'b00;
                    end
                end
                default:begin
                    state <= 2'b00;
                end
            endcase
        end
    end
    
    always_ff @(posedge clk) begin
        if(rstn == 1'b0) data <= 0;
        else data <= dei ? recData : data;
        if(rstn == 1'b0) de <= 0;
        else de <= dei;
    end
 
endmodule : Recieve 

module BusySend #(
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4 // power of 2
)(
    input
      logic se,   // Raise to transmit byte
      logic [DATASIZE-1:0] data,  
      logic clk,  
      logic rstn,   
    output
      logic sendData,    // transmit wire
      logic sending
);
  
    logic [$clog2(DATASIZE+4)-1:0] bitCount;
    logic [DATASIZE:0] shifter;
    
    assign sending = |bitCount;
    
    //分周
    logic [$clog2(CLK_DIV)-1:0] d;
    always_ff @(posedge clk) begin
        if (!rstn) begin
            d <= '0;
        end else begin
            d <= d + 1;
        end
    end
    logic ser_clk;
    assign ser_clk = (d == '1) ? 1 : 0;

    always_ff @(posedge clk) begin
      if (!rstn) begin
        sendData  <= 1;
        bitCount <= 0;
        shifter <= 0;
      end else begin
        // just got a new byte
        if (se & ~sending) begin
          shifter <= { data[DATASIZE-1:0], 1'h0 };
          bitCount <= (1 + DATASIZE + 2);
        end
  
        if (sending & ser_clk) begin
          { shifter, sendData } <= { 1'h1, shifter };
          bitCount <= bitCount - 1;
        end
      end
    end
  
endmodule : BusySend

module Send #(
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4 //power of 2
)(
    input
      logic se,   //Raise to transmit byte
      logic [DATASIZE-1:0] data,  
      logic clk,  
      logic rstn,   
    output
      logic sendData //transmit wire
);

    logic sending;

    generate
        BusySend#(
            .DATASIZE(DATASIZE), 
            .CLK_DIV(CLK_DIV)
        ) send (
            .se(se),
            .data(data),
            .clk(clk),
            .rstn(rstn),
            .sendData(sendData),
            .sending(sending)
        );
    endgenerate
endmodule : Send

// 使えるけど、なんとなく未使用
module BufferSend #(
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4, //power of 2
    parameter BUFFER_SIZE = 32
)(
    input
      logic se,   //Raise to transmit byte
      logic [DATASIZE-1:0] data,  
      logic clk,  
      logic rstn,   
    output
      logic sendData //transmit wire
);

    logic sending;
    logic [DATASIZE-1:0] bufferData[BUFFER_SIZE];
    logic [$clog2(BUFFER_SIZE)-1:0] headPtr, tailPtr;
    logic se_i;
    logic [DATASIZE-1:0] data_i;
    logic push, pop, full, empty;
    logic [DATASIZE-1:0] prevdata;  
    
    always_ff @(posedge clk) begin
        if(push) bufferData[tailPtr] <= data;
        prevdata <= data;
    end

    always_comb begin
        if(!rstn) begin
            push = 1'b0;
            pop = 1'b0;
        end
        else if(se && sending && (!full)) begin
            push = 1'b1;
            pop = 1'b0;
        end
        else if( (!empty) && (!sending) )begin
            push = 1'b0;
            pop = 1'b1;
        end
        else begin
            push = 1'b0;
            pop = 1'b0; 
        end
        se_i = pop ? 1'b1 : se;
        data_i = pop ? bufferData[headPtr] : data;
    end
    
    generate
        QueuePointer #(
            .SIZE( BUFFER_SIZE )
        )
        bufQueuePointer(
            .clk(clk),
            .rst(~rstn),
            .push(push),
            .pop(pop),
            .full(full),
            .empty(empty),
            .headPtr(headPtr),
            .tailPtr(tailPtr)    
        );

        BusySend#(
            .DATASIZE(DATASIZE), 
            .CLK_DIV(CLK_DIV)
        ) send (
            .se(se_i),
            .data(data_i),
            .clk(clk),
            .rstn(rstn),
            .sendData(sendData),
            .sending(sending)
        );
    endgenerate

endmodule : BufferSend
/*
module TrueBufferSend #(
    parameter DATASIZE = 8,
    parameter CLK_DIV = 4, //power of 2
    parameter BUFFER_SIZE = 64
)(
    input
      logic se,   //Raise to transmit byte
      logic [DATASIZE-1:0] data,  
      logic clk,  
      logic rstn,   
    output
      logic sendData //transmit wire
);

    logic sending;
    logic [DATASIZE-1:0] bufferData[BUFFER_SIZE];
    logic [$clog2(BUFFER_SIZE)-1:0] headPtr, tailPtr;
    logic se_i;
    logic [DATASIZE-1:0] data_i;
    logic push, pop, full, empty;
    logic [DATASIZE-1:0] prevdata;  
    
    always_ff @(posedge clk) begin
        if(push) bufferData[tailPtr] <= data;
        prevdata <= data;
    end

    always_comb begin
        if(!rstn) begin
            push = 1'b0;
            pop = 1'b0;
        end
        else if(se && sending && (!full)) begin
            push = 1'b1;
            pop = 1'b0;
        end
        else if( (!empty) && (!sending) )begin
            push = 1'b0;
            pop = 1'b1;
        end
        else begin
            push = 1'b0;
            pop = 1'b0; 
        end
        se_i = pop ? 1'b1 : se;
        data_i = pop ? bufferData[headPtr] : data;
    end
    
    generate
        QueuePointer #(
            .SIZE( BUFFER_SIZE )
        )
        bufQueuePointer(
            .clk(clk),
            .rst(~rstn),
            .push(push),
            .pop(pop),
            .full(full),
            .empty(empty),
            .headPtr(headPtr),
            .tailPtr(tailPtr)    
        );

        BusySend#(
            .DATASIZE(DATASIZE), 
            .CLK_DIV(CLK_DIV)
        ) send (
            .se(se_i),
            .data(data_i),
            .clk(clk),
            .rstn(rstn),
            .sendData(sendData),
            .sending(sending)
        );
    endgenerate

endmodule : TrueBufferSend
*/