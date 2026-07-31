`timescale 1ns/1ps

module datapathPipelined_tb;

logic clk;
logic reset;
logic [31:0] instruction;
logic [31:0] readDataM;

logic aluSourceD;
logic [1:0] resultSourceD;
logic [1:0] immediateSourceD;
logic registerWriteD;
logic [2:0] aluControlD;
logic memoryWriteD;
logic branchD;
logic jumpD;

logic stallF;
logic stallD;
logic flushD;
logic flushE;
logic [1:0] forward1;
logic [1:0] forward2;

logic [31:0] pc;
logic [31:0] aluResult;
logic [31:0] writeData;
logic pcSourceE;
logic zeroE;
logic memoryWrite;
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

datapath dut(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .readDataM(readDataM),
    
    .aluSourceD(aluSourceD),
    .resultSourceD(resultSourceD),
    .immediateSourceD(immediateSourceD),
    .registerWriteD(registerWriteD),
    .aluControlD(aluControlD),
    .memoryWriteD(memoryWriteD),
    .branchD(branchD),
    .jumpD(jumpD),

    .stallF(stallF),
    .stallD(stallD),
    .flushD(flushD),
    .flushE(flushE),
    .forward1(forward1),
    .forward2(forward2),

    .pc(pc),
    .aluResult(aluResult),
    .writeData(writeData),
    .pcSourceE(pcSourceE),
    .zeroE(zeroE),
    .memoryWrite(memoryWrite),
    .instructionD(instructionD),

    .rs1D(rs1D),
    .rs2D(rs2D),
    .rs1E(rs1E),
    .rs2E(rs2E),
    .rdE(rdE),
    .rdM(rdM),
    .rdW(rdW),
    .resultSourceE(resultSourceE),
    .registerWriteM(registerWriteM),
    .registerWriteW(registerWriteW)
);

always #5 clk = ~clk;
initial begin
    clk              = 0;
    reset            = 1;
    instruction      = 32'b0;
    readDataM        = 32'b0;

    aluSourceD       = 0;
    resultSourceD    = 2'b00;
    immediateSourceD = 2'b00;
    registerWriteD   = 0;
    aluControlD      = 3'b000;
    memoryWriteD     = 0;
    branchD          = 0;
    jumpD            = 0;

    stallF           = 0;
    stallD           = 0;
    flushD           = 0;
    flushE           = 0;
    forward1         = 2'b00;
    forward2         = 2'b00;

    #12;
    reset = 0;

//test that reset sets pc to 0
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);

reset = 1'b1;
#1;

if (pc !== 32'd0)
    $fatal(1, 
        "Reset test failed."
);

reset = 1'b0;
#1;

//check that pc increments by 4
@(posedge clk);
#1;

if (pc !== 32'd4)
    $fatal(1,
        "pc increment by 4 failed. "
);

//check that stallF freezes the pc 
branchD = 1'b1;
jumpD = 1'b1;
resultSourceD = 2'b10;
aluSourceD = 1'b1;
registerWriteD = 1'b1;
memoryWriteD = 1'b1;
aluControlD = 3'b101;
#1;

stallF = 1'b1;


@(posedge clk);
#1;

if (pc !== 32'd4)
    $fatal(1,
        "stallF pc freeze failed."
);

stallF = 1'b0;


//check that instructionF passed to instructionD on rising clock edge
instruction = 32'h12345678;

@(posedge clk);
#1;

if (instructionD !== 32'h12345678)
    $fatal(1,
        "instructionF to instructionD failed."
);

//check that stallD holds instructionD

stallD = 1'b1;
instruction = 32'h87654321;

@(posedge clk);
#1;

if (instructionD !== 32'h12345678)
    $fatal(1,
        "instructionD stall failed."
);

stallD = 1'b0;

//check that flushD clears if/id pipeline register
flushD = 1'b1;

@(posedge clk);
#1;

if (dut.instructionD !== 32'b0)
    $fatal(1,
    "instructionD flush failed."
);

if (dut.pcD !== 32'b0)
    $fatal(1, 
    "pcD flush failed."
);

if (dut.pcPlus4D !== 32'b0)
    $fatal(1,
    "pcPlus4D flush failed."
);

flushD = 1'b0;

//check that flushE clearas the id/ex pipeline register

flushE = 1'b1;

@(posedge clk);
#1;

if (dut.branchE !== 1'b0)
    $fatal(1, 
        "flushE failed: branchE was not cleared"
);

if (dut.jumpE !== 1'b0)
    $fatal(1, 
        "flushE failed: jumpE was not cleared"
);

if (resultSourceE !== 2'b00)
    $fatal(1, 
        "flushE failed: resultSourceE was not cleared"
);

if (dut.aluSourceE !== 1'b0)
    $fatal(1, 
        "flushE failed: aluSourceE was not cleared"
);

if (dut.registerWriteE !== 1'b0)
    $fatal(1, 
        "flushE failed: registerWriteE was not cleared"
);

if (dut.memoryWriteE !== 1'b0)
    $fatal(1, 
        "flushE failed: memoryWriteE was not cleared"
);

if (dut.aluControlE !== 3'b000)
    $fatal(1, 
        "flushE failed: aluControlE was not cleared"
);

flushE = 1'b0;

branchD = 1'b0;
jumpD = 1'b0;
resultSourceD = 2'b00;
aluSourceD = 1'b0;
registerWriteD = 1'b0;
memoryWriteD = 1'b0;
aluControlD = 3'b000;

//test alu source mux 1
force dut.aluSourceE = 0;
stallF = 1'b0;
stallD = 1'b0;
flushD = 1'b0;
flushE = 1'b0;
forward1 = 2'b00;
forward2 = 2'b00;

force dut.rd1E = 32'd6;
force dut.rd2E = 32'd4;
force dut.immExtE = 32'd3;

force dut.aluControlE = 3'b000;
#1;

if (dut.source1E !== 32'd6)
    $fatal(1,
        "source1E is incorrect (aluSource = 0)."
);

if (dut.source2E !== 32'd4)
    $fatal(1,
        "source2E is incorrect (aluSource = 0)."
);

if (dut.aluResultE !== 32'd10)
    $fatal(1, 
        "alu source mux test 1 failed (aluSource = 0)."
);

force dut.aluSourceE = 1'b1;
#1;

if (dut.source2E !== 32'd3)
    $fatal(1,
        "source2E is incorrect (aluSource = 1)."
);

if (dut.aluResultE !== 32'd9)
    $fatal(1, 
        "alu source mux test 2 failed (aluSource = 1)."
);

release dut.rd1E;
release dut.rd2E;
release dut.immExtE;
release dut.aluControlE;
release dut.aluSourceE;


//test forward1 and 2
force dut.rd1E = 32'd1;
force dut.rd2E = 32'd2;
force dut.resultW = 32'd5;
force dut.aluResultM = 32'd9;

forward1 = 2'b00;
#1;

if (dut.source1E !== 32'd1)
    $fatal(1,
    "source1E forward (00) failed."
);

forward1 = 2'b01;
#1;

if (dut.source1E !== 32'd5)
    $fatal(1,
    "source1E forward (01) failed."
);

forward1 = 2'b10;
#1;

if (dut.source1E !== 32'd9)
    $fatal(1,
        "source1E forward (10) failed."
);

forward2 = 2'b00;
#1;

if (dut.writeDataE !== 32'd2)
    $fatal(1,
        "writeDataE forward (00) failed."
);

forward2 = 2'b01;
#1;

if (dut.writeDataE !== 32'd5)
    $fatal(1,
        "writeDataE forward (01) failed."
);

forward2 = 2'b10;
#1;

if (dut.writeDataE !== 32'd9)
    $fatal(1,
        "writedata forward (10) failed."
);

release dut.rd1E;
release dut.rd2E;
release dut.aluControlE;
release dut.aluSourceE;
release dut.resultW;
release dut.aluResultM;

forward1 = 2'b00;
forward2 = 2'b00;

//E to M pipeline register test
force dut.aluResultE = 32'd10;
force dut.writeDataE = 32'd20;
force dut.rdE = 5'b00101;
force dut.registerWriteE = 1'b1;
force dut.memoryWriteE = 1'b1;
force dut.resultSourceE = 2'b01;
force dut.pcPlus4E = 32'd100;

@(posedge clk);
#1;

if (dut.aluResultM !== 32'd10)
    $fatal(1, 
        "aluResultE to aluResultM failed."
);

if (dut.writeDataM !== 32'd20)
    $fatal(1, 
        "writeDataE to writeDataM failed."
    );

if (rdM !== 5'd5)
    $fatal(1, 
        "rdE to rdM failed."
);

if (registerWriteM !== 1'b1)
    $fatal(1, 
        "registerWriteE to registerWriteM failed."
);

if (dut.memoryWriteM !== 1'b1)
    $fatal(1, 
        "memoryWriteE to memoryWriteM failed."
);

if (dut.resultSourceM !== 2'b01)
    $fatal(1, 
        "resultSourceE to resultSourceM failed."
);

if (dut.pcPlus4M !== 32'd100)
    $fatal(1, 
        "pcPlus4E to pcPlus4M failed."
);

release dut.aluResultE;
release dut.writeDataE;
release dut.rdE;
release dut.registerWriteE;
release dut.memoryWriteE;
release dut.resultSourceE;
release dut.pcPlus4E;

//M to W pipeline register test 

readDataM = 32'd50;

@(posedge clk);
#1;

if (dut.aluResultW !== 32'd10)
    $fatal(1, 
        "aluResultM to aluResultW failed."
);

if (dut.readDataW !== 32'd50)
    $fatal(1, 
        "readDataM to readDataW failed."
);

if (rdW !== 5'd5)
    $fatal(1, 
        "rdM to rdW failed."
);

if (registerWriteW !== 1'b1)
    $fatal(1, 
        "registerWriteM to registerWriteW failed."
);

if (dut.resultSourceW !== 2'b01)
    $fatal(1, 
        "resultSourceM to resultSourceW failed."
);

if (dut.pcPlus4W !== 32'd100)
    $fatal(1, 
        "pcPlus4M to pcPlus4W failed."
);

// Since resultSourceW = 01, writeback should select memory data
if (dut.resultW !== 32'd50)
    $fatal(1, 
        "Writeback mux failed to select readDataW."
);

$display("Datapath tests passed.");
$finish;


end



endmodule