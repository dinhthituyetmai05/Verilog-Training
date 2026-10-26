module lam_hep_xung(
    input wire clk,
    input wire d, // input signal
    output reg q
);
    reg qff;
    always @(posedge clk) begin
        qff <= d;
    end
    assign q = (~qff) & d;
endmodule