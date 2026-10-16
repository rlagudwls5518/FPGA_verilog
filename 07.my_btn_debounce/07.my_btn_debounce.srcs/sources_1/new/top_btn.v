`timescale 1ns / 1ps

module top_btn(
    input clk, reset, btnU, btnD, sel,
    output clean_btn,
    output [1:0] led
    );

    wire w_clk_1ms, w_sel_btn, w_clean_btn, w_led_1;
    reg  r_led_0, led_enanle;
    reg [8:0] r500_count = 0;

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
        .clean_btn(w_clean_btn)
    );

    led_toggle u_led_toggle(
        .btn(w_clean_btn),
        .reset(reset),
        .led(w_led_1)
    );

    always @(posedge w_clean_btn, posedge reset) begin
        if(reset)begin
            led_enanle <= 1'b0;
        end else begin
            led_enanle <= ~led_enanle;
        end
    end

    always @(posedge w_clk_1ms, posedge reset) begin
        if(reset)begin
            r_led_0 <= 0;
            r500_count <= 0;
        end else begin
            if(led_enanle)begin
               if(r500_count == 499)begin
                    r_led_0 <= ~r_led_0;
                    r500_count <= 0;
                end else begin
                    r500_count <= r500_count + 1;
                end 
            end else begin
                r500_count <= 0;
                r_led_0 <= 0;
            end
        end
    end

    assign clean_btn = w_clean_btn;
    assign led[0]    = r_led_0;
    assign led[1]    = w_led_1;

endmodule
