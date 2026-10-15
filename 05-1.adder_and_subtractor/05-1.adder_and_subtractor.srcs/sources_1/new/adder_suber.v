`timescale 1ns / 1ps


module adder_suber(
    input [3:0] a, b,
    input add_nsub,
    output reg [3:0] sum,
    output reg carry_out
    );

    always @(*) begin
        if(add_nsub == 1'b1)begin
            {carry_out, sum} = a + b;
        end
        else begin
            {carry_out, sum} = a + (~b) + 1'b1;
        end
    end

    //assign {carry_out, sum[3:0]} = add_nsub ? a[3:0] + b[3:0] : a[3:0] + (~b[3:0]) +4'b1;


endmodule
