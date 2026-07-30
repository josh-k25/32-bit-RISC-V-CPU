module ex_To_mem(
input logic clk,
input logic registerWriteE,
input logic [1:0] resultSourceE,
input logic memoryWriteE,

input logic [31:0] aluResultE,
input logic [31:0] writeDataE,
input logic [4:0] registerDestinationE,
input logic [31:0] pcPlus4E,

output logic registerWriteM,
output logic [1:0] resultSourceM,
output logic memoryWriteM,

output logic [31:0] aluResultM,
output logic [31:0] writeDateM,
output logic [4:0] registerDestinationM,
output logic [31:0] pcPlus4M
);

always_ff @(posedge clk) begin
registerWriteM <= registerWriteE;
resultSourceM <= resultSourceE;
memoryWriteM <= memoryWriteE;
aluResultM <= aluResultE;

end

endmodule


