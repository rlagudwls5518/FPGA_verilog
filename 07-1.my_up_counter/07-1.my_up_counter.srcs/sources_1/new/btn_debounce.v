`timescale 1ns / 1ps


module btn_debounce(
    input clk, reset, btnU, btnD,
    output reg [1:0] clean_btn
    );

    wire [1:0] btn = {btnD, btnU};
    reg [19:0] count_10ms = 0; // 1_000_000 10ms 디바운스   

    //10ms 카운터 로직
    always @(posedge reset, posedge clk) begin
        if(reset) begin
            clean_btn <= 2'b0;
            count_10ms <= 20'b0;
        end else  begin
            if(btn != clean_btn)begin 
                if(count_10ms == 999_999)begin
                    clean_btn <= btn;
                    count_10ms <= 20'b0;
                end else begin
                    count_10ms  <= count_10ms + 1'b1;
                end
            end else begin
                count_10ms <= 20'b0;
            end
        end
    end
endmodule
