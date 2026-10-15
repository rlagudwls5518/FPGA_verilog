`timescale 1ns / 1ps

module D_FF(
    input clk, //80hz
    input reset, D,
    output reg Q
    );

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            Q <= 0;
        end
        else begin
            Q <= D;
        end
    end

endmodule
