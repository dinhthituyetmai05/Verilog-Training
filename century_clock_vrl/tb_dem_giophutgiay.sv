`timescale 1ns/1ps

module tb_dem_giophutgiay;

    // Tín hiệu
    reg clk, rstn;
    reg ena_db;
    reg cdb_up, cdb_down;
    reg ena5hz;
    reg [1:0] gt_mod;
    wire [5:0] giay;
    wire [5:0] phut;
    wire [5:0] gio;

    // Gọi module cần test
    dem_giophutgiay uut (
        .clk(clk),
        .rstn(rstn),
        .ena_db(ena_db),
        .cdb_up(cdb_up),
        .cdb_down(cdb_down),
        .ena5hz(ena5hz),
        .gt_mod(gt_mod),
        .giay(giay),
        .phut(phut),
        .gio(gio)
    );

    // Tạo clock 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Sinh tín hiệu test
    initial begin
        // Khởi tạo
        rstn = 0;
        ena_db = 0;
        cdb_up = 0;
        cdb_down = 0;
        ena5hz = 0;
        gt_mod = 2'b00;

        // Reset
        #20 rstn = 1;

        // ---------------- Test đếm tự động giây ----------------
        ena_db = 1;
        repeat (65) @(negedge clk); // đếm hơn 60 giây để rollover
        ena_db = 0;

        // ---------------- Test chỉnh giây lên ----------------
        gt_mod = 2'b01; // chế độ chỉnh giây
        ena5hz = 1;
        repeat (3) begin
            cdb_up = 1; @(negedge clk);
            cdb_up = 0; @(negedge clk);
        end
        ena5hz = 0;

        // ---------------- Test chỉnh phút xuống ----------------
        gt_mod = 2'b10; // chế độ chỉnh phút
        ena5hz = 1;
        repeat (2) begin
            cdb_down = 1; @(negedge clk);
            cdb_down = 0; @(negedge clk);
        end
        ena5hz = 0;

        // ---------------- Test chỉnh giờ ----------------
        gt_mod = 2'b11; // chế độ chỉnh giờ
        ena5hz = 1;
        repeat (5) begin
            cdb_up = 1; @(negedge clk);
            cdb_up = 0; @(negedge clk);
        end
        ena5hz = 0;

        // Kết thúc
        #50 $finish;
    end

    // Monitor kết quả
    initial begin
        $display("Time\tGiay\tPhut\tGio");
        $monitor("%0t\t%0d\t%0d\t%0d", $time, giay, phut, gio);
    end

endmodule
