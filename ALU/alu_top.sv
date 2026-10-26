module alu_top(
    input logic [9:0] datain,

    output logic [6:0] hexout_a_donvi,
    output logic [6:0] hexout_a_chuc,
    output logic [6:0] hexout_b_donvi,
    output logic  [6:0] hexout_b_chuc,
    output logic [6:0] hexout_result_donvi,
    output logic [6:0] hexout_result_chuc
);
    logic [3:0] result;
    logic [3:0] a;
    logic [3:0] b;

    assign a = datain[3:0];
    assign b = datain[7:4];

    logic [3:0] a_donvi;
    logic [3:0] a_chuc;

    logic [3:0] b_donvi;
    logic [3:0] b_chuc;

    logic [3:0] result_donvi;
    logic [3:0] result_chuc;

    alu_4bit u_alu_4bit(
        .datain(datain),
        .result(result)
    );

    hextobcd_4bit u_a(
        .sohex4bit(a),
        .donvi(a_donvi),
        .chuc(a_chuc)
    );

    hextobcd_4bit u_b(
        .sohex4bit(b),
        .donvi(b_donvi),
        .chuc(b_chuc)
    );

    hextobcd_4bit u_result(
        .sohex4bit(result),
        .donvi(result_donvi),
        .chuc(result_chuc)
    );

    giai_ma_7seg u_a_donvi(
        .bin_in(a_donvi),
        .hex_out(hexout_a_donvi)
    );

    giai_ma_7seg u_a_chuc(
        .bin_in(a_chuc),
        .hex_out(hexout_a_chuc)
    );

    giai_ma_7seg u_b_donvi(
        .bin_in(b_donvi),
        .hex_out(hexout_b_donvi)
    );

    giai_ma_7seg u_b_chuc(
        .bin_in(b_chuc),
        .hex_out(hexout_b_chuc)
    );

    giai_ma_7seg u_result_donvi(
        .bin_in(result_donvi),
        .hex_out(hexout_result_donvi)
    );

    giai_ma_7seg u_result_chuc(
        .bin_in(result_chuc),
        .hex_out(hexout_result_chuc)
    );

endmodule