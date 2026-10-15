`timescale 1ns / 1ps


module tb_adder_suber();
    reg [3:0] r_a, r_b;
    reg r_add_nsub;
    wire w_carry_out;
    wire [3:0] w_sum;



    adder_suber u_adder_suber(
        .a(r_a),
        .b(r_b),
        .add_nsub(r_add_nsub),
        .carry_out(w_carry_out),
        .sum(w_sum)
    );

    initial begin
        //add_nsum == 1 가산 0001 + 0010
        r_a = 1; r_b = 2; r_add_nsub = 1;

        //add_nsum == 1 가산 0011 + 0011
        #10 r_a = 3; r_b = 3; r_add_nsub = 1;

        //add_nsum == 1 가산 1000 + 1000 
        #10 r_a = 8; r_b = 8; r_add_nsub = 1;

        //add_nsum == 0 감산 0111 + 0011 
        #10 r_a = 7; r_b = 3; r_add_nsub = 0;

        //add_nsum == 0 감산 0011 + 0111 
        #10 r_a = 3; r_b = 7; r_add_nsub = 0;

        //add_nsum == 1 가산 0011 + 0011 
        #10 r_a = 3; r_b = 3; r_add_nsub = 0;

        #10
        $finish;
    end

endmodule
