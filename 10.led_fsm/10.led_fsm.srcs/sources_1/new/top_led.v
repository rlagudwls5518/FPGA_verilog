`timescale 1ns / 1ps

module top_led(
    input clk, reset, btnC,
    output [4:0] led
    );

    reg btn_prev;
    reg [4:0] store_led;
    wire w_clean_btn;
    wire [4:0] w_led;

    btn_debounce u_btn_debounce(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btnC),
        .clean_btn(w_clean_btn)
    );

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            btn_prev <= 0;
        end else begin
            btn_prev <= w_clean_btn;     
        end
    end
    wire tick_btn = w_clean_btn & ~btn_prev;

    led_mealy u_led_mealy(
        .clk(clk),
        .reset(reset),
        .clean_btn(tick_btn),
        .led(w_led)
    );

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            store_led <= 0;
        end else begin
            store_led <= w_led;     
        end
    end

    assign led = store_led;


endmodule
