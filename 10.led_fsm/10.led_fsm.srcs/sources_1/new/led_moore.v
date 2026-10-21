`timescale 1ns / 1ps

module led_moore(
    input clk, reset, clean_btn,
    output [4:0] led
    );

    localparam [3:0] S00 = 4'b0000, //idle
                     S01 = 4'b0001,
                     S02 = 4'b0010,
                     S03 = 4'b0100,
                     S04 = 4'b1000;
                     

                     
    reg [3:0] r_curr_state, r_next_state;
    reg [3:0] r_led_out;
    reg dir;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_curr_state <= S00;
            dir <= 0;
        end   
        else begin
            if(r_curr_state == S00) dir <= 0;
            else if(r_curr_state == S03) dir <= 1;
            r_curr_state <= r_next_state;
        end
    end

    always @(*) begin
        r_next_state = r_curr_state;
        if(clean_btn)begin
            case(r_curr_state)
                S00: begin
                    r_next_state = S01;
                end
                S01: begin
                    if(!dir) r_next_state = S02;
                    else r_next_state = S00;
                end
                S02: begin
                    if(!dir) r_next_state = S03;
                    else r_next_state = S01;
                end
                S03: begin
                    r_next_state = S02;
                end
                S04: begin
                    r_next_state = S02;
                end
                default: r_next_state = S00;
            endcase     
        end
    end

    assign led[4:0] = {dir, r_curr_state};
endmodule
