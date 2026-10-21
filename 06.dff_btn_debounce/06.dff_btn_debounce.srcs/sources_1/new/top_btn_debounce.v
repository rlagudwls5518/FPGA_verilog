`timescale 1ns / 1ps


module top_btn_debounce(
    input clk, reset, btnC,
    output led
    );

    wire w_clean_btn;
    wire w_tim_1ms;

    debouncer u_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btnC),
        .clean_btn(w_clean_btn)
    );

    // u_btn_debounce u_u_btn_debounce(
    //     .clk(clk),
    //     .reset(reset),
    //     .btn(btnC),
    //     .clean_btn(w_clean_btn)
    // );
    
    led_toggle u_led_toggle(
        .reset(reset),
        .clean_btn(w_clean_btn),
        .led(led)
    );


endmodule
