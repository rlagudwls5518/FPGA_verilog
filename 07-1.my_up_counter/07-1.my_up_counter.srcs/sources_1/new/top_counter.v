`timescale 1ns / 1ps

module top_counter(
    input clk, reset, btnU, btnD,
    output [15:0] led
    );

    wire [15:0] w_led;
    wire [1:0] w_clean_btn;

    btn_debounce u_btn_debounce(
        .clk(clk),
        .reset(reset),
        .btnU(btnU),
        .btnD(btnD),
        .clean_btn(w_clean_btn)
    );

    up_counter u_up_counter(
        .clk(clk),
        .reset(reset),
        .clean_btn(w_clean_btn),
        .led(w_led)
    );

    assign led = w_led;

endmodule
