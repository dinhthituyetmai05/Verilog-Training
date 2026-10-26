module hextobcd_4bit (
    input  wire [3:0] sohex4bit,
    output reg  [3:0] donvi,
    output reg  [3:0] chuc
);
    integer i;
    reg [7:0] bcd;

    always @(*) begin
        case(sohex4bit)
            4'b0000: begin
                donvi = 4'b000;
                chuc  = 4'b000;
            end

            4'b0001: begin
                donvi = 4'b0001;
                chuc = 4'b0000;
            end
            4'b0010: begin
                donvi = 4'b0010;
                chuc = 4'b0000;
            end
            4'b0011: begin
                donvi = 4'b0011;
                chuc = 4'b0000;
            end
            4'b0100: begin
                donvi = 4'b0100;
                chuc = 4'b0000;
            end
            4'b0101: begin
                donvi = 4'b0101;
                chuc = 4'b0000;
            end
            4'b0110: begin
                donvi = 4'b0110;
                chuc = 4'b0000;
            end
            4'b0111: begin
                donvi = 4'b0111;
                chuc = 4'b0000;
            end
            4'b1000: begin
                donvi = 4'b1000;
                chuc = 4'b0000;
            end
            4'b1001: begin
                donvi = 4'b1001;
                chuc = 4'b0000;
            end
            4'b1010: begin
                donvi = 4'b0000;
                chuc = 4'b0001;
            end
            4'b1011: begin
                donvi = 4'b0001;
                chuc = 4'b0001;
            end
            4'b1100: begin
                donvi = 4'b0010;
                chuc = 4'b0001;
            end
            4'b1101: begin
                donvi = 4'b0011;
                chuc = 4'b0001;
            end
            4'b1110: begin
                donvi = 4'b0100;
                chuc = 4'b0001;
            end
            4'b1111: begin
                donvi = 4'b0101;
                chuc = 4'b0001;
            end
            default: begin
                donvi = 4'b0110;
                chuc = 4'b0001;
            end
        endcase
        // bcd = {4'd0, sohex4bit};

        
        // for (i = 0; i < 4; i = i + 1) begin
        //     // Nếu hàng đơn vị >= 5, cộng 3
        //     if (bcd[7:4] >= 5)
        //         bcd[7:4] = bcd[7:4] + 3;

        //     // Nếu hàng chục >= 5, cộng 3
        //     if (bcd[3:0] >= 5)  
        //         bcd[3:0] = bcd[3:0] + 3;

        //     // Shift trái 1 bit
        //     bcd = bcd << 1;
        // end
        // chuc  = bcd[7:4];
        // donvi = bcd[3:0];
    end
endmodule
