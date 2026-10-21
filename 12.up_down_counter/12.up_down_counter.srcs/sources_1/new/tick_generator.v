`timescale 1ns / 1ps

module tick_generator(
    input clk, reset,
    output reg tick
    );
    
    parameter INPUT_FREQ = 100_000_000;
    parameter TICK_Hz = 1000;
    parameter TICK_COUNT = INPUT_FREQ/TICK_Hz;

    reg [$clog2(TICK_COUNT)-1:0] r_tick_counter = 0;

    always @(posedge clk, posedge reset) begin
        if(reset)begin
            tick <= 0;
            r_tick_counter <= 0;
        end
        else begin
            if(r_tick_counter == (TICK_COUNT - 1))begin
                tick <= 1;
                r_tick_counter <= 0;
            end
            else begin
                r_tick_counter <= r_tick_counter + 1; 
                tick <= 0;
            end
        end
    end
endmodule
