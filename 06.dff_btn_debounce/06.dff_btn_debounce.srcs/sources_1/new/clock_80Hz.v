`timescale 1ns / 1ps

module clock_80Hz #(
    parameter DIV = 1_250_000 // 80Hz --> default값
                             // 외부에서 값을 지정하지않으면 현재 값으로 동작
)(
    input clk, reset,
    output reg oclk
    );
    //100MHz->80MHz

    //reg [23:0] r_count = 0; // 1,250,000 (10ns x 1,250,000 = 12.5ms)
    reg [$clog2(DIV)-1:0] r_count = 0;
    // log2(8)의 결과
    //비동기 리셋 0 -> 1
    //10ns의 clk이 상승에지거나 reset 신호가 오면 수행
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            oclk <= 0;
            r_count <= 0;
        end else begin
            if(r_count == (DIV/2)-1) begin // 80hz 1주기 12.5ms  절반 하이 절반 로우니까 
                r_count <= 0;
                oclk <= ~oclk;
            end 
            else begin
               r_count <= r_count + 1; 
            end
        end 
    end
endmodule
