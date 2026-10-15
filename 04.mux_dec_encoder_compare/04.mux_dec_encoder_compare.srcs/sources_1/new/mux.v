`timescale 1ns / 1ps

module mux2_1(a, b, sel, out);
    input a, b, sel;
    output out;

    reg r_out;

    always @(a, b, sel) begin
        case (sel)
            1'b1 : r_out = a;
            1'b0 : r_out = b; 
            default : r_out = 1'bx; 
        endcase
    end

    assign out = r_out;

endmodule
