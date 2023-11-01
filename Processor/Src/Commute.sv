import BasicTypes::*;
import CacheSystemTypes::*;
import MemoryTypes::*;
import DebugTypes::*;
import MemoryMapTypes::*;
import IO_UnitTypes::*;
import CommuteTypes::*;

module Commute (
input
    logic clk,
    logic rst,
    logic [CTOM_BUS_WIDTH-1:0] memAccessIn,
    logic serialIn,
    logic lastCommittedPCIn,
    MemAccessSerial nextMemReadSerial, // RSDの次の読み出し要求に割り当てられるシリアル(id)
    MemWriteSerial nextMemWriteSerial, // RSDの次の書き込み要求に割り当てられるシリアル(id)
    MemoryEntryDataPath memReadData,
    logic memReadDataReady,
    MemAccessSerial memReadSerial, // メモリの読み出しデータのシリアル
    MemAccessResponse memAccessResponse, // メモリ書き込み完了通知
    logic memAccessReadBusy,
    logic memAccessWriteBusy,
output
    logic memAccessReadBusyOut,
    logic memAccessWriteBusyOut,
    logic memAccessReadOut,
    logic memAccessWriteOut,
    logic [MTOC_BUS_WIDTH-1:0] memReadDataOut,
    logic memWriteOut,
    ////DebugRegister debugRegister,
    PC_Path lastCommittedPC,
    PhyAddrPath memAccessAddr,
    MemoryEntryDataPath memAccessWriteData,
    logic memAccessRE,
    logic memAccessWE,
    logic serialWE,
    SerialDataPath serialWriteData,
    logic debugLED
);

    logic rstn;
    assign rstn = ~rst;

    //
    logic memAccessAddrDataE;
    MemoryAccessAddrData memAccessAddrData;
    ////
    logic lastCommittedPCE;
    ////next Serial
    logic memReadSerialEnable;
    logic memWriteSerialEnable;
    MemAccessSerial preNextMemReadSerial; 
    MemWriteSerial preNextMemWriteSerial; 
    ////read Data
    MemoryReadDataSerial memReadDataSerial;
    //
    generate
        MultiRecieve #(
            .BUSWIDTH(CTOM_BUS_WIDTH),
        //Recieve #(
            .DATASIZE($bits(memAccessAddrData)),
            .CLK_DIV(COM_MEM_CLK_DIV),
            .START_BIT_JUDGE_COUNT(COM_MEM_START_BIT_JUDGE_COUNT),
            .CHECK_POINT(COM_MEM_CHECK_POINT)
        )rec1(
            .clk(clk),
            .rstn(rstn),
            .rec(memAccessIn),
            .de(memAccessAddrDataE),
            .data(memAccessAddrData)
        );
    endgenerate
    assign memAccessRE = memAccessAddrDataE ? memAccessAddrData.re : FALSE;
    assign memAccessWE = memAccessAddrDataE ? memAccessAddrData.we : FALSE;
    assign memAccessAddr = memAccessAddrData.addr;
    assign memAccessWriteData = memAccessAddrData.data;

    generate
        Recieve #(
            .DATASIZE($bits(serialWriteData)),
            .CLK_DIV(COM_MEM_CLK_DIV),
            .START_BIT_JUDGE_COUNT(COM_MEM_START_BIT_JUDGE_COUNT),
            .CHECK_POINT(COM_MEM_CHECK_POINT)
        )rec2(
            .clk(clk),
            .rstn(rstn),
            .rec(serialIn),
            .de(serialWE),
            .data(serialWriteData)
        );
    endgenerate

    generate
        Recieve #(
            .DATASIZE($bits(lastCommittedPC)),
            .CLK_DIV(COM_MEM_CLK_DIV),
            .START_BIT_JUDGE_COUNT(COM_MEM_START_BIT_JUDGE_COUNT),
            .CHECK_POINT(COM_MEM_CHECK_POINT)
        )rec3(
            .clk(clk),
            .rstn(rstn),
            .rec(lastCommittedPCIn),
            .de(lastCommittedPCE),
            .data(lastCommittedPC)
        );
    endgenerate

//Send
    assign memAccessReadBusyOut = memAccessReadBusy;
    assign memAccessWriteBusyOut = memAccessWriteBusy;
