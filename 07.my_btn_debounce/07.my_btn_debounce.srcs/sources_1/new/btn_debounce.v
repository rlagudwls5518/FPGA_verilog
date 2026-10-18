`timescale 1ns / 1ps

module btn_debounce(
    input clk, btnU, btnD, reset,
    output reg [1:0] clean_btn
    );

    reg [3:0] count_10ms = 0;

    //10ms 카운터 로직
    always @(posedge reset, posedge clk) begin
        if(reset) begin
            clean_btn <= 0;
            count_10ms <= 4'b0;
        end else  begin
            if(btn != clean_btn)begin 
                if(count_10ms == 4'b1001)begin
                    clean_btn <= btn;
                    count_10ms <= 4'b0;
                end else begin
                    count_10ms  <= count_10ms + 1'b1;
                end
            end else begin
                count_10ms <= 4'b0;
            end
        end
    end


    

endmodule
