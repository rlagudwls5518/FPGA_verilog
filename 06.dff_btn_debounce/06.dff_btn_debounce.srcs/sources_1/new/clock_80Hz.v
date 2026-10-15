`timescale 1ns / 1ps

module clock_80Hz(
    input clk, reset,
    output reg oclk
    );
    //100MHz->80MHz

    reg [23:0] r_count = 0; // 1,250,000 (10ns x 1,250,000 = 12.5ms)
    //reg [$clog2(1250000)-1:0] r_count = 0; 같은 표현
    // log2(8)의 결과
    //비동기 리셋 0 -> 1
    //10ns의 clk이 상승에지거나 reset 신호가 오면 수행
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            oclk <= 0;
            r_count <= 0;
        end else begin
            if(r_count == (1_250_000/2)-1) begin // 80hz 1주기 12.5ms  절반 하이 절반 로우니까 
                r_count <= 0;
                oclk <= ~oclk;
            end 
            else begin
               r_count <= r_count + 1; 
            end
        end 
    end
endmodule
