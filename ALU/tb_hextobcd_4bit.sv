`timescale 1ns/1ps

module tb_hextobcd_4bit;

    reg  [3:0] sohex4bit;
    wire [3:0] donvi;
    wire [3:0] chuc;

    // Khai báo module cần test
    hextobcd_4bit uut (
        .sohex4bit(sohex4bit),
        .donvi(donvi),
        .chuc(chuc)
    );

    integer i;

    initial begin
        $display("HEX\tCHUC\tDONVI\t(DECIMAL)");
        $display("-------------------------------");

        // Test từ 0 đến 15
        for (i = 0; i < 16; i = i + 1) begin
            sohex4bit = i;
            #5; // delay 5ns để cập nhật kết quả
            $display("%d\t%d\t%d\t%0d", sohex4bit, chuc, donvi, chuc*10 + donvi);
        end

        $stop; // kết thúc simulation
    end

endmodule
