`timescale 1ns / 1ps


module u_btn_debounce(
    input clk, reset, btn,
    output clean_btn
    );

    wire w_clk;
    wire w_Q1, w_Q2, w_Q2_bar;

    clock_80Hz u_clock_80Hz(
        .clk(clk),
        .reset(reset),
        .oclk(w_clk)
    );

    D_FF u_D_FF(
        .clk(w_clk), 
        .reset(reset), 
        .D(btn),
        .Q(w_Q1)
    );

    D_FF u2_D_FF(
        .clk(w_clk), 
        .reset(reset), 
        .D(w_Q1),
        .Q(w_Q2_bar)
    );


    assign w_Q2 = ~w_Q2_bar;
    assign clean_btn = w_Q1 & w_Q2_bar;


endmodule
