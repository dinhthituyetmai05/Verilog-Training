module country_road_controller(
    input wire clk, rst,
    input wire Timeout, timeout,
    input wire enable_n,
    output reg[2:0] led_country,
    output reg start_t_n, start_T_n,
    output reg enable_h
);
    typedef enum logic[1:0] {
        GREEN = 2'b00,
        YELLOW = 2'b01,
        RED = 2'b10
    }state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if(rst) current_state <= RED;
        else current_state <= next_state;
    end

    always @(*) begin
        start_t_n = 0;
        start_T_n = 0;
        enable_h = 0;
        case(current_state)
            RED: begin
                if(enable_n) begin
                    next_state = GREEN;
                    start_T_n = 1;    
                end
                else next_state = RED;
            end
            GREEN: begin
                if(Timeout) begin
                    next_state = YELLOW;
                    start_t_n = 1;
                end
                else next_state =  GREEN;
            end
            YELLOW: begin
                if(timeout) begin
                    next_state = RED;
                    enable_h = 1;
                end
                else next_state = YELLOW;
            end
            default: next_state = RED;
        endcase
    end

    always @(*) begin
        case( current_state)
            GREEN: led_country = 3'b001;
            YELLOW:led_country = 3'b010;
            RED: led_country = 3'b100;
            default: led_country = 3'b100;
        endcase
    end
endmodule