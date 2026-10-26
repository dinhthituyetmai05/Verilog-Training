module tb_hextobcd_6bit;
     // Tín hiệu test
    reg  [5:0] sohex6bit;
    wire [3:0] donvi;
    wire [3:0] chuc;

    // Gọi module cần test
    hextobcd_6bit uut (
        .sohex6bit(sohex6bit),
        .donvi(donvi),
        .chuc(chuc)
    );

    integer i;

    initial begin
        $display("Time(ns)\tHex6bit\tDec\tChuc\tDonvi");
        $display("-------------------------------------------");

        // Test tất cả các giá trị từ 0 đến 63
        for (i = 0; i < 64; i = i + 1) begin
            sohex6bit = i;
            #1; // Chờ 1ns cho mạch tổ hợp ổn định
            $display("%0t\t%0d\t%0d\t%0d\t%0d",
                $time, sohex6bit, (chuc*10 + donvi), chuc, donvi);
        end

        $finish;
    end
endmodule