`timescale 1ns / 1ps

module top_pwm_controller(
    input clk, reset,
    input [2:0] btn,
    input [1:0] sw,

    output pwm_out, pwm_out_led,
    output [1:0] led_in2,
    output [3:0] an,
    output [7:0] seg
    );

    wire w_tick_1ms;
    wire [2:0] w_clean_btn;

    wire w_duty_cycle;
    wire [1:0]w_sw;

    debouncer u_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn),
        .clean_btn(w_clean_btn)
    );

    tick_generator u_tick_generator(
        .clk(clk),
        .reset(reset),
        .tick_1ms(w_tick_1ms)
    );

    pwm_duty_control u_pwm_duty_control(
        .clk(clk),
        .reset(reset),
        .clean_btn(w_clean_btn),
        .pwm_out(pwm_out), 
        .pwm_out_led(pwm_out_led),
        .duty_cycle(w_duty_cycle)
    );

    fnd_controller u_fnd_controller(
        .clk(clk),
        .reset(reset),
        .tick(w_tick_1ms),
        .in_data(w_duty_cycle),
        .motor_direction(w_sw),
        .an(an),
        .seg(seg)
    );

    assign sw = w_sw;
    assign led_in2 = w_sw;

endmodule
