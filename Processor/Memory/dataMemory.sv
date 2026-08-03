module dataMemory(
    input logic clk,
    input logic we,
    input logic [31:0] address,
    input logic [31:0] writeData,
    
    output logic [31:0] readData
);

logic [31:0] memory[0:255];

initial begin
    memory[16] = 32'd7;
    memory[17] = 32'hFFFF_FFFD;
    memory[18] = 32'd0;
end

assign readData = memory[address[31:2]];

always_ff @(posedge clk)
    if (we) 
        memory[address[31:2]] <= writeData;

endmodule