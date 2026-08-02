module basys3_top(
    input logic clk,
    input logic reset,
    output logic [15:0] led
);

logic memoryWrite;
logic [31:0] dataAddress;
logic [31:0] writeData;

logic [31:0] lastWriteData;

top cpuSystem(
    .clk(clk),
    .reset(reset),
    .memoryWrite(memoryWrite),
    .dataAddress(dataAddress),
    .writeData(writeData)
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        lastWriteData <= 32'b0;
    else if (memoryWrite)
        lastWriteData <= writeData;
end

assign led = lastWriteData[15:0];

endmodule