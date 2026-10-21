`timescale 1ns / 1ps

module shift_register(
    input clk, reset, x,btn_press,
    output  [15:0] led
    );

    //버튼 눌렀다가 뗀 순간만 shift
    reg [6:0] sr7;

    always @(negedge clk, posedge reset) begin
        if(reset) begin
            sr7 <=0;
        end else if(btn_press) begin
            sr7 <={sr7[5:0], x}; // shift reg
        end
    end
    
    assign led[7] = (sr7 == 7'b1010111);
    assign led[15:8] = 0;
    assign led [6:0] = sr7;

endmodule
