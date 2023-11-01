package CommuteTypes;
    
import BasicTypes::*;
import CacheSystemTypes::*;
import MemoryTypes::*;
import DebugTypes::*;
import MemoryMapTypes::*;
import IO_UnitTypes::*;
import MicroArchConf::*;

// パラメータの変更は、Cable.svの書き換え(design_1.tcl, component.xmlも)を必要とする
localparam MTOC_BUS_WIDTH = CONF_MTOC_BUS_WIDTH;
localparam CTOM_BUS_WIDTH = CONF_CTOM_BUS_WIDTH; 
localparam MTOC_PORT_NUM = 7 + MTOC_BUS_WIDTH;
localparam CTOM_PORT_NUM = 2 + CTOM_BUS_WIDTH; 
typedef logic [ MTOC_PORT_NUM-1:0 ] MtoCPort;
typedef logic [ CTOM_PORT_NUM-1:0 ] CtoMPort;

localparam COM_CLK_DIV = CONF_COM_CLK_DIV;
localparam COM_START_BIT_JUDGE_COUNT = CONF_COM_START_BIT_JUDGE_COUNT;
localparam COM_CHECK_POINT = CONF_COM_CHECK_POINT;
localparam COM_MEM_CLK_DIV = CONF_COM_MEM_CLK_DIV;
localparam COM_MEM_START_BIT_JUDGE_COUNT = CONF_COM_MEM_START_BIT_JUDGE_COUNT;
localparam COM_MEM_CHECK_POINT = CONF_COM_MEM_CHECK_POINT;

typedef struct packed {
    MemoryEntryDataPath data;
    MemAccessSerial serial;
} MemoryReadDataSerial;

typedef struct packed {
    logic re;
    logic we;
    PhyAddrPath addr;
    MemoryEntryDataPath data;
} MemoryAccessAddrData;

endpackage
