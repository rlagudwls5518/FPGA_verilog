`timescale 1ns / 1ps

module led_toggle(
    input btn, reset,
    output reg led
    );

    always @(posedge btn, posedge reset) begin
        if(reset)begin
            led <= 1'b0;
        end else begin
            led <= ~led;
        end
    end

endmodule
