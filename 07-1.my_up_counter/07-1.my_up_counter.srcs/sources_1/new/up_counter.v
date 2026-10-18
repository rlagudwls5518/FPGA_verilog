`timescale 1ns / 1ps


module up_counter #(
    parameter CNT_500MS = 49_999_999
)
(
    input clk, reset,
    input [1:0]clean_btn,
    output [15:0]led 
    );

    reg [25:0] r_time_counter; // 50,000,000 주기 500ms
    reg [15:0] r_up_counter;
    reg btn0_prev;
    reg btn1_prev;
    reg run_flag;

    wire btn0 = clean_btn[0] & ~btn0_prev; // 버튼 U
    wire btn1 = clean_btn[1] & ~btn1_prev; // 버튼 D

    always @(posedge clk, posedge reset) begin // 50ms 타이머
        if(reset) begin
            r_time_counter <= 26'b0;
            r_up_counter <= 16'b0;
        end else begin
            if (run_flag) begin
                if (r_time_counter == CNT_500MS) begin
                    r_time_counter <= 26'd0;
                    r_up_counter  <= r_up_counter + 1'b1;
                end else begin
                    r_time_counter <= r_time_counter + 1'b1;
                end
            end else if(btn1 & !run_flag) begin
                r_up_counter <= 16'b0;
                r_time_counter <= 26'b0;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn0_prev      <= 1'b0;
            btn1_prev      <= 1'b0;
            run_flag       <= 1'b0;
        end else begin
            btn0_prev <= clean_btn[0];
            btn1_prev <= clean_btn[1];

            if (btn0) begin
                run_flag <= ~run_flag;
            end
        end
    end

    assign led = r_up_counter;


endmodule
