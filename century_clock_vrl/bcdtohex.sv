module bcd_to_binary (
    input  logic [3:0] bcd_nghin, 
    input  logic [3:0] bcd_tram,  
    output logic [6:0] binary  
);
    always_comb begin
        binary = (bcd_nghin * 4'd10) + bcd_tram;
    end
endmodule
