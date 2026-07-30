module mux2To1(
    input logic select,
    input logic [31:0] input0,
    input logic [31:0] input1,
    
    output logic [31:0] muxOutput
);

assign muxOutput = select ? input1 : input0;

endmodule