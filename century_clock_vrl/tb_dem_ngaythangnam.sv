`timescale 1ns/1ps

module tb_dem_ngaythangnam;
    logic clk, rstn;
    logic ena_db;
    logic cdb_up, cdb_down;
    logic ena5hz;
    logic switch;
    logic [1:0] gt_mod; // 01: ngày, 10: tháng, 11: năm
    logic [5:0] ngay;
    logic [4:0] thang;
    logic [15:0] nam;

    // DUT
    dem_ngaythangnam uut (
        .clk(clk),
        .rstn(rstn),
        .ena_db(ena_db),
        .cdb_up(cdb_up),
        .cdb_down(cdb_down),
        .ena5hz(ena5hz),
        .switch(switch),
        .gt_mod(gt_mod),
        .ngay(ngay),
        .thang(thang),
        .nam(nam)
    );

    // Tạo clock 10ns
    always #5 clk = ~clk;

    // Task mô phỏng bấm nút UP/DOWN
    task press_button(input logic up, input logic down);
        begin
            cdb_up   = up;
            cdb_down = down;
            ena5hz   = 1;  // giả lập xung quét phím
            #20;
            ena5hz   = 0;
            #20;
        end
    endtask

    initial begin
        $dumpfile("tb_dem_ngaythangnam.vcd");
        $dumpvars(0, tb_dem_ngaythangnam);

        // Khởi tạo
        clk = 0; rstn = 0;
        ena_db = 0; cdb_up = 1; cdb_down = 1; ena5hz = 0;
        switch = 1;
        gt_mod = 2'b00;
        #50;

        // Reset
        rstn = 1;
        #50;
        $display("After reset: %0d/%0d/%0d", ngay, thang, nam);

        // ==========================
        // Test chỉnh ngày
        // ==========================
        gt_mod = 2'b01; // chỉnh ngày
        $display("Test chỉnh ngày");
        press_button(0, 1);  // UP
        $display("After +1 day: %0d/%0d/%0d", ngay, thang, nam);
        press_button(1, 0);  // DOWN
        $display("After -1 day: %0d/%0d/%0d", ngay, thang, nam);

        // ==========================
        // Test chỉnh tháng
        // ==========================
        gt_mod = 2'b10; // chỉnh tháng
        $display("Test chỉnh tháng");
        press_button(0, 1);  // UP
        $display("After +1 month: %0d/%0d/%0d", ngay, thang, nam);
        press_button(1, 0);  // DOWN
        $display("After -1 month: %0d/%0d/%0d", ngay, thang, nam);

        // ==========================
        // Test chỉnh năm
        // ==========================
        gt_mod = 2'b11; // chỉnh năm
        $display("Test chỉnh năm");
        press_button(0, 1);  // UP
        $display("After +1 year: %0d/%0d/%0d", ngay, thang, nam);
        press_button(1, 0);  // DOWN
        $display("After -1 year: %0d/%0d/%0d", ngay, thang, nam);

        // ==========================
        // Test tăng ngày tự động khi hết 23:59:59
        // ==========================
        $display("Test tăng ngày tự động");
        ena_db = 1;  // giả lập tín hiệu qua 1 ngày
        #20;
        ena_db = 0;
        #20;
        $display("After auto +1 day: %0d/%0d/%0d", ngay, thang, nam);

        $finish;
    end

endmodule
