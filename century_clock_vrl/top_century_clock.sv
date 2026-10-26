module top_century_clock (
    input  logic clk, rstn,
    input  logic [1:0] sw,  
    input logic switch,        
    input  logic btn_up, btn_down,
    input  logic btn_mod,    


    output logic [6:0] hexout0,
    output logic [6:0] hexout1,
    output logic [6:0] hexout2,
    output logic [6:0] hexout3,
    output logic [6:0] hexout4,
    output logic [6:0] hexout5,
    output logic [6:0] hexout6,
    output logic [6:0] hexout7
);
    
    // Tín hiệu giữa các module
    logic [6:0] gpg_hex[5:0];  // 6 LED cho giờ-phút-giây
    logic [6:0] ntn_hex[7:0];  // 8 LED cho ngày-tháng-năm

  
    top_giophutgiay U_gpg (
        .clk(clk),
        .rstn(rstn),
        .sw(sw),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .btn_mod(btn_mod),
        .switch(switch),
        .hexout_ch_gio(gpg_hex[5]),
        .hexout_dv_gio(gpg_hex[4]),
        .hexout_ch_phut(gpg_hex[3]),
        .hexout_dv_phut(gpg_hex[2]),
        .hexout_ch_giay(gpg_hex[1]),
        .hexout_dv_giay(gpg_hex[0])
    );

 
    top_ngaythangnam U_ntn (
        .clk(clk),
        .rstn(rstn),
        .sw(sw[1:0]),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .btn_mod(btn_mod),
        .switch(switch),
        .hexout_ch_ngay(ntn_hex[7]),
        .hexout_dv_ngay(ntn_hex[6]),
        .hexout_ch_thang(ntn_hex[5]),
        .hexout_dv_thang(ntn_hex[4]),
        .hexout_nghin_nam(ntn_hex[3]),
        .hexout_tram_nam(ntn_hex[2]),
        .hexout_chuc_nam(ntn_hex[1]),
        .hexout_dv_nam(ntn_hex[0])
    );


    // Mux chọn chế độ hiển thị
    always_comb begin
        if (switch == 1'b0) begin
            hexout0 = gpg_hex[0];
            hexout1 = gpg_hex[1];
            hexout2 = gpg_hex[2];
            hexout3 = gpg_hex[3];
            hexout4 = gpg_hex[4];
            hexout5 = gpg_hex[5];
            hexout6 = 7'b111_1111; // tắt
            hexout7 = 7'b111_1111; // tắt
        end else begin
            hexout0 = ntn_hex[0];
            hexout1 = ntn_hex[1];
            hexout2 = ntn_hex[2];
            hexout3 = ntn_hex[3];
            hexout4 = ntn_hex[4];
            hexout5 = ntn_hex[5];
            hexout6 = ntn_hex[6];
            hexout7 = ntn_hex[7];
        end
    end

endmodule
