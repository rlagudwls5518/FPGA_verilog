`timescale 1ns / 1ps


module tb_full_adder7();
    reg [6:0] a; 
    reg [6:0] b;
    reg cin; // 1bit

    wire [6:0] sum; 
    wire c_out;

    full_adder7 dut (
        .a(a),
        .b(b),
        .cin(cin), // 1bit
        .sum(sum),
        .c_out(c_out)
    );

    initial begin
        
        #00 a = 0;   b = 0;   cin = 0; // sum=0,   c_out=0
        #10 a = 25;  b = 30;  // sum=55,  c_out=0
        #10 a = 85;  b = 42;   // sum=127, c_out=0 
        #10 a = 85;  b = 42;   // sum=0,   c_out=1 
        #10 a = 127; b = 0;    // sum=0,   c_out=1
        #10 a = 126; b = 1;    // sum=0,   c_out=1
        #10 a = 127; b = 127;  // sum=126, c_out=1
        #10 a = 127; b = 127;  // sum=127, c_out=1
        #10 $finish;
    end
endmodule
