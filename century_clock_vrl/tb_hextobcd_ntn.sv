`timescale 1ns/1ps

module tb_hextobcd_ntn;

    // Ngõ vào
    reg  [5:0]  ngay;
    reg  [4:0]  thang;
    reg  [15:0] nam;

    // Ngõ ra
    wire [3:0]  ch_ngay, dv_ngay;
    wire [3:0]  ch_thang, dv_thang;
    wire [3:0]  nghin_nam, tram_nam, chuc_nam, dv_nam;

    // Instance DUT
    hextobcd_ngaythangnam dut (
        .ngay(ngay),
        .thang(thang),
        .nam(nam),
        .ch_ngay(ch_ngay),
        .dv_ngay(dv_ngay),
        .ch_thang(ch_thang),
        .dv_thang(dv_thang),
        .nghin_nam(nghin_nam),
        .tram_nam(tram_nam),
        .chuc_nam(chuc_nam),
        .dv_nam(dv_nam)
    );

    // Test procedure
    initial begin
        $display("==== TEST BCD CHO NGAY-THANG-NAM ====");

        // Test 1: 01/01/2000
        ngay  = 6'd1;
        thang = 5'd1;
        nam   = 16'd2000;
        #10;
        $display("Ngay: %0d%0d, Thang: %0d%0d, Nam: %0d%0d%0d%0d",
                 ch_ngay, dv_ngay, ch_thang, dv_thang,
                 nghin_nam, tram_nam, chuc_nam, dv_nam);

        // Test 2: 15/07/2025
        ngay  = 6'd15;
        thang = 5'd7;
        nam   = 16'd2025;
        #10;
        $display("Ngay: %0d%0d, Thang: %0d%0d, Nam: %0d%0d%0d%0d",
                 ch_ngay, dv_ngay, ch_thang, dv_thang,
                 nghin_nam, tram_nam, chuc_nam, dv_nam);

        // Test 3: 31/12/1999
        ngay  = 6'd31;
        thang = 5'd12;
        nam   = 16'd1999;
        #10;
        $display("Ngay: %0d%0d, Thang: %0d%0d, Nam: %0d%0d%0d%0d",
                 ch_ngay, dv_ngay, ch_thang, dv_thang,
                 nghin_nam, tram_nam, chuc_nam, dv_nam);

        // Test 4: 29/02/2024 (năm nhuận)
        ngay  = 6'd29;
        thang = 5'd2;
        nam   = 16'd2024;
        #10;
        $display("Ngay: %0d%0d, Thang: %0d%0d, Nam: %0d%0d%0d%0d",
                 ch_ngay, dv_ngay, ch_thang, dv_thang,
                 nghin_nam, tram_nam, chuc_nam, dv_nam);

        $stop;
    end

endmodule
