`timescale 1ns / 1ps


module top_fsm(
    input clk, reset, btnU, btnD,
    output [15:0] led
    );

    reg btn_prev;
    wire w_clean_btnU, w_clean_btnD;
    wire[15:0] w_led;

    btn_debounce u_btn_debounce_btnU(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btnU),
        .clean_btn(w_clean_btnU)
    );

    btn_debounce u_btn_debounce_btnD(
        .clk(clk),
        .reset(reset),
        .noisy_btn(btnD),
        .clean_btn(w_clean_btnD)
    );    

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            btn_prev <= 0;
        end else begin
            btn_prev <= w_clean_btn;     
        end
    end
    wire btn_press = w_clean_btn & ~btn_prev;


    shift_register u_shift_register(
        .clk(clk),
        .reset(reset),
        .btn_press(btn_press),
        .x(),
        .led(w_led)
    );

    assign led = w_led;

endmodule
