module data_path(
    input clk,
    input rstn,
    input PCSrc,
    input [1:0] ResultSrc,
    input Memwrite,
    input [3:0]ALUControl,
    input ALUSrc,
    input [1:0] ImmSrc,
    input RegWrite,
    output  [31:0] ALUResult,
    output [6:0] op,
    output [2:0] funct3,
    output reg [31:0] r_data2,
    output funct75,
    output [31:0] zero 
);
    reg [31:0] PCNext;
    reg [31:0] PC;

    wire [31:0] instr;
    wire [31:0] PCPlus4;
    reg [31:0] ImmExt;
    wire [31:0] PCTarget;
    reg [31:0] result;
    wire [31:0] SrcA, SrcB, readdata;


    assign PCTarget = PC  + (ImmExt >> 2) ;
    assign PCPlus4 = PC + 1;
    
    assign SrcB = (ALUSrc) ? ImmExt : r_data2;

    assign op = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct75 = instr[30];
    always @(PCSrc, PCTarget, PCPlus4) begin
        if(PCSrc) begin
            PCNext =  PCTarget;
        end
        else begin 
            PCNext = PCPlus4;
        end
    end
    always @(ResultSrc, ALUResult, readdata, PCPlus4) begin
        case(ResultSrc) 
            2'b00: result = ALUResult;
            2'b01: result = readdata;
            2'b10: result = PCPlus4 << 2;
            default result = ALUResult;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) PC <= 0;
        else PC <= PCNext;
    end
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
    Instruction_mem Instruction_mem_inst(
        .addr(PC),
        .instr(instr)
    );
    
    register_file register_file_inst(
        .clk(clk),
        .rstn(rstn),
        .r_addr1(instr[19:15]),
        .r_addr2(instr[24:20]),
        .r_addr3(instr[11:7]),
        .write_data(result),
        .rw_en(RegWrite),
        .r_data1(SrcA),
        .r_data2(r_data2)
    );
    ALU_ext ALU_inst(
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .zero(zero),
        .ALUResult(ALUResult)
    );
    
    Data_mem data_mem_inst(
        .clk(clk),
        .rstn(rstn),
        .addr(ALUResult),
        .writedata(r_data2),
        .w_en(Memwrite),
        .readdata(readdata) 
    );

endmodule