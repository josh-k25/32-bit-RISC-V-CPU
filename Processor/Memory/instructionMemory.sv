module instructionMemory(
    input logic [31:0] pc,

    output logic [31:0] readData
);

logic [31:0] dataArray [0:255];


initial begin
    $readmemh("program.hex", dataArray);
end

assign readData = dataArray[pc[31:2]];

endmodule