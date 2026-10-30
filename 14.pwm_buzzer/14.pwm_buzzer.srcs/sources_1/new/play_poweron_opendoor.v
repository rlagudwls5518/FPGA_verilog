`timescale 1ns / 1ps


module play_poweron_opendoor(
    input clk, reset,
    input [6:0] btn,

    output buzzer
    );

    reg [1:0] r_buzzer_frq;
    localparam ms_70 = 7_000_000;

    //openbuzzer
    reg [23:0] count_70ms_1; 
    reg [2:0] next_melody;
    reg [21:0] r_clk_count;
    localparam DO = 22'd191_112;
    localparam MI = 22'd151_685;
    localparam SOL = 22'd127_551;
    localparam DDO = 22'd90_192;


    //power On Buzzer 구현하기
    reg [2:0] count_step;
    reg [23:0] count_70ms_2;
    reg [15:0] r_khz_count;
    localparam duty_1khz = 16'd50_000;
    localparam duty_2khz = 16'd25_000;
    localparam duty_3khz = 16'd16_667;
    localparam duty_4khz = 16'd12_500;



    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_khz_count <= 0;
            r_clk_count <= 0;
            count_70ms_1 <= 0;
            count_70ms_2 <= 0;
            count_step <= 0;
            r_buzzer_frq[0] <= 1'b0;
        end else begin

            if (!btn[1]) begin
                r_khz_count <= 0;
                count_70ms_1 <=0;
                count_step <= 0;
                r_buzzer_frq[0] <= 1'b0;
            end else if (count_70ms_1 >= ms_70 - 1) begin
                count_70ms_1 <= 23'd0;
                count_step <= count_step + 1;
            end else begin
                count_70ms_1 <= count_70ms_1 + 1;
                case (count_step)
                   2'b00 : begin
                        if (r_khz_count >= duty_1khz - 1) begin
                            r_khz_count <=0;
                            r_buzzer_frq[0] <= ~r_buzzer_frq[0];
                        end else r_khz_count <= r_khz_count + 1;
                   end
                   2'b01 : begin
                        if (r_khz_count >= duty_2khz - 1) begin
                            r_khz_count <=0;
                            r_buzzer_frq[0] <= ~r_buzzer_frq[0];
                        end else r_khz_count <= r_khz_count + 1;
                   end
                   2'b10 : begin
                        if (r_khz_count >= duty_3khz - 1) begin
                            r_khz_count <=0;
                            r_buzzer_frq[0] <= ~r_buzzer_frq[0];
                        end else r_khz_count <= r_khz_count + 1;
                   end
                   2'b11 : begin
                        if (r_khz_count >= duty_4khz - 1) begin
                            r_khz_count <=0;
                            r_buzzer_frq[0] <= ~r_buzzer_frq[0];
                        end else r_khz_count <= r_khz_count + 1;
                   end 
                    default: begin
                       r_buzzer_frq[0] <= 0; 
                       count_70ms_1 <=0;
                    end
                endcase
            end

            if (!btn[3]) begin
                count_70ms_2 <=0;
                r_clk_count <= 0;
                r_buzzer_frq[1] <= 1'b0;
                next_melody <=0;
            end else if (count_70ms_2 >= ms_70 - 1) begin
                count_70ms_2 <= 23'd0;
                next_melody <= next_melody + 1;
            end else begin
                count_70ms_2 <= count_70ms_2 + 1;
                case (next_melody)
                    2'b00 :begin
                        if (r_clk_count >= DO - 1) begin
                            r_clk_count <=0;
                            r_buzzer_frq[1] <= ~r_buzzer_frq[1];
                        end else r_clk_count <= r_clk_count + 1;
                    end
                    2'b01 :begin
                        if (r_clk_count >= MI - 1) begin
                            r_clk_count <=0;
                            r_buzzer_frq[1] <= ~r_buzzer_frq[1];
                        end else r_clk_count <= r_clk_count + 1;
                    end
                    2'b10 :begin
                        if (r_clk_count >= SOL - 1) begin
                            r_clk_count <=0;
                            r_buzzer_frq[1] <= ~r_buzzer_frq[1];
                        end else r_clk_count <= r_clk_count + 1;
                    end
                    2'b11 :begin
                        if (r_clk_count >= DDO - 1) begin
                            r_clk_count <=0;
                            r_buzzer_frq[1] <= ~r_buzzer_frq[1];
                        end else r_clk_count <= r_clk_count + 1;
                    end 
                    default: begin
                        r_buzzer_frq[1] <=0;
                        count_70ms_2 <= 0;
                    end 
               endcase
            end
        end
    end

    assign  buzzer =  |r_buzzer_frq;
    //or 축약연산자
endmodule

