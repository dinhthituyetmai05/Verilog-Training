module hextobcd_gpg(
    input logic [5:0] gio,
    input logic [5:0] phut,
    input logic [5:0] giay,
    output logic [3:0] ch_gio,
    output logic [3:0] dv_gio,
    output logic [3:0] ch_phut,
    output logic [3:0] dv_phut,
    output logic [3:0] ch_giay,
    output logic [3:0] dv_giay
);
    hextobcd_6bit K1 (
        .sohex6bit(gio),
        .donvi(dv_gio),
        .chuc(ch_gio)
    );

    hextobcd_6bit K2 (
        .sohex6bit(phut),
        .donvi(dv_phut),
        .chuc(ch_phut)
    );

    hextobcd_6bit K3 (
        .sohex6bit(giay),
        .donvi(dv_giay),
        .chuc(ch_giay)
    );
endmodule

module hextobcd_6bit (
    input  wire [5:0] sohex6bit,
    output reg  [3:0] donvi,
    output reg  [3:0] chuc
);
    integer i;
    reg [13:0] bcd;

    always @(*) begin
        bcd = {8'b00000000, sohex6bit};  // 14-bit: 8-bit BCD + 6-bit input
        for (i = 0; i < 6; i = i + 1) begin
            // Nếu digit >= 5 thì cộng 3
            if (bcd[9:6] >= 5)
                bcd[9:6] = bcd[9:6] + 3;
            if (bcd[13:10] >= 5)
                bcd[13:10] = bcd[13:10] + 3;
            // Shift trái 1 bit
            bcd = bcd << 1;
        end
        donvi = bcd[9:6];
        chuc  = bcd[13:10];
    end
endmodule