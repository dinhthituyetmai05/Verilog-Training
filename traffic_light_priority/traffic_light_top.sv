module traffic_light_top (
    input wire clk,
    input wire rst,
    input wire car,
    output reg[2:0] led_highway,
    output reg[2:0] led_country
);
    wire Timeout;    
    wire timeout;    
    wire start_T_h;  
    wire start_t_h;  
    wire start_T_n;  
    wire start_t_n;  
    wire enable_h;   
    wire enable_n;   

    wire start_T = start_T_h|start_T_n;
    wire start_t = start_t_h|start_t_n;

    highway_controller u_highway(
        .clk(clk),
        .rst(rst),
        .car(car),
        .Timeout(Timeout),
        .timeout(timeout),
        .enable_h(enable_h),
        .led_highway(led_highway),
        .start_t_h(start_t_h),
        .start_T_h(start_T_h),
        .enable_n(enable_n)
    );

    country_road_controller u_country(
        .clk(clk),
        .rst(rst),
        .Timeout(Timeout),
        .timeout(timeout),
        .enable_n(enable_n),
        .led_country(led_country),
        .start_t_n(start_t_n),   
        .start_T_n(start_T_n),
        .enable_h(enable_h)
    );

    timer #(
        .WIDTH(32),
        .T_VAL_MAIN(10*50000000),
        .t_VAL_SMALL(5*50000000)
    ) u_timer(
        .clk(clk),
        .rst(rst),
        .start_T(start_T),
        .start_t(start_t),
        .Timeout(Timeout),
        .timeout(timeout)
    );
endmodule