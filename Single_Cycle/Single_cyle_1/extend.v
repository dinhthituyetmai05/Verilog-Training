module extend(
    input [31:7] instr,
    input [1:0] ImmSrc,
    output reg [31:0] ImmExt
);

    always @(ImmSrc, instr) begin 
        case(ImmSrc)
                2'b00: ImmExt = {{20{instr[31]}}, instr[31:20]};
                2'b01: ImmExt = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                2'b10: ImmExt = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                2'b11: ImmExt = {{12{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
                default: 
                    ImmExt = {{20{instr[31]}} , instr[31:20]};
        endcase 
    end
endmodule