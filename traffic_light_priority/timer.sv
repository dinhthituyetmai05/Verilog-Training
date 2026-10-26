module timer #(
    parameter WIDTH = 32,  // số bit counter
    parameter T_VAL_MAIN = 10*50000000,    // giá trị đếm cho T
    parameter t_VAL_SMALL = 5*50000000    // giá trị đếm cho t
)(
    input  wire clk,
    input  wire rst,
    input  wire start_T,
    input  wire start_t,
    output reg  Timeout,
    output reg  timeout
);

    // Counter cho T
    reg [WIDTH-1:0] cnt_T;

    // Counter cho t
    reg [WIDTH-1:0] cnt_t;
    
    assign Timeout = (cnt_T == T_VAL_MAIN)?1:0;
    assign timeout = (cnt_t == t_VAL_SMALL)? 1:0;

    // Logic cho timer T
    always @(posedge clk or posedge rst)begin
        if(rst) cnt_T <= 0;
        else begin
            if(start_T) begin
                cnt_T <= 0;
            end
            else if( cnt_T <= T_VAL_MAIN) cnt_T <= cnt_T +1;
            else cnt_T <= 0;
        end
    end

    // Logic cho timer t
      always @(posedge clk or posedge rst)begin
        if(rst) cnt_t <= 0;
        else begin
            if(start_t) begin
                cnt_t <= 0;
            end
            else if(cnt_t <= t_VAL_SMALL) cnt_t <= cnt_t +1;
            else cnt_t <= 0;
        end
    end

endmodule