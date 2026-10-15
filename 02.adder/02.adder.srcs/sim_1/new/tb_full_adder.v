`timescale 1ns / 1ps


module tb_full_adder();
    reg r_a, r_b, r_c;
    wire w_sum, w_c_out;

    full_adder u_full_adder(
        .a(r_a),
        .b(r_b),
        .c(r_c),
        .sum(w_sum),
        .c_out(w_c_out)
    );

    initial begin
        #00 r_a = 0; r_b = 0; r_c = 0;
        #10 r_a = 0; r_b = 0; r_c = 1;
        #10 r_a = 0; r_b = 1; r_c = 0;
        #10 r_a = 0; r_b = 1; r_c = 1;
        #10 r_a = 1; r_b = 0; r_c = 0;
        #10 r_a = 1; r_b = 0; r_c = 1;
        #10 r_a = 1; r_b = 1; r_c = 0;
        #10 r_a = 1; r_b = 1; r_c = 1;
    end
endmodule
