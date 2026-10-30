`timescale 1ns / 1ps

module main_controller(
    input reset, clk, tick_sec,
    input [3:0] clean_btn,
    input cw_pulse, ccw_pulse, push_key,

    // 조합 회로에서 assign으로 제어할 출력은 reg를 제거하여 wire로 선언
    output buzzer_en, motor_en, led, 
    output reg door_en, // door_en은 토글 상태를 유지해야 하므로 reg 유지
    output [13:0] data
    );

    // ==============================================================
    // 1. FSM 상태(State) 파라미터 정의
    // ==============================================================
    localparam S_IDLE   = 2'b00; // 대기 및 시간 설정
    localparam S_NORMAL = 2'b01; // 일반 동작
    localparam S_DEICE  = 2'b10; // 해동 동작
    localparam S_DONE   = 2'b11; // 완료 (부저 1클럭 트리거 펄스용)

    reg [1:0] r_curr_state, r_next_state;

    // 데이터패스 레지스터 선언
    reg [5:0] temp_sec, temp_min;
    reg [5:0] r_sec_counter, r_min_counter;
    reg time_set_done;

    // ==============================================================
    // 2. 입력 에지 검출 및 도어 토글 (순차 회로)
    // ==============================================================
    reg r_prev_push;
    reg r_prev_btn_start, r_prev_btn_stop, r_prev_btn_deice, r_prev_btn_open_close;
    
    wire w_push_key       = (push_key && !r_prev_push);
    wire w_btn_start      = (clean_btn[0] && !r_prev_btn_start);
    wire w_btn_stop       = (clean_btn[1] && !r_prev_btn_stop);
    wire w_btn_deice      = (clean_btn[2] && !r_prev_btn_deice);
    wire w_btn_open_close = (clean_btn[3] && !r_prev_btn_open_close);

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            r_prev_push           <= 1'b0;
            r_prev_btn_start      <= 1'b0;
            r_prev_btn_stop       <= 1'b0;
            r_prev_btn_deice      <= 1'b0;
            r_prev_btn_open_close <= 1'b0;
            door_en               <= 1'b0;
        end else begin
            r_prev_push           <= push_key;
            r_prev_btn_start      <= clean_btn[0];
            r_prev_btn_stop       <= clean_btn[1];
            r_prev_btn_deice      <= clean_btn[2];
            r_prev_btn_open_close <= clean_btn[3];

            // 동작 상태와 무관하게 도어는 언제든 열고 닫을 수 있음
            if(w_btn_open_close) door_en <= ~door_en;
        end
    end

    // ==============================================================
    // 3. FSM 상태 레지스터 동기화 [Option B 순차 로직]
    // ==============================================================
    always @(posedge clk or posedge reset) begin
        if(reset) r_curr_state <= S_IDLE;
        else      r_curr_state <= r_next_state;
    end

    // ==============================================================
    // 4. FSM 다음 상태 결정 로직 [Option B 조합 로직]
    // ==============================================================
    wire timer_zero = (r_min_counter == 6'd0) && (r_sec_counter == 6'd0);

    always @(*) begin
        r_next_state = r_curr_state; // Default 할당으로 의도치 않은 래치(Latch) 원천 차단

        case(r_curr_state)
            S_IDLE: begin
                if(w_btn_start && time_set_done && !door_en)
                    r_next_state = S_NORMAL;
                else if(w_btn_deice && time_set_done && !door_en)
                    r_next_state = S_DEICE;
            end
            
            S_NORMAL, S_DEICE: begin
                // 강제 정지 버튼 또는 조리 도중 문이 열렸을 때 즉시 정지
                if(w_btn_stop || door_en) 
                    r_next_state = S_IDLE;
                // 조리 시간 종료 시 완료 상태로 천이
                else if(timer_zero)       
                    r_next_state = S_DONE;
            end
            
            S_DONE: begin
                // ★ 핵심: 부저 트리거용 1클럭 상태 후 즉시 대기 상태로 자동 복귀
                r_next_state = S_IDLE;    
            end
            
            default: r_next_state = S_IDLE;
        endcase
    end

    // ==============================================================
    // 5. FSM 출력 제어 [조합 회로 분리]
    // ==============================================================
    // 모터는 일반/해동 동작 상태일 때만 ON
    assign motor_en  = (r_curr_state == S_NORMAL) || (r_curr_state == S_DEICE);
    
    // ★ 부저는 S_DONE 상태에 머무는 단 1클럭(10ns) 동안만 High 출력!
    // 하위 부저 모듈의 에지 검출기(w_start_beep)를 완벽하게 트리거하고 깔끔하게 0으로 복귀함
    assign buzzer_en = (r_curr_state == S_DONE); 

    // ==============================================================
    // 6. 데이터패스: 타이머 카운터 및 엔코더 설정 (순차 회로)
    // ==============================================================
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            temp_sec      <= 6'd0;
            temp_min      <= 6'd0;
            r_sec_counter <= 6'd0;
            r_min_counter <= 6'd0;
            time_set_done <= 1'b0;
        end else begin
            // [A] 대기 상태일 때만 시간 설정 허용
            if(r_curr_state == S_IDLE) begin
                if(cw_pulse) begin
                    time_set_done <= 1'b0;
                    if(temp_sec == 6'd50) begin
                        temp_sec <= 6'd0;
                        temp_min <= temp_min + 1'b1;
                    end else begin
                        temp_sec <= temp_sec + 6'd10;
                    end
                end 
                else if(ccw_pulse) begin
                    time_set_done <= 1'b0;
                    if(temp_sec == 6'd0) begin
                        if(temp_min > 0) begin
                            temp_sec <= 6'd50;
                            temp_min <= temp_min - 1'b1;
                        end
                    end else begin
                        temp_sec <= temp_sec - 6'd10;
                    end
                end

                if(w_push_key) begin
                    if(temp_min > 0 || temp_sec > 0) begin
                        r_min_counter <= temp_min;
                        r_sec_counter <= temp_sec;
                        time_set_done <= 1'b1;
                    end
                end

                if(w_btn_stop) begin
                    temp_sec      <= 6'd0;
                    temp_min      <= 6'd0;
                    r_sec_counter <= 6'd0;
                    r_min_counter <= 6'd0;
                    time_set_done <= 1'b0;
                end
            end 
            // [B] 동작 상태일 때 다운카운트
            else if(r_curr_state == S_NORMAL || r_curr_state == S_DEICE) begin
                if(tick_sec) begin
                    if(r_sec_counter == 6'd0) begin
                        if(r_min_counter > 0) begin
                            r_sec_counter <= 6'd59;
                            r_min_counter <= r_min_counter - 1'b1;
                        end
                    end else begin
                        r_sec_counter <= r_sec_counter - 1'b1;
                    end
                end
            end
        end
    end

    // ==============================================================
    // 7. PWM 카운터 및 LED/FND 출력 (순차 + 조합 명확한 분리)
    // ==============================================================
    reg [7:0] pwm_cnt;
    always @(posedge clk or posedge reset) begin
        if(reset) pwm_cnt <= 8'd0;
        else      pwm_cnt <= pwm_cnt + 1'b1;
    end

    // LED 밝기 제어를 상태에 따라 조합 회로로 할당
    assign led = (r_curr_state == S_NORMAL) ? 1'b1 :
                 (r_curr_state == S_DEICE)  ? (pwm_cnt < 8'd128) : 1'b0;

    wire [5:0] disp_min = motor_en ? r_min_counter : (time_set_done ? r_min_counter : temp_min);
    wire [5:0] disp_sec = motor_en ? r_sec_counter : (time_set_done ? r_sec_counter : temp_sec);
    
    assign data = (disp_min * 14'd100) + disp_sec;

endmodule