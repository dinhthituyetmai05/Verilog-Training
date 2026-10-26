module chia_10enable #(
    parameter int N = 50000000
)(
    input logic clk,
    output logic ena1hz,
    output logic ena2hz,
    output logic ena5hz,
    output logic ena20hz,
    output logic ena50hz,
    output logic ena100hz,
    output logic ena1khz
);
    logic [$clog2(N)      :0] d1hz_r,    d1hz_n;
    logic [$clog2(N/2)    :0] d2hz_r,    d2hz_n;
    logic [$clog2(N/5)    :0] d5hz_r,    d5hz_n;
    logic [$clog2(N/20)   :0] d20hz_r,   d20hz_n;
    logic [$clog2(N/50)   :0] d50hz_r,   d50hz_n;
    logic [$clog2(N/100)  :0] d100hz_r,  d100hz_n;
    logic [$clog2(N/1000) :0] d1khz_r,   d1khz_n;

    always_ff @(posedge clk) begin
        d1hz_r <= d1hz_n; 
        d2hz_r <= d2hz_n; 
        d5hz_r <= d5hz_n;
        d20hz_r <= d20hz_n;  
        d50hz_r <= d50hz_n;
        d100hz_r <= d100hz_n;
        d1khz_r <= d1khz_n;
    end

    always_comb begin
        d1hz_n    = (d1hz_r    == N)        ? 1 : d1hz_r    + 1;
        d2hz_n    = (d2hz_r    == N/2)      ? 1 : d2hz_r    + 1;
        d5hz_n    = (d5hz_r    == N/5)      ? 1 : d5hz_r    + 1;
        d20hz_n   = (d20hz_r   == N/20)     ? 1 : d20hz_r   + 1;
        d50hz_n   = (d50hz_r   == N/50)     ? 1 : d50hz_r   + 1;
        d100hz_n  = (d100hz_r  == N/100)    ? 1 : d100hz_r  + 1;
        d1khz_n   = (d1khz_r   == N/1000)   ? 1 : d1khz_r   + 1;
    end

     always_comb begin
        ena1hz    = (d1hz_r    == N/2);
        ena2hz    = (d2hz_r    == N/4);
        ena5hz    = (d5hz_r    == N/10);
        ena20hz   = (d20hz_r   == N/40);
        ena50hz   = (d50hz_r   == N/100);
        ena100hz  = (d100hz_r  == N/200);
        ena1khz   = (d1khz_r   == N/2000);
    end
endmodule