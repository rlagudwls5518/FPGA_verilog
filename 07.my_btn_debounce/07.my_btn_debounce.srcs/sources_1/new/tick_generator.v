`timescale 1ns / 1ps

module tick_generator(
    input clk, 
    input reset,
    output reg tick
    );

    reg [$clog2(100_000)-1:0] count_ms = 0;

    always @(posedge clk, posedge reset) begin
        if(reset)begin
            tick <= 0;
            count_ms <= 0;
        end
        else begin
            if(count_ms == (100_000 - 1))begin
                tick <= 1;
                count_ms <= 0;
            end
            else begin
                count_ms <= count_ms + 1; 
                tick <= 0;
            end
        end
    end

    

endmodule
