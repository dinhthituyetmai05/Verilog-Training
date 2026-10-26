`timescale 1ns/1ps

module tb_traffic_light;

    reg clk;
    reg rst;
    reg car;
    wire [2:0] led_highway;
    wire [2:0] led_country;

    // Instance DUT
    traffic_light_top uut (
        .clk(clk),
        .rst(rst),
        .car(car),
        .led_highway(led_highway),
        .led_country(led_country)
    );

    // Clock 50 MHz
    always #10 clk = ~clk;

    initial begin
        $dumpfile("traffic_light_tb.vcd");
        $dumpvars(0, tb_traffic_light);

        // Khởi tạo
        clk = 0;
        rst = 1;
        car = 0;

        // Giữ reset 5 chu kỳ
        repeat(5) @(posedge clk);
        rst = 0;

        // Trường hợp 1: Không có xe
        repeat(50) @(posedge clk);

        // Trường hợp 2: Có xe ở đường nhánh
        car = 1;
        repeat(200) @(posedge clk);
        car = 0;

        // Trường hợp 3: Có xe sau một thời gian
        repeat(500) @(posedge clk);
        car = 1;
        repeat(200) @(posedge clk);
        car = 0;

        // Chạy thêm để quan sát
        repeat(1000) @(posedge clk);

        $finish;
    end

endmodule

