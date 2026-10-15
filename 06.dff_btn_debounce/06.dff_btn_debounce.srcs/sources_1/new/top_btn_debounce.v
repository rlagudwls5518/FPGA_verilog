`timescale 1ns / 1ps


module top_btn_debounce(
    input clk, reset, btnC,
    output [1:0]led
    );

    wire w_clean_btn;
    wire w_tim_1ms;

    u_btn_debounce u_u_btn_debounce(
        .clk(clk),
        .reset(reset),
        .btn(btnC),
        .clean_btn(w_clean_btn)
    );
    
    led_toggle u_led_toggle(
        .clean_btn(w_clean_btn),
        .led(led[0])
    );

    tick_generator u_tick_generator(
        .reset(reset),
        .clk(clk),
        .tim_1ms(w_tim_1ms)
    );

    led_onoff_500ms u_led_onoff_500ms(
        .tim_1ms(w_tim_1ms),
        .led(led[1])
    );


endmodule
