module dem_ngaythangnam (
    input  logic clk, rstn,
    input  logic ena_db,                 
    input  logic cdb_up, cdb_down,        
    input  logic ena5hz,   
    input logic switch,               
    input  logic [1:0] gt_mod, // 01: chỉnh ngày, 10: chỉnh tháng, 11: chỉnh năm
    output logic [5:0] ngay,              
    output logic [4:0] thang,             
    output logic [15:0] nam              
);

    // Thanh ghi trạng thái hiện tại
    logic [5:0] ngay_r, ngay_n;
    logic [4:0] thang_r, thang_n;
    logic [15:0] nam_r, nam_n;

    logic [3:0]  nghin_nam;
    logic [3:0]  tram_nam;
    logic [3:0]  chuc_nam;
    logic [3:0]  dv_nam;

    logic [5:0] giay;
    logic [5:0] phut;
    logic [5:0] gio;
    dem_giophutgiay r3(
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
    hextobcd_16bit r1(
        .sohex16bit(nam),
        .donvi(dv_nam),
        .chuc(chuc_nam),
        .tram(tram_nam),
        .nghin(nghin_nam)
    );
    logic [6:0] nghin_tram_bin;
    bcd_to_binary r2(
        .bcd_nghin(nghin_nam),
        .bcd_tram(tram_nam),
        .binary(nghin_tram_bin)
    );
    // Hàm trả về số ngày tối đa trong tháng
    function automatic [5:0] max_day_in_month(input [4:0] thang, input [15:0] nam, input [3:0] dv_nam, input [3:0] chuc_nam, input [6:0] nghin_tram_bin);
        case (thang)
            5'd1, 5'd3, 5'd5, 5'd7, 5'd8, 5'd10, 5'd12: max_day_in_month = 6'd31;
            5'd4, 5'd6, 5'd9, 5'd11: max_day_in_month = 6'd30;
            5'd2: begin
                if ((|dv_nam == 1'b0) && (|chuc_nam == 1'b0)) begin 
                    if(nghin_tram_bin[1:0] == 2'b00) max_day_in_month = 6'd29;
                    else max_day_in_month = 6'd28;
                end
                else if(nam[1:0] == 2'b00)
                    max_day_in_month = 6'd29;
                else 
                    max_day_in_month = 6'd28; 
            end
            default: max_day_in_month = 6'd31;
        endcase
    endfunction

    // Cập nhật thanh ghi
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ngay_r  <= 6'd1;
            thang_r <= 5'd1;
            nam_r   <= 16'd2025;
        end else begin
            ngay_r  <= ngay_n;
            thang_r <= thang_n;
            nam_r   <= nam_n;
        end
    end

    // Logic đếm ngày
    always @(ena_db, giay, phut, gio, ngay_r, thang_r, nam_r, dv_nam, chuc_nam, nghin_tram_bin, gt_mod, ena5hz, switch, cdb_down, cdb_up) begin
        ngay_n = ngay_r;
        if (ena_db == 1'b1 && giay == 6'd59 && phut == 6'd59 && gio == 6'd23 ) begin
            if (ngay_r == max_day_in_month(thang_r, nam_r, dv_nam, chuc_nam, nghin_tram_bin))
                ngay_n = 6'd1;
            else 
                ngay_n = ngay_r + 1;
        end
        else if (gt_mod == 2'b01 && !cdb_up && ena5hz == 1'b1 && switch == 1'b1 ) begin 
            if (ngay_r == max_day_in_month(thang_r, nam_r, dv_nam, chuc_nam, nghin_tram_bin))
                ngay_n = 6'd1;
            else
                ngay_n = ngay_r + 1; 
        end
        else if (gt_mod == 2'b01 && !cdb_down && ena5hz && switch == 1'b1) begin
                if (ngay_r == 6'd1)
                    ngay_n = max_day_in_month(thang_r, nam_r, dv_nam, chuc_nam, nghin_tram_bin);
                else
                    ngay_n = ngay_r - 1;
        end
    end

    // Logic đếm tháng
    always @(ena_db, ngay_r, thang_r, nam_r, dv_nam, chuc_nam, nghin_tram_bin, gt_mod, ena5hz, switch, cdb_down, cdb_up) begin 
        thang_n = thang_r;
        if (ena_db && ngay_r == max_day_in_month(thang_r, nam_r, dv_nam, chuc_nam, nghin_tram_bin)) begin
            if (thang_r == 5'd12)
                thang_n = 5'd1;
            else
                thang_n = thang_r + 1;
        end
        else if (gt_mod == 2'b10 && !cdb_up && ena5hz && switch == 1'b1) begin
            if (thang_r == 5'd12)
                thang_n = 5'd1;
            else
                thang_n = thang_r + 1;
        end
        else if (gt_mod == 2'b10 && !cdb_down && ena5hz && switch == 1'b1) begin
            if (thang_r == 5'd1)
                thang_n = 5'd12;
            else
                thang_n = thang_r - 1;
        end
    end

    // Logic đếm năm
    always @(ena_db, ngay_r, thang_r, nam_r, dv_nam, chuc_nam, nghin_tram_bin, gt_mod, ena5hz, switch, cdb_down, cdb_up) begin
        nam_n = nam_r;
        if (ena_db && ngay_r == max_day_in_month(thang_r, nam_r, dv_nam, chuc_nam, nghin_tram_bin) && thang_r == 5'd12) begin
            nam_n = nam_r + 1;
        end
        else if (gt_mod == 2'b11 && !cdb_up && ena5hz && switch == 1'b1) begin
            nam_n = nam_r + 1;
        end
        else if (gt_mod == 2'b11 && !cdb_down && ena5hz && switch == 1'b1) begin
            nam_n = nam_r - 1;
        end
    end

   
    always @(ngay_r, thang_r, nam_r) begin
        ngay  = ngay_r;
        thang = thang_r;
        nam   = nam_r;
    end

endmodule
