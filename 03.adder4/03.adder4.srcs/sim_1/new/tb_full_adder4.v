`timescale 1ns / 1ps


module tb_full_adder4();
    reg [3:0] a; 
    reg [3:0] b;
    reg cin; // 1bit

    wire [3:0] sum; 
    wire c_out;

    full_adder4 dut (
        .a(a),
        .b(b),
        .cin(cin), // 1bit
        .sum(sum),
        .c_out(c_out)
    );

    initial begin
        #00 a=0; b=0; cin=0;
        #10 a=0; b=2;
        #10 a=7; b=9;
        #10 a=9; b=9;
        #10 a=7; b=7;
        // for (integer i = 0; i < 20; i= i+1) begin
        //     #10 a=i;
        // end
        #10 $finish;
    end
endmodule
