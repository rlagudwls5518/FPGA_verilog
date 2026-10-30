`timescale 1ns / 1ps


//1. 100mhz-->> 10mhz의 주파수 생성
//2. 10mhz로 듀티 조정

module pwm_duty_control(
    input clk, reset,
    input [2:0] clean_btn, //btn[0] = U, btn[1] = D, btn[2] = C
    
    output pwm_out, pwm_out_led,
    output [3:0] duty_cycle
    );

    reg [3:0] r_duty_cycle = 4'd5; // default 50% 
    reg r_prev_duty_inc = 1'b0; 
    reg r_prev_duty_dec = 1'b0;

    reg [3:0] r_pwm_counter = 4'd0;
    

    // btnU btnD rising edge check
    wire w_duty_inc = (clean_btn[0] && !r_prev_duty_inc);
    wire w_duty_dec = (clean_btn[1] && !r_prev_duty_dec);

    //1. duty cycle 제어( btnU, btnD)
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_duty_cycle <= 4'd5;
            r_prev_duty_inc <= 0;
            r_prev_duty_dec <= 0;
        end else begin
            r_prev_duty_inc <= clean_btn[0];
            r_prev_duty_dec <= clean_btn[1];
            if (w_duty_inc && r_duty_cycle <= 4'd9) r_duty_cycle <= r_duty_cycle + 1;
            if (w_duty_dec && r_duty_cycle >= 4'd1) r_duty_cycle <= r_duty_cycle - 1;
        end
    end

    //2. 10Mhz PWM 신호 생성
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_pwm_counter <= 0;
        end else begin
            if (r_pwm_counter >= 4'd9) r_pwm_counter <= 0;
            else r_pwm_counter <= r_pwm_counter + 1;
        end
    end

    assign pwm_out = (r_pwm_counter < r_duty_cycle) ? 1'b1 : 1'b0;
    assign pwm_out_led = pwm_out;
    assign duty_cycle = r_duty_cycle;

endmodule
