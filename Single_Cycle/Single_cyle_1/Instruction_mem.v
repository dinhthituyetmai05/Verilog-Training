module Instruction_mem(
    input [31:0] addr,
    output [31:0]instr
);
    reg [31:0] mem [50:0];
    assign instr = mem[addr];

    initial begin
        $readmemh("E:/Verilog_Training/thiet_ke_so/Single_Cycle/Single_Cycle/Single_cyle_1/rv32i_r_instructions.txt", mem);
    // $readmemh("E:/Verilog_Training/thiet_ke_so/Single_Cycle/Single_Cycle/Single_cyle_1/riscvtest.txt", mem);
    end
endmodule