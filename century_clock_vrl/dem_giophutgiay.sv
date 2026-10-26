module dem_giophutgiay (
    input logic clk, rstn,
    input logic ena_db,
    input logic cdb_up, cdb_down,
    input logic ena5hz,
    input logic switch,
    input logic [1:0] gt_mod,// 01: chỉnh giay, 10: chỉnh phut, 11: chỉnh gio
    output logic [5:0] giay,
    output logic [5:0] phut,
    output logic [5:0] gio
);

    // Các thanh ghi lưu trạng thái hiện tại
    logic [5:0] giay_r, giay_n;
    logic [5:0] phut_r, phut_n;
    logic [4:0] gio_r, gio_n;
    // register update
    always @(posedge clk or negedge rstn) begin
        if ( !rstn ) begin
            giay_r <= 6'd0;
            phut_r <= 6'd0;
            gio_r  <= 5'd0;
        end else begin
            giay_r <= giay_n;
            phut_r <= phut_n;
            gio_r  <= gio_n;
        end
    end

    // Logic tính giây kế tiếp
    always @(giay_r, ena_db, gt_mod, cdb_up, cdb_down, ena5hz, switch) begin
        giay_n = giay_r;
        if (gt_mod == 2'b00 && ena_db) begin
            if (giay_r == 6'b111011) giay_n = 6'b000000;   
            else giay_n = giay_r + 1;       
        end
        else if( gt_mod == 2'b01  && ena5hz == 1'b1 && switch == 1'b0 ) begin
                if (!cdb_up) begin
                    if (giay_r == 6'b111011) giay_n = 6'b000000;
                    else giay_n = giay_r + 1;
                end
                else if (!cdb_down) begin
                    if (giay_r == 6'b000000) giay_n = 6'b111011;
                    else giay_n = giay_r - 1;
                end 
            end
        end

    // Logic tính phút kế tiếp
    always @(giay_r, phut_r, ena_db, gt_mod, cdb_up, cdb_down, ena5hz,  switch) begin
        phut_n = phut_r;
        if ( gt_mod == 2'b00 && ena_db == 1 && giay_r == 6'b111011) begin
            if (phut_r == 6'b111011) phut_n = 6'b000000;   
            else phut_n = phut_r + 1; 
        end
        else if( gt_mod == 2'b10  && ena5hz == 1'b1  && switch == 1'b0  ) begin
                if (!cdb_up) begin
                    if (phut_r == 6'b111011) phut_n = 6'b000000;
                    else phut_n = phut_r + 1;
                end
                else if (!cdb_down) begin
                    if (phut_r == 6'b000000) phut_n = 6'b111011;
                else phut_n = phut_r -1 ;
                end        
            end
        end

    // Logic tính giờ kế tiếp
    always @(giay_r, phut_r, gio_r, ena_db, gt_mod, cdb_up, cdb_down, ena5hz,  switch) begin
        gio_n = gio_r;
        if ( gt_mod == 2'b00 && ena_db == 1 && giay_r == 6'b111011 && phut_r == 6'b111011 ) begin
            if (gio_r == 6'b10111) gio_n = 6'b00000;   
            else gio_n = gio_r + 1; 
        end
        else if( gt_mod == 2'b11  && ena5hz == 1'b1  && switch == 1'b0 ) begin
             if (!cdb_up) begin
                if (gio_r == 6'b10111) gio_n = 6'b00000;
                else gio_n = gio_r + 1;   
            end
            else if (!cdb_down)  begin
                if (gio_r == 6'b00000) gio_n = 6'b10111;
                else gio_n = gio_r - 1;   
            end     
        end
    end

    // Gán output
    always @(*) begin
        giay = giay_r;
        phut = phut_r;
        gio  = {1'b0, gio_r};  
    end

endmodule

