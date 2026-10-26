module xu_ly_mod_gpg (
    input  wire clk, rstn,
    input  wire btn_mod,
    input logic ena2hz,
    input logic cdb_down, cdb_up,
    output logic [1:0] gt_mod,
    output [7:0] enable_gpg
);
    logic [1:0] gt_mod_t;
    dem_2bit_btn n1(
        .clk(clk),
        .rstn(rstn),
        .btn(btn_mod),
        .q(gt_mod)
    );
    assign gt_mod_t = gt_mod;
    mod_nhapnhay_gpg n2(
        .clk(clk),
        .rstn(rstn),
        .cdb_up(cdb_up),
        .cdb_down(cdb_down),
        .ena2hz(ena2hz),
        .gt_mod(gt_mod_t),
        .enable_gpg(enable_gpg)
    );

endmodule


module dem_2bit_btn(
    input  wire clk, rstn,
    input  wire btn,
    output reg [1:0] q
);
    wire xcd, xcdlh;
    debounce u1(
        .clk(clk),
        .btn(btn),       
        .db_tick(xcd)
    );

    lam_hep_xung u2(
        .clk(clk),
        .d(xcd),
        .q(xcdlh)
    );

    dem_2bit u3(
        .clk(clk),
        .rstn(rstn),
        .ena_db(xcdlh),
        .q(q)
    );
endmodule


module dem_2bit(
    input  wire clk, rstn,
    input  wire ena_db,
    output reg [1:0] q
);
    logic [1:0] q_r, q_n;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) q <= 2'b00;
        else if (ena_db) q <= q + 1;
    end
endmodule

module mod_nhapnhay_gpg(
    input logic clk, rstn,
    input logic cdb_up, cdb_down,
    input logic ena2hz,
    input logic [1:0] gt_mod,
    // output logic [5:0] q,
    output logic [7:0] enable_gpg
);
    // logic [4:0] q_r, q_n;
    logic [7:0] enable_r, enable_n;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin 
            // q_r <= 5'b00000;
            enable_r <= 8'b00111111;
        end
        else begin
            // q_r <= q_n;
            enable_r <= enable_n;
        end
    end

    always @(cdb_up, cdb_down, ena2hz, enable_r, gt_mod) begin
        enable_n = enable_r;
        // q_n = q_r;
        if(gt_mod == 2'b01) begin
            if(!cdb_up == 1'b0 && !cdb_down == 1'b0) begin
                if(ena2hz) begin
                    enable_n = {6'b001111,~enable_r[1:0]};
                    // q_n = q_r + 1;
                end
                else begin 
                    enable_n = enable_r;
                end
            end      
            else begin 
            enable_n = 8'b00111111;
            // q_n = 5'b00000;
            end
        end
        else if(gt_mod == 2'b10) begin
            if(!cdb_up == 1'b0 && !cdb_down == 1'b0) begin
                if(ena2hz) begin
                    enable_n = {4'b0011, ~enable_r[3:2], 2'b11};
                    // q_n = q_r + 1;
                end
                else enable_n = enable_r   ; 
            end
            else begin 
                enable_n = 8'b00111111;
                // q_n = 5'b00000;
            end
        end
        else if(gt_mod == 2'b11) begin
            if(!cdb_up == 1'b0 && !cdb_down == 1'b0) begin
                if(ena2hz) begin
                    enable_n = {2'b00, ~enable_r[5:4], 4'b1111};
                    // q_n = q_r + 1;
                end
                else enable_n = enable_r   ; 
            end
            else begin 
                enable_n = 8'b00111111;
                // q_n = 5'b00000;
            end
        end
    end

    always @(*) begin
        // q = q_r;
        enable_gpg = enable_r;
    end
endmodule

