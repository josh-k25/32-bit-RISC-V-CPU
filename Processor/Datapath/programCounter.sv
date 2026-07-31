module programCounter(
    input logic clk,
    input logic reset,
    input logic [31:0] pcNext,
    input logic stallF,

    output logic [31:0] pc
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'h00000000;
    else if (!stallF)
        pc <= pcNext;
end
endmodule