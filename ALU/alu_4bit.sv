module alu_4bit (
    input logic [9:0] datain,
    output logic [3:0] result

);

    logic [3:0] a, b;
    logic [3:0] addsub_result;
    logic [1:0] opcode;
    logic sub;

    assign a = datain[3:0];
    assign b = datain[7:4];
    assign opcode = datain[9:8];
    assign sub = |(opcode);

    add_sub_4bit_sign add_sub (.sub(sub), .x(a), .y(b)
                , .result(addsub_result));
    

    always_comb begin
        case (opcode)
            3'b00, 3'b01: begin 
                result[3:0] = addsub_result;
            end
            3'b10: begin 
                result[3:0] = ~datain[3:0];
            end
            3'b011: begin
                result[3:0] = a & b;
            end
            default: begin
                result = 4'b00;
            end
        endcase
    end
endmodule