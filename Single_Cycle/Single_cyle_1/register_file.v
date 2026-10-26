module register_file(
    input clk,
    input rstn, 
    input [4:0] r_addr1,
    input [4:0] r_addr2,
    input [4:0] r_addr3,

    input [31:0] write_data,
    input rw_en,
    output [31:0] r_data1,
    output [31:0] r_data2
);

    reg [31:0] mem [31:0];

    always @(posedge clk or negedge rstn) begin
        if( rw_en) begin
        
            mem[r_addr3] <= write_data;
        end
        else mem[r_addr3] <= mem[r_addr3];
    end

    assign r_data1 = mem[r_addr1];
    assign r_data2 = mem[r_addr2];

    initial begin
        mem[0] = 0;
    // $readmemb("E:/Verilog_Training/thiet_ke_so/Single Cycle/riscvtest.txt", mem);
    end
 endmodule