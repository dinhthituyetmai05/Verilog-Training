module riscv(
    input clk, rstn,
    
    output [31:0] writedata, 
    output [31:0] ALUResult,
    output Memwrite
);

    wire PCSrc, ALUSrc, RegWrite;
    wire [1:0] ResultSrc;
    wire [3:0] ALUControl;
    wire [1:0] ImmSrc;
    wire [6:0] op;
    wire [2:0] funct3;
    wire funct75;
    wire [31:0] zero;

    control_unit_ext control_unit_isnt(
        .op(op),
        .funct3(funct3),
        .funct75(funct75),
        .zero(zero),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .Memwrite(Memwrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
    );

    data_path data_path_inst(
        .clk(clk),
        .rstn(rstn),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .Memwrite(Memwrite),
         .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .r_data2(writedata),
        .op(op),
        .funct3(funct3),
        .funct75(funct75),
        .ALUResult(ALUResult),
        .zero(zero)
    );

endmodule