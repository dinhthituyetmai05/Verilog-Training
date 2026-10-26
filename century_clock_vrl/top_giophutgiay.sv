module top_giophutgiay(
    input logic clk,rstn,
    input logic [1:0] sw,
    input logic btn_up, btn_down,
    input logic switch,
    input logic btn_mod,
    output logic [6:0] hexout_ch_gio,
    output logic [6:0] hexout_dv_gio,
    output logic [6:0] hexout_ch_phut,
    output logic [6:0] hexout_dv_phut,
    output logic [6:0] hexout_ch_giay,
    output logic [6:0] hexout_dv_giay
);
    logic ena1hz, ena2hz, ena5hz, ena20hz, ena50hz, ena100hz, ena1khz, ena_db;
    logic[5:0] giay, phut, gio;
    logic [3:0] ch_gio, dv_gio, ch_phut, dv_phut, ch_giay, dv_giay;
    logic [7:0] enable_gpg;

    assign ena_db = (sw == 2'b00)? ena1hz:
                    (sw == 2'b01)? ena20hz:
                    (sw == 2'b10)? ena50hz:
                    (sw == 2'b11)? ena100hz : ena1khz;

    chia_10enable M1(
        .clk(clk),
        .ena1hz(ena1hz),
        .ena2hz(ena2hz),
        .ena5hz(ena5hz),
        .ena20hz(ena20hz),
        .ena50hz(ena50hz),
        .ena100hz(ena100hz),
        .ena1khz(ena1khz)
    );

    dem_giophutgiay_3key M2(
        .clk(clk),
        .rstn(rstn),
        .ena_db(ena_db),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .btn_mod(btn_mod),
        .ena5hz(ena5hz),
        .ena2hz(ena2hz),
        .switch(switch),
        .enable_gpg(enable_gpg),
        .giay(giay),
        .phut(phut),
        .gio(gio)
    );

    hextobcd_gpg M3(
        .gio(gio),
        .phut(phut),
        .giay(giay),
        .ch_giay(ch_giay),
        .dv_giay(dv_giay),
        .ch_phut(ch_phut),
        .dv_phut(dv_phut),
        .ch_gio(ch_gio),
        .dv_gio(dv_gio)
    );
    
    giama_hienthi_gpg M4(
        .enable_gpg(enable_gpg),
        .ch_gio(ch_gio),
        .dv_gio(dv_gio),
        .ch_phut(ch_phut),
        .dv_phut(dv_phut),
        .ch_giay(ch_giay),
        .dv_giay(dv_giay),
        .hexout_ch_gio(hexout_ch_gio),
        .hexout_dv_gio(hexout_dv_gio),
        .hexout_ch_phut(hexout_ch_phut),
        .hexout_dv_phut(hexout_dv_phut),
        .hexout_ch_giay(hexout_ch_giay),
        .hexout_dv_giay(hexout_dv_giay)
    );
endmodule