//
    always_ff@(posedge clk) begin
        memReadSerialEnable <= (preNextMemReadSerial == nextMemReadSerial) ? FALSE : TRUE ;
        preNextMemReadSerial <= nextMemReadSerial;
    end
    generate
        BufferSend # (
            .DATASIZE($bits(nextMemReadSerial)),
            .CLK_DIV(COM_MEM_CLK_DIV)
        ) send1 (
            .se(memReadSerialEnable),
            .data(nextMemReadSerial),
            .clk(clk),   
            .rstn(rstn),
            .sendData(memAccessReadOut)
        );
    endgenerate
    
    always_ff@(posedge clk) begin
        memWriteSerialEnable <= (preNextMemWriteSerial == nextMemWriteSerial) ? FALSE : TRUE;
        preNextMemWriteSerial <= nextMemWriteSerial;
    end
    generate
        BufferSend # (
            .DATASIZE($bits(nextMemWriteSerial)),
            .CLK_DIV(COM_MEM_CLK_DIV)
        ) send5 (
            .se(memWriteSerialEnable),
            .data(nextMemWriteSerial),
            .clk(clk),   
            .rstn(rstn),
            .sendData(memAccessWriteOut)
        );
    endgenerate

    assign memReadDataSerial.data = memReadData;
    assign memReadDataSerial.serial = memReadSerial;
    logic tmp;
    generate
        BufferMultiSend # (
            .BUSWIDTH(MTOC_BUS_WIDTH),
        //Send # (
            .DATASIZE($bits(memReadDataSerial)),
            .CLK_DIV(COM_MEM_CLK_DIV)
        ) send2 (
            .se(memReadDataReady),
            .data(memReadDataSerial),
            .clk(clk),   
            .rstn(rstn),
            .sendData(memReadDataOut)
        );
    endgenerate
//
    generate
        BufferSend # (
            .DATASIZE($bits(memAccessResponse.serial)),
            .CLK_DIV(COM_MEM_CLK_DIV)
        ) send3 (
            .se(memAccessResponse.valid),
            .data(memAccessResponse.serial),
            .clk(clk),   
            .rstn(rstn),
            .sendData(memWriteOut)
        );
    endgenerate

    logic [25:0] dc;
    logic dd,dde;
    logic [9:0] dce;
    always_ff @(posedge clk) begin
        if(rstn == 1'b0) begin
            dc <= 0;
            dd <= 1'b0;
        end 
        else begin
            dc <= dc + 1;
            if(dc == 26'b0100) dd <= ~dd;
        end
    end
    always_ff @(posedge clk) begin
        if(rstn == 1'b0) begin
            dce <= 0;
            dde <= 1'b0;
        end 
        else begin
            dce <= dce + 1;
            if(dce == 10'b0100) dde <= 1'b1;
            else dde <= 1'b0;
        end
    end
    
    generate
        Send # (
            .DATASIZE(1),
            .CLK_DIV(COM_MEM_CLK_DIV)
        ) send4 (
            .se(dde),
            .data(dd),
            .clk(clk),   
            .rstn(rstn),
            .sendData(debugLED)
        );
    endgenerate

endmodule : Commute

module CommuteCore(
input
    logic clk,
    logic rst,
    logic memAccessReadBusyIn,
    logic memAccessWriteBusyIn,
    logic memAccessReadIn,
    logic memAccessWriteIn,
    logic [MTOC_BUS_WIDTH-1:0] memReadDataIn,
    logic memWriteIn,
    //DebugRegister debugRegister,
    PC_Path lastCommittedPC,
    PhyAddrPath memAccessAddr,
    MemoryEntryDataPath memAccessWriteData,
    logic memAccessRE,
    logic memAccessWE,
    logic serialWE,
    SerialDataPath serialWriteData,
    logic debugLED,
output
    logic [CTOM_BUS_WIDTH-1:0] memAccessOut,
    logic serialOut,
    logic lastCommittedPCOut,
    MemAccessSerial nextMemReadSerial, // RSDの次の読み出し要求に割り当てられるシリアル(id)
    MemWriteSerial nextMemWriteSerial, // RSDの次の書き込み要求に割り当てられるシリアル(id)
    MemoryEntryDataPath memReadData,
    logic memReadDataReady,
    MemAccessSerial memReadSerial, // メモリの読み出しデータのシリアル
    MemAccessResponse memAccessResponse, // メモリ書き込み完了通知
    logic memAccessReadBusy,
    logic memAccessWriteBusy,
    logic dled
);

    logic rstn;
    assign rstn = ~rst;

    ////next Serial
    logic memReadSerialEnable;
    logic memWriteSerialEnable;
    //logic memAccessWriteRecieving;
    ////read Data
    MemoryReadDataSerial memReadDataSerial;
    ////
    MemoryAccessAddrData memAccessAddrData;
    ////
    logic memSendDataE;
    logic memSendBusy;
    ////
    logic lastCommittedPCSe;
    //PC_Path prelastCommittedPC;
    logic lastCommitedPCSending;
//  
    MemAccessSerial preNextMemReadSerial;
    logic memReadAck;
    generate
        Recieve #(
            .DATASIZE( $bits(nextMemReadSerial) ),
            .CLK_DIV(COM_CLK_DIV),
            .START_BIT_JUDGE_COUNT(COM_START_BIT_JUDGE_COUNT),
            .CHECK_POINT(COM_CHECK_POINT)
        )rec1(
            .clk(clk),
            .rstn(rstn),
            .rec(memAccessReadIn),
            .de(memReadSerialEnable),
            .data(nextMemReadSerial)
        );
    endgenerate

    always_ff@(posedge clk) begin
        memReadAck <= (rstn == FALSE) ? FALSE :
                      memAccessRE ? TRUE :
                      (preNextMemReadSerial == nextMemReadSerial) ? memReadAck : FALSE;
        preNextMemReadSerial <= (rstn == FALSE) ? 0 : nextMemReadSerial;
    end

    generate
        Recieve #(
            .DATASIZE($bits(nextMemWriteSerial)),
            .CLK_DIV(COM_CLK_DIV),
            .START_BIT_JUDGE_COUNT(COM_START_BIT_JUDGE_COUNT),
            .CHECK_POINT(COM_CHECK_POINT)
        )rec2(
            .clk(clk),
            .rstn(rstn),
            .rec(memAccessWriteIn),
            .de(memWriteSerialEnable),
            .data(nextMemWriteSerial)
        );
    endgenerate
    
    //$bits(nextMemWriteSerial) =1 
    MemWriteSerial preNextMemWriteSerial;
    logic memWriteAck;
    always_ff@(posedge clk) begin
        memWriteAck <= (rstn == FALSE) ? FALSE :
                      memAccessWE ? TRUE :
                      (preNextMemWriteSerial == nextMemWriteSerial) ? memWriteAck : FALSE;
        preNextMemWriteSerial <= (rstn == FALSE) ? 0 : nextMemWriteSerial;
    end

    assign memAccessReadBusy = memAccessReadBusyIn || memSendBusy || memReadAck;
    assign memAccessWriteBusy = memAccessWriteBusyIn || memSendBusy || memWriteAck;
//
    generate
        MultiRecieve #(
            .BUSWIDTH(MTOC_BUS_WIDTH),
        //Recieve #(
            .DATASIZE($bits(memReadDataSerial)),
            .CLK_DIV(COM_CLK_DIV),
            .START_BIT_JUDGE_COUNT(COM_START_BIT_JUDGE_COUNT),
            .CHECK_POINT(COM_CHECK_POINT)
        )rec3(
            .clk(clk),
            .rstn(rstn),
            .rec(memReadDataIn),
            .de(memReadDataReady),
            .data(memReadDataSerial)
        );
    endgenerate
