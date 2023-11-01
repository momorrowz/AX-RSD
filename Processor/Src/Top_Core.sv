import BasicTypes::*;
import CacheSystemTypes::*;
import MemoryTypes::*;
import DebugTypes::*;
import MemoryMapTypes::*;
import IO_UnitTypes::*;
import CommuteTypes::*; 
import FetchUnitTypes::*; 

module Top_Core(
`ifndef RSD_DISABLE_DEBUG_REGISTER
output
    DebugRegister debugRegister,
`endif
input
    logic clk,
    logic negResetIn,
    SW_Path swIn, // Switch Input
    PSW_Path pswIn, // Push Switch Input
    MtoCPort cpmodIn,
output
    CtoMPort cpmodOut,
    logic dled
);
`ifdef RSD_DISABLE_DEBUG_REGISTER
    DebugRegister debugRegister;
`endif
    logic [MTOC_BUS_WIDTH-1:0] memReadDataIn;
    logic [CTOM_BUS_WIDTH-1:0] memAccessOut;
    logic programLoaded, memAccessReadBusyIn, memAccessWriteBusyIn, memAccessReadIn, memAccessWriteIn;
    logic memWriteIn, debugLED, serialOut, lastCommittedPCOut;
    logic rst, rstStart, rstTrigger;

    // assign rstled = rst;
    assign memAccessReadBusyIn = cpmodIn[0]; //メモリ読み出し不可。（実際は、本信号 or 読み出し要求送信中 or 読み出し要求を受け取ってシリアル(id)を変更 で判定)
    assign memAccessWriteBusyIn = cpmodIn[1]; //メモリ書き込み不可。（実際は、本信号 or 書き込み要求送信中 or 書き込み要求を受け取ってシリアル(id)を変更 で判定)
    assign memAccessReadIn = cpmodIn[2]; //次の読み出し要求に割り当てられるシリアル(id)
    assign memAccessWriteIn = cpmodIn[3]; //次の書き込み要求に割り当てられるシリアル(id)
    assign memReadDataIn = cpmodIn[MTOC_BUS_WIDTH+6:7]; //メモリから読み出されたデータとシリアル(id)
    assign memWriteIn = cpmodIn[4]; //メモリ書き込み完了通知(中身はシリアル(id))
    always_ff@( posedge clk ) begin
        programLoaded <= cpmodIn[5]; // メモリにコードを読み込ませている間offになる。外部からリセットをかけ、onの時に動き始める
    end
    assign debugLED = cpmodIn[6]; //デシリアライズしてdledにつなげる。これによってpmodの入力とデシリアライズが出来ていることを確認

    assign cpmodOut[CTOM_BUS_WIDTH+1:2] = memAccessOut; //読み出し要求 or 書き込み要求（中身は、どちらの要求か and アドレス and データ)
    assign cpmodOut[0] = serialOut; //標準出力の代わり
    assign cpmodOut[1] = lastCommittedPCOut; //コミットしたpcの値を定期的に送っている。実装上残っているだけだが、標準出力に出ない場合のデバック用になりうる

    logic locked; // You must disable the reset signal (rst) after the clock generator is locked.
    assign locked = TRUE;
    // Generate a global reset signal 'rst' from 'rstTrigger'.
    assign rstTrigger = ~negResetIn;
    
    ResetControllerCore rstController(
        .clk( clk ),
        .rstTrigger( rstTrigger || !programLoaded ),
        .locked( locked ),
        .rst( rst ),
        .rstStart( rstStart )
    );

    // --- Memory and Program Loader
    //
    
    MemoryEntryDataPath memReadData;
    logic memReadDataReady;
    logic memAccessReadBusy;
    logic memAccessWriteBusy;
    //
    MemoryEntryDataPath memAccessWriteData;
    MemoryEntryDataPath memAccessWriteDataFromCore;
//
    PhyAddrPath memAccessAddrFromCore;
//
    logic memAccessRE, memAccessRE_FromCore;
    logic memAccessWE, memAccessWE_FromCore;
