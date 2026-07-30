`timescale 1ns/1ps

module datapathPipelined_tb;

logic clk;
logic reset;
logic [31:0] instruction;
logic [31:0] readDataM;

logic pcSourceE;
logic aluSource;
logic [1:0] resultSource;
logic [1:0] immediateSource;
logic registerWrite;
logic [2:0] aluControl;

logic stallF;
logic stallD;
logic flushD;
logic flushE;
logic [1:0] forward1;
logic [1:0] forward2;

logic [31:0] pc;
logic [31:0] aluResult;
logic [31:0] writeData;
logic zero;

datapath dut(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .readData(readData),
    .pcSource(pcSource),
    .aluSource(aluSource),
    .resultSource(resultSource),
    
)