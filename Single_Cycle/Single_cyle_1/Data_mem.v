module Data_mem(
    input clk, 
    input rstn,
    input [31:0] addr,
    input [31:0] writedata,
    input w_en,
    output  [31:0] readdata
);  
    // reg [31:0] mem [1023:0];
    // assign readdata = mem[addr];
    // always @(posedge clk or negedge rstn) begin
    //     if(w_en) begin
    //         mem[addr] <= writedata;
    //     end
    //     else mem[addr] <= mem[addr];
    // end
    
    reg [31:0] mem [50:0];
    assign readdata = mem[addr >> 2];
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            mem[0] <= 1;
            mem[1] <= 2;
            mem[2] <= 90;
            mem[3] <= 4;
            mem[4] <= 10;
            mem[5] <= 45;
            mem[6] <= 0;
            mem[7] <= 7;
        end
        else begin
            if(w_en) begin
                mem[addr >> 2] <= writedata;
            end
            else mem[addr >> 2] <= mem[addr >>2];
            
        end
    end
    initial begin
    
     // $readmemb("E:/Verilog_Training/thiet_ke_so/Single Cycle/riscvtest.txt", mem);
    end
endmodule