module if_To_id(
    input logic clk,
    input logic [31:0] readDataF,
    input logic [31:0] pcF,
    input logic [31:0] pcPlus4F,
    input logic stallD,
    input logic flushD,

    output logic [31:0] readDataD,
    output logic [31:0] pcD,
    output logic [31:0] pcPlus4D
);

always_ff @(posedge clk) begin
    if (flushD) begin
        readDataD <= 32'b0;
        pcD <= 32'b0;
        pcPlus4D <= 32'b0;
    end
    else if (!stallD) begin
        readDataD <= readDataF;
        pcD <= pcF;
        pcPlus4D <= pcPlus4F;
    end 
end

endmodule
