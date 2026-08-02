module top(
    input logic clk,
    input logic reset,

    output logic memoryWrite,
    output logic [31:0] dataAddress,
    output logic [31:0] writeData
);

logic [31:0] pc;
logic [31:0] instruction;
logic [31:0] readData;

processor processor(
    .clk(clk),
    .reset(reset),
    .instructionF(instruction),
    .readDataM(readData),

    .memoryWriteM(memoryWrite),
    .pc(pc),
    .aluResultM(dataAddress),
    .writeData(writeData)
);

dataMemory dataMemory(
    clk,
    memoryWrite,
    dataAddress,
    writeData,
    readData
);

instructionMemory instructionMemory(
    pc,
    instruction
);

endmodule
