`timescale 1ns / 1ps


module shift_register(
    input clk, reset, btn_press, x,
    output  [15:0] led
    );

    //버튼 눌렀다가 뗀 순간만 shift
    reg [2:0] sr3;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            sr3 <=0;
        end else if(btn_press) begin
            sr3 <={sr3[1:0], x}; // shift reg
        end
    end

    assign led[2:0] = sr3;
    

endmodule
