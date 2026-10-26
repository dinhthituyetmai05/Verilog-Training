module hextobcd_ntn (
    input  logic [5:0]  ngay,       
    input  logic [4:0]  thang,      
    input  logic [15:0] nam,        
    output logic [3:0]  ch_ngay,
    output logic [3:0]  dv_ngay,
    output logic [3:0]  ch_thang,
    output logic [3:0]  dv_thang,
    output logic [3:0]  nghin_nam,
    output logic [3:0]  tram_nam,
    output logic [3:0]  chuc_nam,
    output logic [3:0]  dv_nam
);

    
    hextobcd_6bit K1 (
        .sohex6bit(ngay),
        .donvi(dv_ngay),
        .chuc(ch_ngay)
    );

    
    hextobcd_6bit K2 (
        .sohex6bit({1'b0, thang}),
        .donvi(dv_thang),
        .chuc(ch_thang)
    );

    
    hextobcd_16bit K3 (
        .sohex16bit(nam),
        .donvi(dv_nam),
        .chuc(chuc_nam),
        .tram(tram_nam),
        .nghin(nghin_nam)
    );

endmodule


module hextobcd_16bit (
    input  wire [15:0] sohex16bit,
    output reg  [3:0] donvi,
    output reg  [3:0] chuc,
    output reg  [3:0] tram,
    output reg  [3:0] nghin
);
    integer i;
    reg [31:0] bcd; 
    
    always @(*) begin
        bcd = {16'b0, sohex16bit};  
        for (i = 0; i < 16; i = i + 1) begin
            if (bcd[19:16] >= 5)
                bcd[19:16] = bcd[19:16] + 3;
            if (bcd[23:20] >= 5)
                bcd[23:20] = bcd[23:20] + 3;
            if (bcd[27:24] >= 5)
                bcd[27:24] = bcd[27:24] + 3;
            if (bcd[31:28] >= 5)
                bcd[31:28] = bcd[31:28] + 3;
            bcd = bcd << 1;
        end
        donvi = bcd[19:16];
        chuc  = bcd[23:20];
        tram  = bcd[27:24];
        nghin = bcd[31:28];
    end
endmodule