//
    MemAccessSerial nextMemReadSerial; // RSDの次の読み出し要求に割り当てられるシリアル(id)
    MemWriteSerial nextMemWriteSerial; // RSDの次の書き込み要求に割り当てられるシリアル(id)
//
    MemAccessSerial memReadSerial; // メモリの読み出しデータのシリアル
    MemAccessResponse memAccessResponse; // メモリ書き込み完了通知
//
    logic serialWE;
    SerialDataPath serialWriteData;
    //DebugRegister debugRegister;
    PC_Path lastCommittedPC;


    CommuteCore commuteCore (
    //    //input
        .clk( clk ),
//
        .rst( rst ),
//
    //    //input
        .memAccessReadBusyIn( memAccessReadBusyIn ),
        .memAccessWriteBusyIn( memAccessWriteBusyIn ),
        .memAccessReadIn( memAccessReadIn ),
        .memAccessWriteIn( memAccessWriteIn ),
        .memReadDataIn( memReadDataIn ),
        .memWriteIn( memWriteIn ),
    //    //output
        .memAccessReadBusy( memAccessReadBusy ),
        .nextMemReadSerial( nextMemReadSerial ),
        .memAccessWriteBusy( memAccessWriteBusy ),
        .nextMemWriteSerial( nextMemWriteSerial ),
        .memReadDataReady( memReadDataReady ),
        .memReadData( memReadData ),
        .memReadSerial( memReadSerial ),
//
        .memAccessResponse( memAccessResponse ),// メモリ書き込み完了通知 validとserial
    //    //output
        .memAccessOut( memAccessOut ),
        .serialOut( serialOut ),
        .lastCommittedPCOut( lastCommittedPCOut ),
    //    //input
        .memAccessRE( memAccessRE_FromCore ),
        .memAccessWE( memAccessWE_FromCore ),
        .memAccessAddr( memAccessAddrFromCore ),
        .memAccessWriteData( memAccessWriteDataFromCore ),
    //
        .serialWE( serialWE ),
        .serialWriteData( serialWriteData ),
//
        .lastCommittedPC( lastCommittedPC ),
//
    //    .debugRegister ( debugRegister )
          .debugLED( debugLED ),
          .dled( dled )
    );
    logic reqExternalInterrupt;
    ExternalInterruptCodePath externalInterruptCode; 
    always_comb begin
        reqExternalInterrupt = FALSE;
        externalInterruptCode = 0;
    end

    // --- Switch IO => axLevel, gaze
    logic axLevelEn;
    logic [ AX_LEVEL_WIDTH-1:0 ] axLevelData;
    GazeDataPath gazeIn;

    always_ff @( posedge clk ) begin
        axLevelEn <= pswIn[0];
        axLevelData <= {pswIn[ AX_LEVEL_WIDTH - 2 : 1], 2'b0};
        //axLevelData <= pswIn[AX_LEVEL_WIDTH:1];
        gazeIn <= swIn;
    end

    Core core (
        .clk( clk ),
        .rst( rst ),
        .memAccessAddr( memAccessAddrFromCore ),
        .memAccessWriteData( memAccessWriteDataFromCore ),
        .memAccessRE( memAccessRE_FromCore ),
        .memAccessWE( memAccessWE_FromCore ),
        .memAccessReadBusy( memAccessReadBusy ),
        .memAccessWriteBusy( memAccessWriteBusy ),
        .reqExternalInterrupt( reqExternalInterrupt ),
        .externalInterruptCode( externalInterruptCode ),
        .nextMemReadSerial( nextMemReadSerial ),
        .nextMemWriteSerial( nextMemWriteSerial ),
        .memReadDataReady( memReadDataReady ),
        .memReadData( memReadData ),
        .memReadSerial( memReadSerial ),
        .memAccessResponse( memAccessResponse ),
        .rstStart( rstStart ),
        .serialWE( serialWE ),
        .serialWriteData( serialWriteData ),
        .lastCommittedPC( lastCommittedPC ),
        .debugRegister ( debugRegister ),
        .axLevelData(axLevelData),
        .axLevelEn(axLevelEn),
        .gazeIn(gazeIn)
    );
    
endmodule : Top_Core
