`timescale 1ns / 1ps

module top_up_down_counter(
    input clk, reset,
    input [2:0] btn,

    output [3:0] an,
    output [7:0] seg
    );

    wire [2:0] w_clean_btn;
    wire [13:0] w_seg_data;
    wire w_tick_1ms, w_tick_10ms, w_tick_100ms, w_tick_sec, w_circle_mode_en;
    wire w_dp_clock_mode_en;

    debouncer u_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn),
        .clean_btn(w_clean_btn)
    );

    main_controller u_main_counter(
        .clk(clk),
        .reset(reset),
        .tick_sec(w_tick_sec),
        .tick_10ms(w_tick_10ms),
        .btn(w_clean_btn),
        .seg_data(w_seg_data),
        .circle_mode_en(w_circle_mode_en),
        .dp_clock_mode_en(w_dp_clock_mode_en)
    );

    tick_generator u_tick_generator(
        .clk(clk),
        .reset(reset),
        .tick_1ms(w_tick_1ms),
        .tick_10ms(w_tick_10ms),
        .tick_100ms(w_tick_100ms),
        .tick_sec(w_tick_sec)
    );

    fnd_controller u_fnd_controller(
        .clk(clk),
        .reset(reset),
        .circle_mode_en(w_circle_mode_en),
        .dp_clock_mode_en(w_dp_clock_mode_en),
        .tick_1ms(w_tick_1ms),
        .tick_100ms(w_tick_100ms),
        .in_data(w_seg_data),
        .an(an),
        .seg(seg)
    );
endmodule