//
    assign memReadData = memReadDataSerial.data;
    assign memReadSerial = memReadDataSerial.serial;
//
    generate
        Recieve #(
            .DATASIZE($bits(memAccessResponse.serial)),
            .CLK_DIV(COM_CLK_DIV),
            .START_BIT_JUDGE_COUNT(COM_START_BIT_JUDGE_COUNT),
            .CHECK_POINT(COM_CHECK_POINT)
        )rec4(
            .clk(clk),
            .rstn(rstn),
            .rec(memWriteIn),
            .de(memAccessResponse.valid),
            .data(memAccessResponse.serial)
        );
    endgenerate
//
    ////Send
//
    assign memSendDataE = memAccessRE || memAccessWE;
    assign memAccessAddrData.re = memAccessRE;
    assign memAccessAddrData.we = memAccessWE;
    
    assign memAccessAddrData.addr = memAccessAddr;
    assign memAccessAddrData.data = memAccessWriteData;

    generate
        BufferMultiBusySend # (
            .BUSWIDTH(CTOM_BUS_WIDTH),
        //BusySend # (
            .DATASIZE($bits(memAccessAddrData)),
            .CLK_DIV(COM_CLK_DIV)
        ) send1 (
            .se(memSendDataE),
            .data(memAccessAddrData),
            .clk(clk),
            .rstn(rstn),
            .sendData(memAccessOut),
            .sending(memSendBusy)
        );
    endgenerate
//
    //always_ff@( negedge clk ) begin
    //    $display("comCoreDE:%b, addrD:%b, reb:%b, wbe:%b", memSendDataE, memAccessAddrData, memAccessReadBusy, memAccessWriteBusy);
    //end
    generate
        BufferSend # (
            .DATASIZE($bits(serialWriteData)),
            .CLK_DIV(COM_CLK_DIV),
            .BUFFER_SIZE(128)
        ) send2 (
            .se(serialWE),
            .data(serialWriteData),
            .clk(clk),
            .rstn(rstn),
            .sendData(serialOut)
        );
    endgenerate
    //
    //always_ff@(posedge clk) begin
    //    lastCommittedPCSe = (prelastCommittedPC == lastCommittedPC) ? 1'b0 : 1'b1;
    //    prelastCommittedPC <= lastCommittedPC;
    //end
    assign lastCommittedPCSe = ~lastCommitedPCSending;
    generate
        BusySend # (
            .DATASIZE($bits(lastCommittedPC)),
            .CLK_DIV(COM_CLK_DIV)
        ) send3 (
            .se(lastCommittedPCSe),
            .data(lastCommittedPC),
            .clk(clk),   
            .rstn(rstn),
            .sendData(lastCommittedPCOut),
            .sending(lastCommitedPCSending)
        );
    endgenerate

    logic dtmp;
    generate
        Recieve #(
            .DATASIZE($bits(dled)),
            .CLK_DIV(COM_CLK_DIV),
            .START_BIT_JUDGE_COUNT(COM_START_BIT_JUDGE_COUNT),
            .CHECK_POINT(COM_CHECK_POINT)
        )rec5(
            .clk(clk),
            .rstn(rstn),
            .rec(debugLED),
            .de(dtmp),
            .data(dled)
        );
    endgenerate
endmodule : CommuteCore
    
