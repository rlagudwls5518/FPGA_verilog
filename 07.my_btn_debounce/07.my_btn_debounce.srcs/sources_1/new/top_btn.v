`timescale 1ns / 1ps

module top_btn(
    input clk, reset, btnU, btnD, sel,
    output clean_btn,
    output [1:0] led
    );

    wire w_clk_1ms, w_sel_btn;

    mux u_mux(
        .btnU(btnU),
        .btnD(btnD),
        .sel_btn(w_sel_btn),
        .sel(sel)
    );

    tick_generator u_tick_generator(
        .clk(clk), 
        .reset(reset),
        .tick(w_clk_1ms)
    );

    btn_debounce u_btn_debounce(
        .clk(w_clk_1ms),
        .btn(w_sel_btn), 
        .reset(reset),
        .clean_btn(clean_btn)
    );

    assign led[0] = clean_btn;

    led_toggle u_led_toggle(
        .btn(clean_btn),
        .reset(reset),
        .led(led[1])
    );


endmodule
