`timescale 1ns/1ps

module top_tb;

logic clk;
logic reset;

logic memoryWrite;
logic [31:0] dataAddress;
logic [31:0] writeData;

logic programFinished;
integer cycle;

top dut(
    .clk(clk),
    .reset(reset),
    .memoryWrite(memoryWrite),
    .dataAddress(dataAddress),
    .writeData(writeData)
);

always #5 clk = ~clk;

initial begin

clk = 0;
reset = 1;
programFinished = 0;
cycle = 0;

//initialize input values at byte addresses 0x40 and 0x44
dut.dataMemory.memory[16] = 32'd7;
dut.dataMemory.memory[17] = 32'hFFFF_FFFD;

//initialize output location at byte address 0x48
dut.dataMemory.memory[18] = 32'd0;

//hold reset for two clock edges
@(posedge clk);
    #1;
@(posedge clk);
    #1;

reset = 0;

//run program until expected result appears or timeout occurs
while (cycle < 200 && !programFinished) begin

    @(posedge clk);
    #1;

    if (dut.dataMemory.memory[18] === 32'd5)
        programFinished = 1'b1;

    cycle = cycle + 1;

end

if (!programFinished)
    $fatal(1,
        "Program timed out. expected memory[18] = 5, got memory[18] = %0d.",
        dut.dataMemory.memory[18]
    );

// vrify initial addi -> sw sequence eventually stored 5
if (dut.dataMemory.memory[1] !== 32'd5)
    $fatal(1,
        "Initial store failed! expected memory[1] = 5, got memory[1] = %0d.",dut.dataMemory.memory[1]
    );

$display(
    "All pipelined CPU tests passed. memory[1] = %0d, memory[18] = %0d, cycles = %0d.",
    dut.dataMemory.memory[1],
    dut.dataMemory.memory[18],
    cycle
);

$finish;

end

endmodule