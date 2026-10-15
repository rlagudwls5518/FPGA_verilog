`timescale 1ns / 1ps



module full_adder4(
    input [3:0] a,
    input [3:0] b,
    input cin, // 1bit
    output [3:0] sum,
    output c_out
    );
    wire w_carry0, w_carry1, w_carry2;

    full_adder FA0(
        .a(a[0]),
        .b(b[0]),
        .sum(sum[0]),
        .cin(cin),
        .c_out(w_carry0)
    );
    full_adder FA1(
        .a(a[1]),
        .b(b[1]),
        .sum(sum[1]),
        .cin(w_carry0),
        .c_out(w_carry1)
    );
    full_adder FA2(
        .a(a[2]),
        .b(b[2]),
        .sum(sum[2]),
        .cin(w_carry1),
        .c_out(w_carry2)
    );
    full_adder FA3(
        .a(a[3]),
        .b(b[3]),
        .sum(sum[3]),
        .cin(w_carry2),
        .c_out(c_out)
    );


endmodule
