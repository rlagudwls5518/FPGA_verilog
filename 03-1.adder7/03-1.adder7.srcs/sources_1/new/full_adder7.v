`timescale 1ns / 1ps



module full_adder7(
    input [6:0] a,
    input [6:0] b,
    input cin, // 1bit
    output [6:0] sum,
    output c_out
    );
    wire w_carry0, w_carry1, w_carry2, w_carry3, w_carry4, w_carry5;

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
        .c_out(w_carry3)
    );
    full_adder FA4(
        .a(a[4]),
        .b(b[4]),
        .sum(sum[4]),
        .cin(w_carry3),
        .c_out(w_carry4)
    );
    full_adder FA5(
        .a(a[5]),
        .b(b[5]),
        .sum(sum[5]),
        .cin(w_carry4),
        .c_out(w_carry5)
    );
    full_adder FA6(
        .a(a[6]),
        .b(b[6]),
        .sum(sum[6]),
        .cin(w_carry5),
        .c_out(c_out)
    );
endmodule
