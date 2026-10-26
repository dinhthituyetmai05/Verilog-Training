module debounce #(
    parameter N = 20
)(
    input wire clk,
    input wire btn,
    output reg db_tick
);
    typedef enum reg [1:0]{
        ZERO = 2'b00,
        WAIT0 = 2'b01,
        ONE = 2'b10,
        WAIT1 = 2'b11
    }db_state_t;

    db_state_t current_db, next_db;
    reg [N-1:0] current_dl, next_dl;

    always @(posedge clk) begin
        current_db <= next_db;
        current_dl <= next_dl;
    end

    always @(*)begin 
        next_dl = current_dl;
        next_db = current_db;

        case(current_db)
            ZERO: begin 
                if(btn) begin
                    next_db = WAIT1;
                    next_dl = {N{1'b1}};
                end
                else next_db = ZERO;
            end

            WAIT1: begin
                next_dl = current_dl -1;
                if( current_dl == 0)begin
                    if( btn ) next_db = ONE;
                    else next_db = ZERO;
                end
                else next_db =  WAIT1;
            end

            ONE: begin
                if(!btn) begin 
                    next_db =  WAIT0;
                    next_dl = {N{1'b1}};
                end
                else next_db = ONE;
            end

            WAIT0: begin 
                next_dl = current_dl -1;
                if(current_dl == 0) begin 
                    if(!btn) next_db = ZERO;
                    else next_db = ONE;
                end
                else next_db = WAIT0;
            end
        endcase
    end

    always @(*) begin 
        case(current_db) 
            ZERO: db_tick = 0;
            WAIT1: db_tick = 0;
            ONE: db_tick = 1;
            WAIT0: db_tick = 1;
        endcase
    end

endmodule

