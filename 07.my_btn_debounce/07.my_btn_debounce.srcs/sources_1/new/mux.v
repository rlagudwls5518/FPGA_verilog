`timescale 1ns / 1ps

module mux(
    input btnU, btnD, sel,
    output reg sel_btn
    );


    always @(*) begin
        if(sel)begin
            sel_btn = btnU;
        end else begin
            sel_btn = btnD;
        end
    end

endmodule
