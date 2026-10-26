module giama_hienthi_gpg(
    input wire[7:0] enable_gpg,
    input logic [3:0] ch_gio,
    input logic [3:0] dv_gio,
    input logic [3:0] ch_phut,
    input logic [3:0] dv_phut,
    input logic [3:0] ch_giay,
    input logic [3:0] dv_giay,
    output logic [6:0] hexout_ch_gio,
    output logic [6:0] hexout_dv_gio,
    output logic [6:0] hexout_ch_phut,
    output logic [6:0] hexout_dv_phut,
    output logic [6:0] hexout_ch_giay,
    output logic [6:0] hexout_dv_giay
);
    giai_ma_7doan_ena A1(
        .bin_in(ch_gio),
        .ena(enable_gpg[5]),
        .hex_out(hexout_ch_gio)
    );
    giai_ma_7doan_ena A2(
        .bin_in(dv_gio),
        .ena(enable_gpg[4]),
        .hex_out(hexout_dv_gio)
    );
    giai_ma_7doan_ena A3(
        .bin_in(ch_phut),
        .ena(enable_gpg[3]),
        .hex_out(hexout_ch_phut)
    );
    giai_ma_7doan_ena A4(
        .bin_in(dv_phut),
        .ena(enable_gpg[2]),
        .hex_out(hexout_dv_phut)
    );
    giai_ma_7doan_ena A5(
        .bin_in(ch_giay),
        .ena(enable_gpg[1]),
        .hex_out(hexout_ch_giay)
    );
    giai_ma_7doan_ena A6(
        .bin_in(dv_giay),
        .ena(enable_gpg[0]),
        .hex_out(hexout_dv_giay)
    );

endmodule