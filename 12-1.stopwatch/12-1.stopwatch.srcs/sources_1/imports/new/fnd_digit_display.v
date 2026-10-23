`timescale 1ns / 1ps

module fnd_digit_display(
    input [1:0] sel,
    input [3:0] digit_1, digit_10, digit_100, digit_1000,

    output [3:0] an,
    output [7:0] seg
    );
endmodule
