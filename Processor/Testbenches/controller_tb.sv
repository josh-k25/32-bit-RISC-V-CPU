`timescale 1ns/1ps

module controller_tb;

logic [6:0] opcode;
logic zero;
logic [2:0] funct3; 
logic funct7Bit5;

logic pcSource;
logic [1:0] resultSource;
logic memoryWrite;
logic aluSource;
logic [1:0] immediateSource;
logic registerWrite;
logic [2:0] aluControl;

logic [1:0] aluOperation;

controller dut(
    .opcode(opcode),
    .zero(zero),
    .funct3(funct3),
    .funct7Bit5(funct7Bit5),
    .pcSource(pcSource),
    .resultSource(resultSource),
    .memoryWrite(memoryWrite),
    .aluSource(aluSource),
    .immediateSource(immediateSource),
    .registerWrite(registerWrite),
    .aluControl(aluControl)
    .branch(branch),
    .jump(jump)
);

initial begin
//lw test (funt7 and zero are irrelevant)
opcode     = 7'b0000011;
funct3     = 3'b010;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b01 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b1  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'b00 ||
    aluControl      !== 3'b000
    )

begin
    $fatal(1, "lw instruction test failed");
end 

//sw test
opcode     = 7'b0100011;
funct3     = 3'b010;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (memoryWrite     !== 1'b1  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b1  ||
    registerWrite   !== 1'b0  ||
    immediateSource !== 2'b01 ||
    aluControl      !== 3'b000)

begin
    $fatal(1, "sw instruction test failed");
end 

//R type alu tests 

//add 
opcode     = 7'b0110011;
funct3     = 3'b000;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b0  ||
    registerWrite   !== 1'b1  ||
    aluControl      !== 3'b000)

begin
    $fatal(1, "add instruction test failed");
end 

//sub
opcode     = 7'b0110011;
funct3     = 3'b000;
funct7Bit5 = 1'b1;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b0  ||
    registerWrite   !== 1'b1  ||
    aluControl      !== 3'b001)

begin
    $fatal(1, "sub instruction test failed");
end

//slt 
opcode     = 7'b0110011;
funct3     = 3'b010;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b0  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'bxx ||
    aluControl      !== 3'b101)

begin
    $fatal(1, "slt instruction test failed");
end

//or
opcode     = 7'b0110011;
funct3     = 3'b110;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b0  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'bxx ||
    aluControl      !== 3'b011)

begin
    $fatal(1, "or instruction test failed");
end

//and
opcode     = 7'b0110011;
funct3     = 3'b111;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b0  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'bxx ||
    aluControl      !== 3'b010)

begin
    $fatal(1, "and instruction test failed");
end

//addi
opcode     = 7'b0010011;
funct3     = 3'b000;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b1  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'b00 ||
    aluControl      !== 3'b000)

begin
    $fatal(1, "addi instruction test failed");
end

//slti
opcode     = 7'b0010011;
funct3     = 3'b010;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b1  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'b00 ||
    aluControl      !== 3'b101)

begin
    $fatal(1, "slti instruction test failed");
end

//ori
opcode     = 7'b0010011;
funct3     = 3'b110;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b1  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'b00 ||
    aluControl      !== 3'b011)

begin
    $fatal(1, "ori instruction test failed");
end

//andi
opcode     = 7'b0010011;
funct3     = 3'b111;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b00 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0  ||
    aluSource       !== 1'b1  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'b00 ||
    aluControl      !== 3'b010)

begin
    $fatal(1, "andi instruction test failed");
end

//beq (not taken)
opcode     = 7'b1100011;
funct3     = 3'b000;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b0 ||
    aluSource       !== 1'b0 ||
    registerWrite   !== 1'b0 ||
    immediateSource !== 2'b10 ||
    aluControl      !== 3'b001)

begin
    $fatal(1, "beq (not taken) instruction test failed");
end

//beq (taken)
opcode     = 7'b1100011;
funct3     = 3'b000;
funct7Bit5 = 1'b0;
zero       = 1'b1;
#1;

if (memoryWrite     !== 1'b0 ||
    pcSource        !== 1'b1 ||
    aluSource       !== 1'b0 ||
    registerWrite   !== 1'b0 ||
    immediateSource !== 2'b10 ||
    aluControl      !== 3'b001)

begin
    $fatal(1, "beq (taken) instruction test failed");
end

//jal 
opcode     = 7'b1101111;
funct3     = 3'b000;
funct7Bit5 = 1'b0;
zero       = 1'b0;
#1;

if (resultSource    !== 2'b10 ||
    memoryWrite     !== 1'b0  ||
    pcSource        !== 1'b1  ||
    registerWrite   !== 1'b1  ||
    immediateSource !== 2'b11)

begin
    $fatal(1, "jal instruction test failed");
end
    
    $display("All tests passed.");
    $finish;
end
endmodule