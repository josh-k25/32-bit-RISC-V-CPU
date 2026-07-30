module mem_To_wb(
    input logic clk,
    input logic registerWriteM,
    input logic [1:0] resultSourceM,

    input logic [31:0] aluResultM,
    input logic [31:0] readDataM,
    input logic [4:0] registerDestinationM,
    input logic [31:0] pcPlus4M,

    output logic registerWriteW,
    output logic [1:0] resultSourceW,
    
    output logic [31:0] aluResultW,
    output logic [31:0] readDataW,
    output logic [4:0] registerDestinationW,
    output logic [31:0] pcPlus4W
);

always_ff @(posedge clk) begin
registerWriteW = registerWriteM;
resultSourceW = resultSourceM;
aluResultW = aluResultM;
readDataW = readDataM;
registerDestinationW = registerDestinationM;
pcPlus4W = pcPlus4M;
end

endmodule
