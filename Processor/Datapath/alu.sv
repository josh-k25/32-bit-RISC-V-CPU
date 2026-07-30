module alu(
    input logic [2:0] aluControl,
    input logic [31:0] sourceA,
    input logic [31:0] sourceB,

    output logic [31:0] aluResult,
    output logic zero
);

always_comb begin
    case (aluControl)
        3'b000: aluResult = sourceA + sourceB;
        3'b001: aluResult = sourceA - sourceB;
        3'b010: aluResult = sourceA & sourceB;
        3'b011: aluResult = sourceA | sourceB;
        3'b101: begin
            if ($signed(sourceA) < $signed(sourceB))
            aluResult = 32'd1;
            else
            aluResult = 32'd0;
        end
        default: aluResult = 32'h0000_0000;
    endcase
end

assign zero = (aluResult == 0);

endmodule
