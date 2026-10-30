`timescale 1ns / 1ps


module top_uart(
    input RsRx, clk, reset, 
    input [7:0] sw,
    input [2:0] btn,

    output RsTx,
    output [3:0]an,
    output [7:0]seg,
    output [15:0]led,
    output uart_tx,  // JB1 오실로스코프 측정용 단자 
    output uart_rx   // JB2   
    );

    wire [2:0] w_clean_btn;
    wire [7:0] w_rx_data;
    wire w_rx_done;
    wire [13:0] w_seg_data;
    reg [7:0] r_num_data;
    wire w_num_tick;

    debouncer u_debouncer (
        .clk(clk), 
        .reset(reset), 
        .noisy_btn(btn),
        .clean_btn(w_clean_btn)
    );

    tick_generator_1hz u_num_1hz (
        .clk(clk), 
        .reset(reset),
        .tick_1Hz(w_num_tick)
    );

    // always @(posedge clk, posedge reset) begin
    //     if(reset)begin
    //        r_num_data <= "0"; 
    //     end else begin
    //         if(w_num_tick)begin
    //             if (r_num_data >= "9") begin
    //                 r_num_data <= "0";
    //             end else r_num_data <= r_num_data + 1;
    //         end
    //     end
    // end

    uart_controller u_uart_controller(
        .clk(clk), 
        .reset(reset),        
        .rx(RsRx), 
        .send_data(r_num_data),
        .rx_data(w_rx_data),
        .rx_done(w_rx_done),
        .tx(RsTx)
    );


    // control_tower u_control_tower(
    //     .clk(clk), 
    //     .reset(reset), 
    //     .rx_done(w_rx_done),
    //     .clean_btn(w_clean_btn),
    //     .rx_data(w_rx_data),
    //     .sw(sw),
    //     .led(led),
    //     .seg_data(w_seg_data)
    // );

    assign uart_rx = RsRx;
    assign uart_tx = RsTx;
    
endmodule
