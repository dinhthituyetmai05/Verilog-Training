module ALU_ext(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [3:0] ALUControl,
    output [31:0] zero,
    output reg [31:0] ALUResult
);
    always @(ALUControl, SrcA,SrcB ) begin 
        case(ALUControl)
            4'b0000: ALUResult = SrcA + SrcB;
            4'b0001: ALUResult = SrcA - SrcB;
            4'b0010: ALUResult = SrcA << SrcB;
            4'b0011: ALUResult = (SrcA < SrcB) ? 1 : 0;
            4'b0100: ALUResult = ($unsigned(SrcA) < $unsigned(SrcB)) ? 1 : 0;
            4'b0101: ALUResult = SrcA ^ SrcB;
            4'b0110: ALUResult = SrcA >> SrcB;
            4'b0111: ALUResult = $signed(SrcA) >>> $signed(SrcB);
            4'b1000: ALUResult = SrcA | SrcB;
            4'b1001: ALUResult = SrcA & SrcB;
            default: ALUResult = SrcA + SrcB;
        endcase
    end

    assign zero = SrcA - SrcB;
endmodule