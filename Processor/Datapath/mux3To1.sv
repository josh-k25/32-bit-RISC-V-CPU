module mux3To1(
    input logic [1:0] select,
    input logic [31:0] input0,
    input logic [31:0] input1,
    input logic [31:0] input2,

    output logic [31:0] muxOutput 
);

always_comb begin
    case (select)
        2'b00: muxOutput = input0;
        2'b01: muxOutput = input1;
        2'b10: muxOutput = input2;
        default: muxOutput = 32'd0;
    endcase

end

endmodule
