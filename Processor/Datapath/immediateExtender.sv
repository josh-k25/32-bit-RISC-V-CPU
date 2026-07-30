module immediateExtender(
    input logic [1:0] immediateSourceD,
    input logic [24:0] immediate,

    output logic [31:0] extendedImmediateD
);


always_comb case (immediateSourceD)
    //I type 
    2'b00: extendedImmediateD = {{20{immediate[24]}}, immediate[24:13]};
    //S type
    2'b01: extendedImmediateD = {{20{immediate[24]}}, immediate[24:18], immediate[4:0]};
    //B type 
    2'b10: extendedImmediateD = {{20{immediate[24]}}, immediate[0], immediate[23:18], immediate[4:1], 1'b0};
    //J type
    2'b11: extendedImmediateD = {{12{immediate[24]}}, immediate[12:5], immediate[13], immediate[23:14], 1'b0};
    default: extendedImmediateD = 32'h0000_0000;
endcase

endmodule