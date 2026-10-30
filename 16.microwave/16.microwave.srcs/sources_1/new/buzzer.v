`timescale 1ns / 1ps

module buzzer(
    input clk, reset, buzzer_en, door_en,
    output buzzer_out
    );

    parameter ms_70 = 7_000_000;

    // =========================================================
    // 1. 타이머 종료음 (삐-삐-삐-삐 주파수 스위핑)
    // =========================================================
    reg [23:0] count_70ms_1; 
    reg [2:0]  count_step;       // 0, 1, 2, 3: 연주, 4: 정지 상태
    reg [15:0] r_khz_count;
    reg        r_beep_tone;

    parameter duty_1khz = 16'd50_000;
    parameter duty_2khz = 16'd25_000;
    parameter duty_3khz = 16'd16_667;
    parameter duty_4khz = 16'd12_500;

    // buzzer_en 시작 엣지 검출 (신호가 들어올 때 1회 재생 시작)
    reg r_prev_buzzer_en;
    wire w_start_beep = (buzzer_en && !r_prev_buzzer_en);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_prev_buzzer_en <= 1'b0;
            count_70ms_1     <= 24'd0;
            count_step       <= 3'd4; // 4는 정지(IDLE) 상태
            r_khz_count      <= 16'd0;
            r_beep_tone      <= 1'b0;
        end else begin
            r_prev_buzzer_en <= buzzer_en;

            // 시작 신호가 들어오면 0단계부터 재생 트리거
            if (w_start_beep) begin
                count_step   <= 3'd0;
                count_70ms_1 <= 24'd0;
                r_khz_count  <= 16'd0;
                r_beep_tone  <= 1'b0;
            end 
            // 연주 중 (0 ~ 3단계)
            else if (count_step < 3'd4) begin
                if (count_70ms_1 >= ms_70 - 1) begin
                    count_70ms_1 <= 24'd0;
                    count_step   <= count_step + 1'b1; // 4가 되면 다음 클럭부터 정지
                end else begin
                    count_70ms_1 <= count_70ms_1 + 1'b1;
                end

                // 음계 주파수 토글
                case (count_step)
                    3'd0: begin
                        if (r_khz_count >= duty_1khz - 1) begin
                            r_khz_count <= 16'd0;
                            r_beep_tone <= ~r_beep_tone;
                        end else r_khz_count <= r_khz_count + 1'b1;
                    end
                    3'd1: begin
                        if (r_khz_count >= duty_2khz - 1) begin
                            r_khz_count <= 16'd0;
                            r_beep_tone <= ~r_beep_tone;
                        end else r_khz_count <= r_khz_count + 1'b1;
                    end
                    3'd2: begin
                        if (r_khz_count >= duty_3khz - 1) begin
                            r_khz_count <= 16'd0;
                            r_beep_tone <= ~r_beep_tone;
                        end else r_khz_count <= r_khz_count + 1'b1;
                    end
                    3'd3: begin
                        if (r_khz_count >= duty_4khz - 1) begin
                            r_khz_count <= 16'd0;
                            r_beep_tone <= ~r_beep_tone;
                        end else r_khz_count <= r_khz_count + 1'b1;
                    end
                    default: r_beep_tone <= 1'b0;
                endcase
            end else begin
                r_beep_tone <= 1'b0; // 연주 종료 후 소등
            end
        end
    end

    // =========================================================
    // 2. 도어 멜로디 (도 - 미 - 솔 - 높은도)
    // =========================================================
    reg [23:0] count_70ms_2;
    reg [2:0]  next_melody;     // 0, 1, 2, 3: 연주, 4: 정지 상태
    reg [21:0] r_clk_count;
    reg        r_door_tone;

    parameter DO  = 22'd191_112;
    parameter MI  = 22'd151_685;
    parameter SOL = 22'd127_551;
    parameter DDO = 22'd95_556; // 100MHz 기준 높은 도 반주기 (~523Hz x 2 = ~1046Hz 토글 주기)

    reg r_prev_door_en;
    // wire w_start_door = (door_en && !r_prev_door_en);
    wire w_start_door = (door_en != r_prev_door_en);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_prev_door_en <= 1'b0;
            count_70ms_2   <= 24'd0;
            next_melody    <= 3'd4;
            r_clk_count    <= 22'd0;
            r_door_tone    <= 1'b0;
        end else begin
            r_prev_door_en <= door_en;

            if (w_start_door) begin
                next_melody  <= 3'd0;
                count_70ms_2 <= 24'd0;
                r_clk_count  <= 22'd0;
                r_door_tone  <= 1'b0;
            end 
            else if (next_melody < 3'd4) begin
                if (count_70ms_2 >= ms_70 - 1) begin
                    count_70ms_2 <= 24'd0;
                    next_melody  <= next_melody + 1'b1;
                end else begin
                    count_70ms_2 <= count_70ms_2 + 1'b1;
                end

                case (next_melody)
                    3'd0: begin
                        if (r_clk_count >= DO - 1) begin
                            r_clk_count <= 22'd0;
                            r_door_tone <= ~r_door_tone;
                        end else r_clk_count <= r_clk_count + 1'b1;
                    end
                    3'd1: begin
                        if (r_clk_count >= MI - 1) begin
                            r_clk_count <= 22'd0;
                            r_door_tone <= ~r_door_tone;
                        end else r_clk_count <= r_clk_count + 1'b1;
                    end
                    3'd2: begin
                        if (r_clk_count >= SOL - 1) begin
                            r_clk_count <= 22'd0;
                            r_door_tone <= ~r_door_tone;
                        end else r_clk_count <= r_clk_count + 1'b1;
                    end
                    3'd3: begin
                        if (r_clk_count >= DDO - 1) begin
                            r_clk_count <= 22'd0;
                            r_door_tone <= ~r_door_tone;
                        end else r_clk_count <= r_clk_count + 1'b1;
                    end
                    default: r_door_tone <= 1'b0;
                endcase
            end else begin
                r_door_tone <= 1'b0;
            end
        end
    end

    // 두 소리 중 하나라도 나면 출력
    assign buzzer_out = r_beep_tone | r_door_tone;

endmodule