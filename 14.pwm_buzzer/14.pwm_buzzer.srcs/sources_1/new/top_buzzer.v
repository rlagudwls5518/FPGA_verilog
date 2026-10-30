`timescale 1ns / 1ps

module top_buzzer(
    input clk, reset, sw,
    input [6:0] btn,

    output buzzer
    );

    wire [6:0] w_btn;
    wire w_buzzer_melody, w_buzzer_effect;

    debouncer u_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btn),
        .clean_btn(w_btn)
    );


    play_melody u_play_melody(
        .clk(clk),
        .reset(reset),
        .btn(w_btn),
        .buzzer(w_buzzer_melody)
    );

    play_poweron_opendoor u_play_poweron_opendoor(
        .clk(clk),
        .reset(reset),
        .btn(w_btn),
        .buzzer(w_buzzer_effect)
    );    

    assign buzzer = sw ? w_buzzer_effect : w_buzzer_melody;

endmodule
