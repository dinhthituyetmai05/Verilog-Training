`timescale 1ns/1ps
module tb_top_giophutgiay;

    // --- Tín hiệu test ---
    logic clk, rstn;
    logic [1:0] sw;
    logic btn_up, btn_down, btn_mod;

    logic [6:0] hexout_ch_gio, hexout_dv_gio;
    logic [6:0] hexout_ch_phut, hexout_dv_phut;
    logic [6:0] hexout_ch_giay, hexout_dv_giay;

    // --- DUT ---
    top_giophutgiay uut (
        .clk(clk), .rstn(rstn),
        .sw(sw),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .btn_mod(btn_mod),
        .hexout_ch_gio(hexout_ch_gio),
        .hexout_dv_gio(hexout_dv_gio),
        .hexout_ch_phut(hexout_ch_phut),
        .hexout_dv_phut(hexout_dv_phut),
        .hexout_ch_giay(hexout_ch_giay),
        .hexout_dv_giay(hexout_dv_giay)
    );

    // --- Clock 10ns ---
    initial clk = 0;
    always #5 clk = ~clk;

    // --- Task mô phỏng nhấn nút ---
    task press_button(input string name, output logic btn);
        begin
            btn = 1;
            #200;        // giữ 200ns để debounce kịp nhận
            btn = 0;
            #200;        // chờ ổn định
            $display("[%0t] Nhấn %s", $time, name);
        end
    endtask

    // --- Kịch bản test ---
    initial begin
        // Reset
        rstn = 0;
        btn_up = 0; btn_down = 0; btn_mod = 0;
        sw = 2'b00;    // chọn 1Hz
        #50;
        rstn = 1;
        $display("[%0t] Reset xong", $time);

        // --- Chỉnh GIÂY ---
        press_button("MODE", btn_mod);   // vào chế độ chỉnh giây
        press_button("UP", btn_up);      // giây++
        press_button("DOWN", btn_down);  // giây--

        // --- Chỉnh GIỜ ---
        press_button("MODE", btn_mod);   // chuyển sang chỉnh phút
        press_button("MODE", btn_mod);   // chuyển sang chỉnh giờ
        press_button("UP", btn_up);      // giờ++
        press_button("DOWN", btn_down);  // giờ--

        #2000;
        $finish;
    end

endmodule
