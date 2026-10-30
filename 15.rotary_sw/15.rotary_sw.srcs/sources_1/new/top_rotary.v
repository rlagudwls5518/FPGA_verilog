`timescale 1ns / 1ps



module top_rotary(
    input reset, clk, s1, s2, key,
    output [15:0] led
    );

    wire w_clean_s1,  w_clean_s2,  w_clean_key;

    btn_debouncer #(.DEBOUNCE_LIMIT(200_000)) u_s1_debouncer( // 로터리 2ms디바운스 처리
        .clk(clk),
        .reset(reset),
        .noisy_btn(s1),
        .clean_btn(w_clean_s1)
    );

    btn_debouncer #(.DEBOUNCE_LIMIT(200_000)) u_s2_debouncer( // 로터리 2ms디바운스 처리
        .clk(clk),
        .reset(reset),
        .noisy_btn(s2),
        .clean_btn(w_clean_s2)
    );

    debouncer u_key_debouncer( // 10ms 디바운스
        .clk(clk),
        .reset(reset),
        .noisy_btn(key),
        .clean_btn(w_clean_key)
    );

    rotary u_rotary(
        .clk(clk),
        .reset(reset),
        .s1(w_clean_s1),
        .s2(w_clean_s2),
        .key(w_clean_key),
        .led(led)
    );
endmodule
