`timescale 1ns / 1ps


//1. 100mhz-->> 10mhz의 주파수 생성
//2. 10mhz로 듀티 조정

module pwm_duty_control(
    input clk, reset,
    input [2:0] clean_btn,
    
    output pwm_out, pwm_out_led,
    output [3:0] duty_cycle
    );
endmodule
