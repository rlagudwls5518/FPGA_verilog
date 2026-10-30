`timescale 1ns / 1ps

module motor(
    input clk, reset, motor_en, door_en,
    
    output motor_out, servo_out,
    output [1:0] motor_dir
    );

    // =========================================================
    // 1. DC 모터 (턴테이블): 10kHz, 50% Duty 고정 속도
    // =========================================================
    parameter DC_PERIOD = 14'd10_000; // 100MHz / 10kHz = 10,000
    parameter DC_DUTY   = 14'd10_000;  // 100% 듀티

    reg [13:0] dc_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dc_counter <= 14'd0;
        end else if (motor_en) begin
            if (dc_counter >= DC_PERIOD - 1) begin
                dc_counter <= 14'd0;
            end else begin
                dc_counter <= dc_counter + 1'b1;
            end
        end else begin
            dc_counter <= 14'd0;
        end
    end

    // motor_en이 1일 때만 PWM 출력
    assign motor_out = motor_en ? (dc_counter < DC_DUTY) : 1'b0;
    // L298N/드라이버 방향 신호 (1이면 정회전, 0이면 정지)
    assign motor_dir = motor_en ? 2'b10 : 2'b00;


// =========================================================
    // 2. 서보 모터 (SG90 도어 제어): 동작 시에만 PWM 출력, 평상시 0
    // =========================================================
    parameter SERVO_PERIOD = 21'd2_000_000; // 20ms
    parameter PULSE_0_DEG  = 21'd100_000;   // 1.0ms (0도: 문 닫힘)
    parameter PULSE_90_DEG = 21'd150_000;   // 1.5ms (90도: 문 열림)
    
    // [추가됨] 모터가 물리적으로 움직이는 데 필요한 시간 (예: 0.5초 = 50,000,000 클럭)
    parameter MOVE_TIME    = 32'd50_000_000; 

    reg [20:0] servo_counter;
    reg [31:0] move_counter;
    reg r_prev_door_en;

    // 도어 신호 상태 변화 감지
    wire w_door_changed = (door_en != r_prev_door_en);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            servo_counter  <= 21'd0;
            move_counter   <= 32'd0;
            r_prev_door_en <= 1'b0;
        end else begin
            // 1. 서보 PWM 주기 카운터 (계속 돎)
            if (servo_counter >= SERVO_PERIOD - 1) begin
                servo_counter <= 21'd0;
            end else begin
                servo_counter <= servo_counter + 1'b1;
            end

            // 2. 문 열림/닫힘 변화 감지 및 동작 타이머 구동
            r_prev_door_en <= door_en;

            if (w_door_changed) begin
                // 상태가 변하면 0.5초 타이머 장전
                move_counter <= MOVE_TIME; 
            end else if (move_counter > 0) begin
                // 타이머가 남아있는 동안 카운트다운
                move_counter <= move_counter - 1'b1; 
            end
        end
    end

    wire [20:0] target_pulse = door_en ? PULSE_90_DEG : PULSE_0_DEG;

    // 타이머가 돌아가는 동작 중에만 파형 출력, 끝나면 0 출력
    assign servo_out = (move_counter > 0) ? (servo_counter < target_pulse) : 1'b0;

endmodule