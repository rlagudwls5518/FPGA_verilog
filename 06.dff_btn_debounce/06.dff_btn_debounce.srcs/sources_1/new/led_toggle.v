`timescale 1ns / 1ps


module led_toggle(
    input reset, clean_btn,
    output reg led
    );

    always @(posedge clean_btn or posedge reset) begin
        if (reset)
            led <= 1'b0;
        else
            led <= ~led;
    end

endmodule
