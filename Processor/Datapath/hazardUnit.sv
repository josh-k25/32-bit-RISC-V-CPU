module hazardUnit(
    input logic [4:0] rs1E,
    input logic [4:0] rs2E,
    input logic [4:0] rdM,
    input logic [4:0] rdW, 
    input logic [4:0] rdE,
    input logic [4:0] rs1D,
    input logic [4:0] rs2D,

    input logic registerWriteM,
    input logic registerWriteW,
    
    input logic pcSourceE,
    input logic resultSourcebit0,

    output logic lwStall,
    output logic stallF,
    output logic stallD,
    output logic flushD,
    output logic flushE,

    output logic [1:0] forward1,
    output logic [1:0] forward2
);

always_comb begin
if ((rs1E == rdM) && registerWriteM && (rs1E != 5'd0))
    forward1 = 2'b10;
else if ((rs1E == rdW) && registerWriteW && (rs1E != 5'd0))
    forward1 = 2'b01;
else 
    forward1 = 2'b00;

if ((rs2E == rdM) && registerWriteM && (rs2E != 5'd0))
    forward2 = 2'b10;
else if ((rs2E == rdW) && registerWriteW && (rs2E != 5'd0))
    forward2 = 2'b01;
else 
    forward2 = 2'b00; 

lwStall = resultSourcebit0 && ((rs1D == rdE) | (rs2D == rdE));
stallF = lwStall;
stallD = lwStall;

flushD = pcSourceE;
flushE = lwStall || pcSourceE;
end

endmodule