module registerFile(
    input logic clk,
    input logic [4:0] rr1Address, rr2Address, rdAddress,
    input logic [31:0] writeData,
    input logic writeEnable,
    
    output logic [31:0] readData1, readData2
);

logic [31:0] registerArray [31:0];

always_ff @(negedge clk)
    if (writeEnable && (rdAddress != 5'b00000)) 
        registerArray[rdAddress] <= writeData;

assign readData1 = (rr1Address == 5'b00000) ? 32'h0000_0000 : registerArray[rr1Address];
assign readData2 = (rr2Address == 5'b00000) ? 32'h0000_0000 : registerArray[rr2Address];

endmodule
