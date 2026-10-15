`timescale 1ns / 1ps


module led_toggle(
    input clean_btn,
    output led
    );

    reg r_toggle = 1'b0;

    always @(posedge clean_btn) begin
        r_toggle <= ~r_toggle;        
    end

    assign led = r_toggle ? 1'b1 : 1'b0;

endmodule
