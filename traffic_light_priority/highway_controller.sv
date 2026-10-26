module highway_controller(
    input wire clk, rst,
    input wire car, Timeout, timeout,
    input wire enable_h,
    output reg[2:0] led_highway,
    output reg start_t_h, start_T_h,
    output reg enable_n
);
    typedef enum logic[1:0]{
        GREEN = 2'b00,
        YELLOW = 2'b01,
        RED = 2'b10
    }state_t;
    
    state_t current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if(rst) current_state <= GREEN;
        else current_state <= next_state; 
    end
    
    always @(*) begin
        start_t_h = 0;
        start_T_h = 0;
        enable_n = 0;
        case(current_state)
            GREEN: begin
                if(car && Timeout) begin
                    next_state = YELLOW;
                    start_t_h = 1;
                end
                else next_state <= GREEN;
            end
            YELLOW: begin
                if(timeout) begin
                    next_state = RED;
                    enable_n = 1;
                end
                else next_state = YELLOW;
            end
            RED: begin
                if( enable_h) begin
                    next_state = GREEN;
                    start_T_h = 1;
                end
                else next_state = RED;    
            end
            default: next_state = GREEN;
        endcase
    end
     always @(*) begin
        case( current_state)
            GREEN: led_highway = 3'b001;
            YELLOW:led_highway = 3'b010;
            RED: led_highway = 3'b100;
            default: led_highway = 3'b001;
        endcase
    end
endmodule