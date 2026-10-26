module giama_hienthi_ntn(
    input wire[7:0] enable_ntn,
    input  logic [3:0] ch_ngay,
    input  logic [3:0] dv_ngay,
    input  logic [3:0] ch_thang,
    input  logic [3:0] dv_thang,
    input  logic [3:0] nghin_nam,
    input  logic [3:0] tram_nam,
    input  logic [3:0] chuc_nam,
    input  logic [3:0] dv_nam,

    output logic [6:0] hexout_ch_ngay,
    output logic [6:0] hexout_dv_ngay,
    output logic [6:0] hexout_ch_thang,
    output logic [6:0] hexout_dv_thang,
    output logic [6:0] hexout_nghin_nam,
    output logic [6:0] hexout_tram_nam,
    output logic [6:0] hexout_chuc_nam,
    output logic [6:0] hexout_dv_nam
);

    giai_ma_7doan_ena D1 (
        .bin_in(ch_ngay),
        .ena(enable_ntn[7]),
        .hex_out(hexout_ch_ngay)
    );

    giai_ma_7doan_ena D2 (
        .bin_in(dv_ngay),
        .ena(enable_ntn[6]),
        .hex_out(hexout_dv_ngay)
    );

    giai_ma_7doan_ena D3 (
        .bin_in(ch_thang),
        .ena(enable_ntn[5]),
        .hex_out(hexout_ch_thang)
    );

    giai_ma_7doan_ena D4 (
        .bin_in(dv_thang),
        .ena(enable_ntn[4]),
        .hex_out(hexout_dv_thang)
    );

    giai_ma_7doan_ena D5 (
        .bin_in(nghin_nam),
        .ena(enable_ntn[3]),
        .hex_out(hexout_nghin_nam)
    );

    giai_ma_7doan_ena D6 (
        .bin_in(tram_nam),
        .ena(enable_ntn[2]),
        .hex_out(hexout_tram_nam)
    );

    giai_ma_7doan_ena D7 (
        .bin_in(chuc_nam),
        .ena(enable_ntn[1]),
        .hex_out(hexout_chuc_nam)
    );

    giai_ma_7doan_ena D8 (
        .bin_in(dv_nam),
        .ena(enable_ntn[0]),
        .hex_out(hexout_dv_nam)
    );

endmodule
