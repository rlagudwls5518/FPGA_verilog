`timescale 1ns / 1ps


module control_tower(
    input clk, reset, rx_done, // 8비트 수신완료 신호
    input [2:0] clean_btn,
    input [7:0] rx_data, // uart 8비트 데이터
    input [7:0] sw,

    output [15:0] led,
    output [13:0] seg_data
    );
endmodule
