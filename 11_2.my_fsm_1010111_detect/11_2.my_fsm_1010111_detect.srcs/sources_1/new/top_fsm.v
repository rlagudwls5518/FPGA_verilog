`timescale 1ns / 1ps

module top_fsm(
    input clk, reset, btnU, btnD,
    output [15:0] led
    );
    wire w_clean_btnU, w_clean_btnD, btn_press, data;
    wire [15:0] w_led;

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

    btn_sel u_btn_sel(
        .clk(clk),
        .reset(reset),
        .clean_btnU(w_clean_btnU),
        .clean_btnD(w_clean_btnD),
        .btn_press(btn_press),
        .btn_output_data(data)
    );

    mealy_fsm u_mealy_fsm(
        .clk(clk),
        .reset(reset),
        .btn_press(btn_press),
        .x(data),
        .led(w_led)
    );


    assign led = w_led;
endmodule

