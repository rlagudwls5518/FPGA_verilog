`timescale 1ns / 1ps

module uart_controller(
    input clk, reset, rx, 
    input [7:0] send_data,

    output [7:0] rx_data,
    output rx_done,
    output tx
    );
    wire w_tick_1Hz;
    wire w_tx_busy, w_tx_start;
    wire [7:0] w_tx_data;


    tick_generator_1hz u_tick_generator_1hz (
        .clk(clk), 
        .reset(reset),
        .tick_1Hz(w_tick_1Hz)
    );

    data_sender u_data_sender(
        .clk(clk), 
        .reset(reset), 
        .start_trigger(w_tick_1Hz),
        .send_data(send_data),
        .tx_busy(w_tx_busy),
        .tx_data(w_tx_data),
        .tx_start(w_tx_start)
    );

    uart_tx #(.BPS(9600)) u_uart_tx(
        .clk(clk), 
        .reset(reset),
        .tx_data(w_tx_data),
        .tx_start(w_tx_start),
        .tx(tx),
        .tx_busy(w_tx_busy)
    );

endmodule
