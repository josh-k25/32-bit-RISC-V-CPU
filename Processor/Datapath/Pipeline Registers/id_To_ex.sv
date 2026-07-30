module id_To_ex(
input logic clk,
input logic flushE,

input logic branchD,
input logic jumpD,
input logic [1:0] resultSourceD,
input logic aluSourceD,
input logic registerWriteD,
input logic memoryWriteD,
input logic [2:0] aluControlD,

input logic [31:0] rd1D,
input logic [31:0] rd2D,
input logic [31:0] pcD,
input logic [4:0] rdD,
input logic [31:0] immExtD,
input logic [31:0] pcPlus4D,
input logic [4:0] rs1D,
input logic [4:0] rs2D,

output logic branchE,
output logic jumpE,
output logic [1:0] resultSourceE,
output logic aluSourceE,
output logic registerWriteE,
output logic memWriteE,
output logic [2:0] aluControlE,

output logic [31:0] rd1E,
output logic [31:0] rd2E,
output logic [31:0] pcE,
output logic [4:0] rdE,
output logic [31:0] immExtE,
output logic [31:0] pcPlus4E,
output logic [4:0] rs1E,
output logic [4:0] rs2E
);

always_ff @(posedge clk) begin
    if (flushE) begin

        branchE <= 1'b0;
        jumpE <= 1'b0;
        resultSourceE <= 2'b00;
        aluSourceE <= 1'b0;
        registerWriteE <= 1'b0;
        memWriteE <= 1'b0;
        aluControlE <= 3'b00;
    end
    else begin

        branchE <= branchD;
        jumpE <= jumpD;
        resultSourceE <= resultSourceD;
        aluSourceE <= aluSourceD;
        registerWriteE <= registerWriteD;
        memWriteE <= memoryWriteD;
        aluControlE <= aluControlD;

        rd1E <= rd1D;
        rd2E <= rd2D;
        pcE <= pcD;
        rdE <= rdD;
        immExtE <= immExtD;
        pcPlus4E <= pcPlus4D;
        rs1E <= rs1D;
        rs2E <= rs2D;
    end
end

endmodule
