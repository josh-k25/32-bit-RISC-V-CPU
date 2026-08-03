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

//Allow instruction memory initialization to complete
#1;

//Confirm that the new instructions were loaded
if (
    dut.instructionMemory.dataArray[18] !== 32'h00a0a113 ||
    dut.instructionMemory.dataArray[19] !== 32'h0080e193 ||
    dut.instructionMemory.dataArray[20] !== 32'h0071f213 ||
    dut.instructionMemory.dataArray[21] !== 32'h0000006f
)
    $fatal(1,"program.hex was not loaded correctly: %h %h %h %h", dut.instructionMemory.dataArray[18], dut.instructionMemory.dataArray[19], dut.instructionMemory.dataArray[20], dut.instructionMemory.dataArray[21]
    );

//Initialize input values at byte addresses 0x40 and 0x44
dut.dataMemory.memory[16] = 32'd7;
dut.dataMemory.memory[17] = 32'hFFFF_FFFD;

//Initialize output location at byte address 0x48
dut.dataMemory.memory[18] = 32'd0;

//Hold reset for two clock edges
@(posedge clk);
#1;

@(posedge clk);
#1;

reset = 0;

//Run until all expected results appear or timeout occurs
while (cycle < 200 && !programFinished) begin
    @(posedge clk);
    #1;

    if (
        dut.dataMemory.memory[18] === 32'd5 &&
        dut.processor.datapath.registerFile.registerArray[2] === 32'd1 &&
        dut.processor.datapath.registerFile.registerArray[3] === 32'd13 &&
        dut.processor.datapath.registerFile.registerArray[4] === 32'd5
    )
        programFinished = 1'b1;

    cycle = cycle + 1;
end

if (!programFinished)
    $fatal(
        1,
        "Program timed out. memory[18]=%0d, x1=%0d, x2=%0d, x3=%0d, x4=%0d",
        dut.dataMemory.memory[18],
        dut.processor.datapath.registerFile.registerArray[1],
        dut.processor.datapath.registerFile.registerArray[2],
        dut.processor.datapath.registerFile.registerArray[3],
        dut.processor.datapath.registerFile.registerArray[4]
    );

//Verify initial addi -> sw sequence
if (dut.dataMemory.memory[1] !== 32'd5)
    $fatal(
        1,
        "Initial store failed. Expected memory[1]=5, got %0d",
        dut.dataMemory.memory[1]
    );

if (dut.processor.datapath.registerFile.registerArray[2] !== 32'd1)
    $fatal(1, "slti failed.");

if (dut.processor.datapath.registerFile.registerArray[3] !== 32'd13)
    $fatal(1, "ori failed.");

if (dut.processor.datapath.registerFile.registerArray[4] !== 32'd5)
    $fatal(1, "andi failed.");

$display(
    "All pipelined CPU tests passed. memory[1]=%0d, memory[18]=%0d, x2=%0d, x3=%0d, x4=%0d, cycles=%0d",
    dut.dataMemory.memory[1],
    dut.dataMemory.memory[18],
    dut.processor.datapath.registerFile.registerArray[2],
    dut.processor.datapath.registerFile.registerArray[3],
    dut.processor.datapath.registerFile.registerArray[4],
    cycle
);

$finish;
end

endmodule