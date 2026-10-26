module dem_ngaythangnam_3key (
    input  logic clk, rstn,
    input  logic ena_db,             
    input  logic btn_up, btn_down,   
    input  logic btn_mod,       
    input  logic ena5hz, 
    input logic ena2hz,
    input logic switch,      
    output [7:0] enable_ntn,      
    output logic [5:0] ngay,         
    output logic [4:0] thang,        
    output logic [15:0] nam          
);

    logic cdb_up, cdb_down;
    logic [1:0] gt_mod;

    
    debounce K1 (
        .clk(clk),
        .btn(btn_up),
        .db_tick(cdb_up)
    );

    
    debounce K2 (
        .clk(clk),
        .btn(btn_down),
        .db_tick(cdb_down)
    );

    xu_ly_mod_ntn K3(
        .clk(clk),
        .rstn(rstn),
        .btn_mod(btn_mod),
        .gt_mod(gt_mod),
        .ena2hz(ena2hz),
        .cdb_up(cdb_up),
        .cdb_down(cdb_down),
        .enable_ntn(enable_ntn)
    );
    
    dem_ngaythangnam K4 (
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

endmodule
