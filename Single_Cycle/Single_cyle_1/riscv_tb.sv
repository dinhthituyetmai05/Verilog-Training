module testbench();
    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr;
    logic MemWrite;

    // instantiate DUT
    riscv dut(clk, reset, WriteData, DataAdr, MemWrite);

    // initialize
    initial begin
        reset <= 0; #22; reset <= 1;
    end

    // clock
    // always begin
    //     clk <= 1; #5; clk <= 0; #5;
    // ends
    initial clk = 0;

    always #5 clk = ~clk;

    initial begin
    // check results
        repeat(100) begin
            @(posedge clk); 
        end
    end
    // always @(negedge clk) begin
    //     if (MemWrite) begin
    //         if (DataAdr === 100 && (WriteData === 32'd25)) begin
    //             $display("Simulation succeeded: program executed correctly");
    //             $stop;
    //         end else if (DataAdr !== 96) begin
    //             $display("Simulation failed");
    //             $stop;
    //         end
    //     end
    // end
endmodule