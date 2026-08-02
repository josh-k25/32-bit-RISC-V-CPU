module processor(
    input logic clk,
    input logic reset,
    input logic [31:0] instructionF,
    input logic [31:0] readDataM,

    output logic memoryWriteM,
    output logic [31:0] pc,
    output logic [31:0] aluResultM,
    output logic [31:0] writeData
);

logic [1:0] resultSourceD;
logic memoryWriteD;
logic aluSourceD;
logic [1:0] immediateSourceD;
logic registerWriteD;
logic [2:0] aluControlD;
logic branchD;
logic jumpD;

logic stallF;
logic stallD;
logic flushD;
logic flushE;
logic [1:0] forward1;
logic [1:0] forward2;
logic pcSourceE;
logic zeroE;
logic [31:0] instructionD;

logic [4:0] rs1D;
logic [4:0] rs2D;
logic [4:0] rs1E;
logic [4:0] rs2E;
logic [4:0] rdE;
logic [4:0] rdM;
logic [4:0] rdW;
logic [1:0] resultSourceE;
logic registerWriteM;
logic registerWriteW;

logic lwStall;

controller controller(
    instructionD[6:0],
    instructionD[14:12],
    instructionD[30],

    resultSourceD,
    memoryWriteD,
    aluSourceD,
    immediateSourceD,
    registerWriteD,
    aluControlD,
    branchD,
    jumpD
);

datapath datapath(
    clk,
    reset,
    instructionF,
    readDataM,
    aluSourceD,
    resultSourceD,
    immediateSourceD,
    registerWriteD,
    aluControlD,
    memoryWriteD,
    branchD,
    jumpD,
    stallF,
    stallD,
    flushD,
    flushE,
    forward1,
    forward2,
    
    pc,
    aluResultM,
    writeData,
    pcSourceE,
    zeroE,
    memoryWriteM,
    instructionD,

    rs1D,
    rs2D,
    rs1E,
    rs2E,
    rdE,
    rdM,
    rdW,
    resultSourceE,
    registerWriteM,
    registerWriteW
);

hazardUnit hazardUnit(
    rs1E,
    rs2E,
    rdM,
    rdW, 
    rdE,
    rs1D,
    rs2D,
    registerWriteM,
    registerWriteW,
    pcSourceE,
    resultSourceE[0],

    lwStall,
    stallF,
    stallD,
    flushD,
    flushE,

    forward1,
    forward2
);

endmodule