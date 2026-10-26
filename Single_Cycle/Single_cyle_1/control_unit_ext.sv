module control_unit_ext(
    input [6:0] op,
    input [2:0] funct3,
    input funct75,
    input [31:0] zero,
    output reg PCSrc,
    output reg [1:0] ResultSrc,
    output reg Memwrite,
    output reg [3:0] ALUControl, 
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output  reg RegWrite
);
    reg branch;
    reg [1:0] ALUOp;
    reg jump;

    always @(op) begin
        case(op)
            7'b0110011: begin //Rtype
                ResultSrc = 2'b00;
                Memwrite = 1'b0;
                ALUOp = 2'b10;
                ImmSrc = 2'b00;
                RegWrite = 1'b1;
                ALUSrc = 1'b0;
                branch = 1'b0;
                jump = 0;
            end 
            7'b0000011 : begin//Itype load
                branch = 1'b0;
                ResultSrc = 2'b01;
                Memwrite = 1'b0;
                ALUOp = 2'b00;
                ALUSrc = 1'b1;
                ImmSrc = 2'b00;
                RegWrite = 1'b1;
                jump = 0;
            end
            7'b0010011 : begin// Itype add...
                branch = 1'b0;
                ResultSrc = 2'b00;
                Memwrite = 1'b0;
                ALUOp = 2'b10;
                ALUSrc = 1'b1;
                ImmSrc = 2'b00;
                RegWrite = 1'b1;
                jump = 0;
            end
            7'b0100011: begin //Stype
                branch = 1'b0;
                ResultSrc = 2'b00;//xx
                Memwrite = 1'b1;
                ALUOp = 2'b00;
                ALUSrc = 1'b1;
                ImmSrc = 2'b01;
                RegWrite = 1'b0;
                jump = 0;
            end
            7'b1100011: begin //Btype
                branch = 1'b1;
                ResultSrc = 2'b00; //xx
                Memwrite = 1'b0;
                ALUOp = 2'b01;
                ALUSrc = 1'b0;
                ImmSrc = 2'b10;
                RegWrite = 1'b0; 
                jump = 0;
            end
            7'b1101111: begin //Jtype
                branch = 1'b0;
                ResultSrc = 2'b10; 
                Memwrite = 1'b0;
                ALUOp = 2'b00;//xx
                ALUSrc = 1'b1;//x
                ImmSrc = 2'b11;
                RegWrite = 1'b1; 
                jump = 1;
            end
        endcase
    end

    always @(ALUOp, funct3, funct75) begin
        case(ALUOp)
            2'b00: begin  
                ALUControl = 4'b0000;
            end
            2'b01: begin  
                ALUControl = 4'b0001;
            end
            2'b10: begin  
                case(funct3)
                    3'b000: begin
                        if({op[5], funct75} == 2'b11) begin
                            ALUControl = 4'b0001; //sub
                        end
                        else ALUControl = 4'b0000; //add
                    end
                    3'b001: ALUControl = 4'b0010; //sll
                    3'b010: ALUControl = 4'b0011; //slt
                    3'b011: ALUControl = 4'b0100; //sltu
                    3'b100: ALUControl = 4'b0101; //xor
                    3'b101: begin
                        if({op[5], funct75} == 2'b11) begin
                            ALUControl = 4'b0111; //sra
                        end
                        else ALUControl = 4'b110; //srl
                    end
                    3'b110: ALUControl = 4'b1000;
                    3'b111: ALUControl = 4'b1001;
                    default: ALUControl = 4'b0000;
                endcase 
            end
            default: ALUControl =4'b0000;
        endcase
    end
    // assign PCSrc = (zero  && branch) || (jump);
    always@(funct3, zero , branch, jump)begin 
        if(zero == 0 && funct3 == 3'b000 && branch || jump) begin
            PCSrc = 1'b1;
        end
        else if(zero != 0 && funct3 == 3'b001 && branch || jump) begin
            PCSrc = 1'b1;
        end
        else if(zero < 0 && funct3 == 3'b100 && branch || jump) begin
            PCSrc = 1'b1;
        end
        else if((zero == 0 || zero > 0)  && funct3 == 3'b101 && branch || jump) begin
            PCSrc = 1'b1;
        end
        else PCSrc = 1'b0;
    end

endmodule