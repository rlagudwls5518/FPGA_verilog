`timescale 1ns / 1ps


module top_moore_fsm(
    input clk, reset, btnU, btnD,
    output led
    );

    wire clean_btnU, clean_btnD;
    wire w_led, result_led;

    debouncer u_debouncer_u(
        .clk       (clk),
        .reset     (reset),
        .noisy_btn (btnU),
        .clean_btn (clean_btnU)
    );

    
    debouncer u_debouncer_d(
        .clk       (clk),
        .reset     (reset),
        .noisy_btn (btnD),
        .clean_btn (clean_btnD)
    );

    wire [1:0] r_clean_btn = {clean_btnU, clean_btnD};

    reg [1:0] btn_prev;
    always @(posedge clk or posedge reset) begin
        if (reset)
            btn_prev <= 2'b00;
        else
            btn_prev <= r_clean_btn;
    end

    wire [1:0] btn_data = r_clean_btn & ~btn_prev;
    wire valid = btn_data[0] |  btn_data[1]; // 눌른건지 아닌지


    moore_fsm_101 u_moore_fsm_101(
        .clk(clk), 
        .reset(reset), 
        .x(btn_data),
        .valid(valid),
        .y(w_led)
    );

    led_toggle u_led_togle(
        .reset(reset),
        .clk(clk), 
        .w_led(w_led),
        .valid(valid),
        .result_led(result_led)
    );

    assign led = result_led;

endmodule
