`timescale 1ns / 1ps


module play_melody(
    input clk, reset,
    input [6:0] btn,

    output buzzer
    );

    localparam DO = 22'd191_112;  // 50% duty 261.63Hz
    localparam RE = 22'd170_265;  // 레 293.63Hz
    localparam MI = 22'd151_685;  // 미 50% duty
    localparam PA = 22'd174_614;  // 파 50% duty
    localparam SOL = 22'd127_551; // 솔 50% duty
    localparam RA = 22'd113_636;  // 라 50% duty
    localparam SI = 22'd246_941;  // 시 50% duty

    reg [21:0] r_clk_count[6:0];
    reg [6:0] r_buzzer_frq;
    integer i; // signed 32bit /unsigned : reg [31:0]


    //70ms 유지
    reg [23:0] count_70ms;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            for (i = 0; i < 7; i=i+1) begin
                r_clk_count[i] <= 22'd0;
                r_buzzer_frq[i] <= 1'b0;
            end
        end else begin
            if (!btn[0]) begin
                r_clk_count[0] <= 22'd0;
                r_buzzer_frq[0] <= 1'b0;
            end else if (r_clk_count[0] >= DO - 1) begin
                r_clk_count[0] <= 22'd0;
                r_buzzer_frq[0] <= ~r_buzzer_frq[0];
            end else r_clk_count[0] <= r_clk_count[0] + 1;

            if (!btn[1]) begin
                r_clk_count[1] <= 22'd0;
                r_buzzer_frq[1] <= 1'b0;
            end else if (r_clk_count[1] >= RE - 1) begin
                r_clk_count[1] <= 22'd0;
                r_buzzer_frq[1] <= ~r_buzzer_frq[1];
            end else r_clk_count[1] <= r_clk_count[1] + 1;

            if (!btn[2]) begin
                r_clk_count[2] <= 22'd0;
                r_buzzer_frq[2] <= 1'b0;
            end else if (r_clk_count[2] >= MI - 1) begin
                r_clk_count[2] <= 22'd0;
                r_buzzer_frq[2] <= ~r_buzzer_frq[2];
            end else r_clk_count[2] <= r_clk_count[2] + 1;

            if (!btn[3]) begin
                r_clk_count[3] <= 22'd0;
                r_buzzer_frq[3] <= 1'b0;
            end else if (r_clk_count[3] >= PA - 1) begin
                r_clk_count[3] <= 22'd0;
                r_buzzer_frq[3] <= ~r_buzzer_frq[3];
            end else r_clk_count[3] <= r_clk_count[3] + 1;

            if (!btn[4]) begin
                r_clk_count[4] <= 22'd0;
                r_buzzer_frq[4] <= 1'b0;
            end else if (r_clk_count[4] >= SOL - 1) begin
                r_clk_count[4] <= 22'd0;
                r_buzzer_frq[4] <= ~r_buzzer_frq[4];
            end else r_clk_count[4] <= r_clk_count[4] + 1;

            if (!btn[5]) begin
                r_clk_count[5] <= 22'd0;
                r_buzzer_frq[5] <= 1'b0;
            end else if (r_clk_count[5] >= RA - 1) begin
                r_clk_count[5] <= 22'd0;
                r_buzzer_frq[5] <= ~r_buzzer_frq[5];
            end else r_clk_count[5] <= r_clk_count[5] + 1;

            if (!btn[6]) begin
                r_clk_count[6] <= 22'd0;
                r_buzzer_frq[6] <= 1'b0;
            end else if (r_clk_count[6] >= SI - 1) begin
                r_clk_count[6] <= 22'd0;
                r_buzzer_frq[6] <= ~r_buzzer_frq[6];
            end else r_clk_count[6] <= r_clk_count[6] + 1;
        end
    end

    assign  buzzer =  |r_buzzer_frq;
    //or 축약연산자

endmodule
