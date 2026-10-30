`timescale 1ns / 1ps


module top_microwave(
    input clk, reset, s1, s2, key,
    input [3:0] btn,

    output [3:0] an,
    output [7:0] seg,
    output buzzer_out, led, motor_out, servo_out,
    output [1:0] motor_dir
    );

    wire [3:0] w_clean_btn;
    wire w_tick_1ms, w_tick_sec;
    wire w_clean_s1, w_clean_s2, w_clean_key;
    wire w_cw_pulse, w_ccw_pulse;
    wire [13:0] w_data;
    wire w_buzzer_en, w_motor_en, w_door_en;

    debouncer u_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn),
        .clean_btn(w_clean_btn),
        .noisy_s1(s1), 
        .noisy_s2(s2), 
        .noisy_key(key), 
        .clean_s1(w_clean_s1), 
        .clean_s2(w_clean_s2), 
        .clean_key(w_clean_key)
    );

    tick_generator u_tick_generator(
        .clk(clk),
        .reset(reset),
        .tick_1ms(w_tick_1ms), 
        .tick_sec(w_tick_sec)
    );

    rotary u_rotary(
        .clk(clk),
        .reset(reset),
        .s1(w_clean_s1), 
        .s2(w_clean_s2), 
        .cw_pulse(w_cw_pulse), 
        .ccw_pulse(w_ccw_pulse)
    );

    main_controller u_main_controller(
        .clk(clk),
        .reset(reset),       
        .tick_sec(w_tick_sec), 
        .motor_en(w_motor_en), 
        .door_en(w_door_en),
        .clean_btn(w_clean_btn),
        .cw_pulse(w_cw_pulse), 
        .ccw_pulse(w_ccw_pulse), 
        .push_key(w_clean_key),
        .buzzer_en(w_buzzer_en), 
        .data(w_data),
        .led(led)
    );

    fnd_controller u_fnd_controller(
        .clk(clk),
        .reset(reset), 
        .tick_1ms(w_tick_1ms), 
        .in_data(w_data),
        .an(an),
        .seg(seg)
    );

    buzzer u_buzzer(
        .clk(clk),
        .reset(reset), 
        .buzzer_en(w_buzzer_en),
        .door_en(w_door_en),
        .buzzer_out(buzzer_out)
    );

    motor u_motor(
        .clk(clk),
        .reset(reset),
        .motor_en(w_motor_en),
        .motor_out(motor_out),
        .servo_out(servo_out),
        .motor_dir(motor_dir),
        .door_en(w_door_en)       
    );



endmodule
