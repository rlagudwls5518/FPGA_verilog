`timescale 1ns / 1ps

module tb_top_microwave();

    reg clk;
    reg reset;
    reg s1, s2, key;
    reg [3:0] btn;

    wire [3:0] an;
    wire [7:0] seg;
    wire buzzer_out, led, motor_out, servo_out;
    wire [1:0] motor_dir;

    top_microwave uut (
        .clk(clk), .reset(reset), .s1(s1), .s2(s2), .key(key), .btn(btn),
        .an(an), .seg(seg), .buzzer_out(buzzer_out), .led(led),
        .motor_out(motor_out), .servo_out(servo_out), .motor_dir(motor_dir)
    );

    // 클럭 생성 (100MHz, 주기 10ns)
    always #5 clk = ~clk;

    // =================================================================
    // [시뮬레이션 고속화] defparam을 이용한 카운터 덮어쓰기
    // =================================================================
    
    // 1. 디바운서: 10ms / 2ms 대기 시간을 1us 수준(100클럭)으로 대폭 축소
    defparam uut.u_debouncer.u_btn0_debouncer.DEBOUNCE_LIMIT = 100;
    defparam uut.u_debouncer.u_btn1_debouncer.DEBOUNCE_LIMIT = 100;
    defparam uut.u_debouncer.u_btn2_debouncer.DEBOUNCE_LIMIT = 100;
    defparam uut.u_debouncer.u_btn3_debouncer.DEBOUNCE_LIMIT = 100;
    defparam uut.u_debouncer.u_s1_debouncer.DEBOUNCE_LIMIT   = 100;
    defparam uut.u_debouncer.u_s2_debouncer.DEBOUNCE_LIMIT   = 100;
    defparam uut.u_debouncer.u_key_debouncer.DEBOUNCE_LIMIT  = 100;

    // 2. 1ms 틱 제너레이터: 100,000클럭을 100클럭으로 축소 
    // -> 타이머(1초)가 시뮬레이션 상에서 1000배 빠르게 카운트다운 됨
    defparam uut.u_tick_generator.u_tic_generator_1ms.TICK_1MS_COUNT = 100;

    // 서보 모터 시뮬레이션 고속화 (테스트 벤치에 적용)
    defparam uut.u_motor.SERVO_PERIOD = 2_000; // 20us 주기
    defparam uut.u_motor.PULSE_0_DEG  = 100;   // 1us 펄스
    defparam uut.u_motor.PULSE_90_DEG = 150;   // 1.5us 펄스
    
    // [핵심] 동작 타이머를 시뮬레이션용으로 축소 (예: 100us)
    defparam uut.u_motor.MOVE_TIME    = 10000;

    // =================================================================

    // 버튼 누름 Task (시뮬레이션용 2us 유지)
    task press_btn(input integer btn_idx);
        begin
            btn[btn_idx] = 1;
            #2_000; 
            btn[btn_idx] = 0;
            #2_000; 
        end
    endtask

    // 엔코더 스위치(Key) 누름 Task
    task press_key();
        begin
            key = 1;
            #2_000; 
            key = 0;
            #2_000;
        end
    endtask

    // 로터리 엔코더 CW(시계방향) 회전 Task (시간 증가)
    task rotate_cw();
        begin
            s1 = 0; #2000;
            s2 = 0; #2000;
            s1 = 1; #2000;
            s2 = 1; #2000;
        end
    endtask

    initial begin
        // 초기화
        clk = 0; reset = 1; s1 = 1; s2 = 1; key = 0; btn = 4'b0000;
        #100;
        reset = 0;
        #1_000; // 1us 대기

        // 1. 도어 동작 테스트 (btn[3])
        press_btn(3); // 문 열림
        #50_000;      // 50us 대기 (도어 오픈 유지 상태 확인)
        press_btn(3); // 문 닫힘
        #10_000;

        // 2. 시간 설정 (로터리 CW 3칸 = 30초 설정)
        rotate_cw();
        rotate_cw();
        rotate_cw();
        #1_000;

        // 3. 설정 시간 확정 (엔코더 스위치 클릭)
        press_key();
        #1_000;

        // 4. 일반 모드 시작 (btn[0])
        press_btn(0);
        
        // 조리 진행 (타이머 고속화로 인해 짧은 대기로도 FND 카운트다운 확인 가능)
        #200_000; 

        // 5. 조리 중 취소/정지 (btn[1])
        press_btn(1);
        #10_000;

        // 6. 해동 모드 테스트 (시간 재설정 후 btn[2] 시작)
        rotate_cw();  // 10초 설정
        press_key();  // 시간 확정
        press_btn(2); // 해동 모드 시작
        
        #200_000; // 동작 유지
        
        $finish;
    end

endmodule