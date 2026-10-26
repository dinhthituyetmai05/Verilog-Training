module top_ngaythangnam (
    input  logic clk, rstn,
    input  logic [1:0] sw,           
    input  logic btn_up, btn_down,   
    input  logic btn_mod, 
    input logic switch,     
    output logic [6:0] hexout_ch_ngay,
    output logic [6:0] hexout_dv_ngay,
    output logic [6:0] hexout_ch_thang,
    output logic [6:0] hexout_dv_thang,
    output logic [6:0] hexout_nghin_nam,
    output logic [6:0] hexout_tram_nam,
    output logic [6:0] hexout_chuc_nam,
    output logic [6:0] hexout_dv_nam
);
   
    logic ena1hz, ena2hz, ena5hz, ena20hz, ena50hz, ena100hz, ena1khz, ena_db;
    logic [7:0] enable_ntn;
    logic [5:0]  ngay;   
    logic [4:0]  thang;  
    logic [15:0] nam;    


    logic [3:0] ch_ngay, dv_ngay;
    logic [3:0] ch_thang, dv_thang;
    logic [3:0] nghin_nam, tram_nam, chuc_nam, dv_nam;

    assign ena_db = (sw == 2'b00) ? ena1hz   :
                    (sw == 2'b01) ? ena20hz  :
                    (sw == 2'b10) ? ena50hz  :
                    (sw == 2'b11) ? ena100hz : ena1khz;


    chia_10enable M1 (
        .clk(clk),
        .ena1hz(ena1hz),
        .ena2hz(ena2hz),
        .ena5hz(ena5hz),
        .ena20hz(ena20hz),
        .ena50hz(ena50hz),
        .ena100hz(ena100hz),
        .ena1khz(ena1khz)
    );

 
    dem_ngaythangnam_3key M2 (
        .clk(clk),
        .rstn(rstn),
        .ena_db(ena_db),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .btn_mod(btn_mod),
        .ena5hz(ena5hz),
        .ena2hz(ena2hz),
        .enable_ntn(enable_ntn),
        .switch(switch),
        .ngay(ngay),
        .thang(thang),
        .nam(nam)
    );


    hextobcd_ntn M3 (
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


    giama_hienthi_ntn M4 (
        .enable_ntn(enable_ntn),
        .ch_ngay(ch_ngay),
        .dv_ngay(dv_ngay),
        .ch_thang(ch_thang),
        .dv_thang(dv_thang),
        .nghin_nam(nghin_nam),
        .tram_nam(tram_nam),
        .chuc_nam(chuc_nam),
        .dv_nam(dv_nam),
        .hexout_ch_ngay(hexout_ch_ngay),
        .hexout_dv_ngay(hexout_dv_ngay),
        .hexout_ch_thang(hexout_ch_thang),
        .hexout_dv_thang(hexout_dv_thang),
        .hexout_nghin_nam(hexout_nghin_nam),
        .hexout_tram_nam(hexout_tram_nam),
        .hexout_chuc_nam(hexout_chuc_nam),
        .hexout_dv_nam(hexout_dv_nam)
    );

endmodule
