module hazardUnit(
    input logic [4:0] registerSource1E,
    input logic [4:0] registerSource2E,
    input logic [4:0] registerDestinationM,
    input logic [4:0] registerDestinationW, 
    input logic [4:0] registerDestinationE,
    input logic [4:0] registerSource1D,
    input logic [4:0] registerSource2D,

    input logic registerWriteM,
    input logic registerWriteW,
    
    input logic pcSourceE,

    output logic lwStall,
    output logic stallF,
    output logic stallD,
    output logic flushD,
    output logic resultSourcebit0,
    output logic flushE,

    output logic [1:0] forward1,
    output logic [1:0] forward2
);

always_comb begin
if ((registerSource1E == registerDestinationM) && registerWriteM && (registerSource1E != 5'd0))
    forward1 = 2'b10;
else if ((registerSource1E == registerDestinationW) && registerWriteW && (registerSource1E != 5'd0))
    forward1 = 2'b01;
else 
    forward1 = 2'b00;

if ((registerSource2E == registerDestinationM) && registerWriteM && (registerSource2E != 5'd0))
    forward2 = 2'b10;
else if ((registerSource2E == registerDestinationW) && registerWriteW && (registerSource2E != 5'd0))
    forward2 = 2'b01;
else 
    forward2 = 2'b00; 

lwStall = resultSourcebit0 && ((registerSource1D == registerDestinationE) | (registerSource2D == registerDestinationE));
stallF = lwStall;
stallD = lwStall;

flushD = pcSourceE;
flushE = lwStall || pcSourceE;
end

endmodule