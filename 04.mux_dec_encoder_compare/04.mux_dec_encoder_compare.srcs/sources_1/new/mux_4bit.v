`timescale 1ns / 1ps


module mux_4bit(a, b, sel, out, led);
    input [3:0] a, b;
    input sel;
    output [3:0] out;
    output [7:0] led;

    reg [3:0] r_out;

    // always @(*) begin
    //     case (sel)
    //         1'b1 : r_out = a;
    //         1'b0 : r_out = b; 
    //         default : r_out = 1'bx; 
    //     endcase
    // end

    // assign out[3:0] = r_out[3:0];
    assign led = {b, a};
    assign out = sel ? a : b; 

endmodule
