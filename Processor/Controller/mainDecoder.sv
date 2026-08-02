module mainDecoder(
    input logic [6:0] op,

    output logic branch,
    output logic jump,
    output logic [1:0] resultSource,
    output logic aluSource,
    output logic [1:0] immediateSource,
    output logic registerWrite,
    output logic memoryWrite,
    output logic [1:0] aluOperation
);

always_comb case(op)
    7'b0000011: begin
        registerWrite = 1'b1;
        immediateSource = 2'b00;
        aluSource = 1'b1;
        memoryWrite = 1'b0;
        resultSource = 2'b01;
        branch = 1'b0;
        jump = 1'b0;
        aluOperation = 2'b00;
    end

    7'b0100011: begin
        registerWrite = 1'b0;
        immediateSource = 2'b01;
        aluSource = 1'b1;
        memoryWrite = 1'b1;
        resultSource = 2'b00;
        branch = 1'b0;
        jump = 1'b0;
        aluOperation = 2'b00;
    end

    7'b0110011: begin
        registerWrite = 1'b1;
        immediateSource = 2'bxx;
        aluSource = 1'b0;
        memoryWrite = 1'b0;
        resultSource = 2'b00;
        branch = 1'b0;
        jump = 1'b0;
        aluOperation = 2'b10;
    end

    7'b1100011: begin
        registerWrite = 1'b0;
        immediateSource = 2'b10;
        aluSource = 1'b0;
        memoryWrite = 1'b0;
        resultSource = 2'b00;
        branch = 1'b1;
        jump = 1'b0;
        aluOperation = 2'b01;
    end

    7'b0010011: begin
        registerWrite = 1'b1;
        immediateSource = 2'b00;
        aluSource = 1'b1;
        memoryWrite = 1'b0;
        resultSource = 2'b00;
        branch = 1'b0;
        jump = 1'b0;
        aluOperation = 2'b10;
    end

    7'b1101111: begin
        registerWrite = 1'b1;
        immediateSource = 2'b11;
        aluSource = 1'bx;
        memoryWrite = 1'b0;
        resultSource = 2'b10;
        branch = 1'b0;
        jump = 1'b1;
        aluOperation = 2'bxx;
    end

    default: begin
        registerWrite = 1'b0;
        immediateSource = 2'b00;
        aluSource = 1'b0;
        memoryWrite = 1'b0;
        resultSource = 2'b00;
        branch = 1'b0;
        jump = 1'b0;
        aluOperation = 2'b00;
    end

endcase

endmodule

