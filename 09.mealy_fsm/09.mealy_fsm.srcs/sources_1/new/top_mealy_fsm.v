`timescale 1ns / 1ps


module top_mealy_fsm(
    input clk, reset, btnU, btnD,
    output led
    );

    wire clean_btnU, clean_btnD;
    wire w_led;

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

    bealy_fsm u_bealy_fsm(
        .clk(clk), 
        .reset(reset), 
        .x(btn_data),
        .valid(valid),
        .y(w_led)
    );

    reg r_led;
    always @(posedge clk or posedge reset) begin
        if (reset)
            r_led <= 1'b0;
        else if (valid) begin         // Up이든 Down이든 어떤 버튼이든 눌렸을 때
            if (w_led)                // 그 입력으로 인해 101 패턴이 완성되었다면
                r_led <= 1'b1;        // LED 켬
            else                      // 버튼을 눌렀지만 101 패턴 완성이 아니라면
                r_led <= 1'b0;        // LED 끔
        end
    end


    assign led = r_led;

endmodule

