`timescale 1ns / 1ps


module tick_generator(
    input reset, clk,
    output reg tim_1ms
    );

    reg [16:0] count_ms = 0;

    always @(posedge clk, posedge reset) begin
        if(reset)begin
            tim_1ms <= 0;
            count_ms <= 0;
        end
        else begin
            if(count_ms == (100_000 - 1))begin
                tim_1ms <= ~tim_1ms;
                count_ms <= 0;
            end
            else begin
                count_ms <= count_ms + 1; 
            end
        end
    end
endmodule
