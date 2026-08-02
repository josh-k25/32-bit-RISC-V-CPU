module controller(
    input logic [6:0] opcode,
    input logic [2:0] funct3, 
    input logic funct7Bit5,

    output logic [1:0] resultSource,
    output logic memoryWrite,
    output logic aluSource,
    output logic [1:0] immediateSource,
    output logic registerWrite,
    output logic [2:0] aluControl,
    output logic branch,
    output logic jump
);

logic [1:0] aluOperation;

aluDecoder aluDecoder(
    opcode[5], 
    aluOperation, 
    funct3, 
    funct7Bit5, 
    aluControl
);

mainDecoder mainDecoder(
    opcode, 
    branch, 
    jump, 
    resultSource, 
    aluSource,
    immediateSource, 
    registerWrite, 
    memoryWrite, 
    aluOperation
);

endmodule
