module datapath(
    input logic clk,
    input logic reset,
    input logic [31:0] instructionF,
    input logic [31:0] readDataM,

    input logic aluSourceD,
    input logic [1:0] resultSourceD,
    input logic [1:0] immediateSourceD,
    input logic registerWriteD,
    input logic [2:0] aluControlD,
    input logic memoryWriteD,
    input logic branchD,
    input logic jumpD,

    input logic szetallF,
    input logic stallD,
    input logic flushD,
    input logic flushE,
    input logic [1:0] forward1,
    input logic [1:0] forward2,

    output logic [31:0] pc,
    output logic [31:0] aluResult,
    output logic [31:0] writeData,
    output logic pcSourceE,
    output logic zeroE,
    output logic memoryWriteM,
    output logic [31:0] instructionD,

    output logic [4:0] rs1D,
    output logic [4:0] rs2D,
    output logic [4:0] rs1E,
    output logic [4:0] rs2E,
    output logic [4:0] rdE,
    output logic [4:0] rdM,
    output logic [4:0] rdW,
    output logic [1:0] resultSourceE,
    output logic registerWriteM,
    output logic registerWriteW
);

//Fetch internal signals:
logic [31:0] pcF;
logic [31:0] pcPlus4F;
logic [31:0] pcNextF;

//Decode internal signals:
logic [31:0] pcD;
logic [31:0] pcPlus4D;
logic [31:0] rd1D;
logic [31:0] rd2D;
logic [31:0] immExtD;
logic [4:0] rdD;

//Execute internal signals: 
logic registerWriteE;
logic memoryWriteE;
logic jumpE;
logic branchE;
logic [2:0] aluControlE;
logic aluSourceE;

logic [31:0] pcE;
logic [31:0] pcPlus4E;
logic [31:0] pcTargetE;
logic [31:0] rd1E;
logic [31:0] rd2E;
logic [31:0] immExtE;
logic [31:0] writeDataE;

logic [31:0] source1E;
logic [31:0] source2E;
logic [31:0] aluResultE;

//Memory internal signals:
logic [1:0] resultSourceM;

logic [31:0] aluResultM;
logic [31:0] writeDataM;
logic [31:0] pcPlus4M;

//Write internal signals:
logic [1:0] resultSourceW;
logic [31:0] aluResultW;
logic [31:0] readDataW;
logic [31:0] pcPlus4W;
logic [31:0] resultW;

//Program counter path
pcPlus4 pcPlus4Adder (
    pcF,
    pcPlus4F
);

mux2To1 pcNextMux (
    pcSourceE,
    pcPlus4F,
    pcTargetE,
    pcNextF
);

programCounter pcRegister (
    clk,
    reset,
    pcNextF,
    stallF,
    pcF
);

assign pc = pcF;

//F to D pipeline register
if_To_id F_To_D(
    clk,
    instructionF,
    pcF,
    pcPlus4F,
    stallD,
    flushD,
    instructionD,
    pcD,
    pcPlus4D
);


//register file and immediate extender
assign rs1D = instructionD[19:15];
assign rs2D = instructionD[24:20];
assign rdD = instructionD[11:7];

registerFile registerFile(
    clk, 
    rs1D, 
    rs2D, 
    rdW, 
    resultW,     
    registerWriteW, 
    rd1D, 
    rd2D
);

immediateExtender immediateExtender(
    immediateSourceD, 
    instructionD[31:7], 
    immExtD
);

//D to E pipeline register
id_To_ex D_To_E(
    clk,
    flushE,

    branchD,
    jumpD,
    resultSourceD,
    aluSourceD,
    registerWriteD,
    memoryWriteD,
    aluControlD,

    rd1D,
    rd2D,
    pcD,
    rdD,
    immExtD,
    pcPlus4D,
    rs1D,
    rs2D,

    branchE,
    jumpE,
    resultSourceE,
    aluSourceE,
    registerWriteE,
    memoryWriteE,
    aluControlE,

    rd1E,
    rd2E,
    pcE,
    rdE,
    immExtE,
    pcPlus4E,
    rs1E,
    rs2E
);

//alu path

mux3To1 forward1Mux(
    forward1,
    rd1E,
    resultW,
    aluResultM,
    source1E
);

mux3To1 forward2Mux(
    forward2,
    rd2E,
    resultW,
    aluResultM,
    writeDataE
);

mux2To1 aluSourceMux(
    aluSourceE,
    writeDataE,
    immExtE,
    source2E
);

pcTarget pcTargetAdder(
    pcE,
    immExtE,
    pcTargetE
);

alu alu(
    aluControlE,
    source1E,
    source2E,
    aluResultE,
    zeroE
);

//E to M pipeline register
ex_To_mem E_To_M(
    clk,
    registerWriteE,
    resultSourceE,
    memoryWriteE,

    aluResultE,
    writeDataE,
    rdE,
    pcPlus4E,

    registerWriteM,
    resultSourceM,
    memoryWriteM,
    
    aluResultM,
    writeDataM,
    rdM,
    pcPlus4M
);
//M to W pipeline register
mem_To_wb M_To_W (
    clk,
    registerWriteM,
    resultSourceM,
    aluResultM,
    readDataM,
    rdM,
    pcPlus4M,
    registerWriteW,
    resultSourceW,
    aluResultW,
    readDataW,
    rdW,
    pcPlus4W
);

//writeback mux 
mux3To1 resultSourceMux(
    resultSourceW, 
    aluResultW, 
    readDataW, 
    pcPlus4W, 
    resultW
);

assign aluResult = aluResultM;
assign writeData = writeDataM;

assign pcSourceE = (branchE & zeroE) | jumpE;

endmodule   