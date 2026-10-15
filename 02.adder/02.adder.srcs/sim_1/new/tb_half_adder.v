`timescale 1ns / 1ps


module tb_half_adder();

    reg a, b;

    wire sum, c_out;

    half_adder dut(
        .a(a),
        .b(b),
        .sum(sum),
        .c_out(c_out)
    );

    initial begin

    #00 a = 1'b0; b = 1'b0;
    #10 a = 1'b0; b = 1'b1;
    #10 a = 1'b1; b = 1'b0;
    #10 a = 1'b1; b = 1'b1;
    #10 $finish;

    end
endmodule
