`timescale 1ns / 1ps

module led_mealy(
    input clk, reset, clean_btn,
    output reg [4:0] led
    );

    localparam [3:0] S00 = 4'b0001,
                     S01 = 4'b0010,
                     S02 = 4'b0100,
                     S03 = 4'b1000;

                     
    reg [3:0] r_curr_state, r_next_state;
    reg [3:0] r_led_out;
    reg r_curr_dir, r_next_dir;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_curr_state <= S00;
            r_curr_dir <= 0;
        end   
        else begin
            r_curr_state <= r_next_state;
            r_curr_dir <= r_next_dir;
        end
    end

    always @(*) begin
        r_next_state = r_curr_state;
        r_next_dir = r_curr_dir;
        if(clean_btn)begin
            case(r_curr_state)
                S00: begin
                    r_next_state = S01;
                    r_next_dir = 0;
                end
                S01: begin
                    if(!r_curr_dir) r_next_state = S02;
                    else r_next_state = S00;
                end
                S02: begin
                    if(!r_curr_dir) r_next_state = S03;
                    else r_next_state = S01;
                end
                S03: begin
                    r_next_state = S02;
                    r_next_dir = 1;
                end
                default: r_next_state = S00;
            endcase     
        end
        led = {r_curr_dir, r_curr_state};
    end
endmodule
