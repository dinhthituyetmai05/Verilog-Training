module dem_giophutgiay_3key(
    input logic clk, rstn,
    input logic ena_db,
    input logic btn_up, btn_down,
    input logic btn_mod,
    input logic ena5hz,
    input logic ena2hz,
    input logic switch,
    output [7:0] enable_gpg,
    output logic [5:0] giay,
    output logic [5:0] phut,
    output logic [5:0] gio
);
    logic cdb_up, cdb_down;
    logic [1:0] gt_mod;
    xu_ly_mod_gpg K4(
        .clk(clk),
        .rstn(rstn),
        .btn_mod(btn_mod),
        .gt_mod(gt_mod),
        .ena2hz(ena2hz),
        .cdb_up(cdb_up),
        .cdb_down(cdb_down),
        .enable_gpg(enable_gpg)
    );

    debounce K1(
        .clk(clk),
        .btn(btn_up),
        .db_tick(cdb_up)
    );

    debounce K2(
        .clk(clk),
        .btn(btn_down),
        .db_tick(cdb_down)
    );

    dem_giophutgiay K3(
        .clk(clk),
        .rstn(rstn),
        .ena_db(ena_db),
        .cdb_up(cdb_up),
        .cdb_down(cdb_down),
        .ena5hz(ena5hz),
        .switch(switch),
        .gt_mod(gt_mod),
        .gio(gio),
        .phut(phut),
        .giay(giay)
    );
endmodule