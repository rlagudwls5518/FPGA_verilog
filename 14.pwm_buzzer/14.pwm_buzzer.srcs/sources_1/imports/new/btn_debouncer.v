`timescale 1ns / 1ps

module debouncer (
    input      clk,
    input      reset,
    input  [6:0] noisy_btn,  // raw noisy button input
    output [6:0] clean_btn
);

    btn_debouncer u_btnU_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(noisy_btn[0]),
        .clean_btn(clean_btn[0])
    );

    btn_debouncer u_btnL_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(noisy_btn[1]),
        .clean_btn(clean_btn[1])
    );

    btn_debouncer u_btnC_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(noisy_btn[2]),
        .clean_btn(clean_btn[2])
    );

    btn_debouncer u_btnR_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(noisy_btn[3]),
        .clean_btn(clean_btn[3])
    );

    btn_debouncer u_btnD_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(noisy_btn[4]),
        .clean_btn(clean_btn[4])
    );

    btn_debouncer u_btn1_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(noisy_btn[5]),
        .clean_btn(clean_btn[5])
    );

    btn_debouncer u_btn2_debouncer(
        .clk(clk),
        .reset(reset),
        .noisy_btn(noisy_btn[6]),
        .clean_btn(clean_btn[6])
    );
    
endmodule





module btn_debouncer #(parameter DEBOUNCE_LIMIT = 20'd999_999) (
    input      clk,
    input      reset,
    input      noisy_btn,  // raw noisy button input
    output reg  clean_btn
);
    reg [19:0] r_count;
    reg r_btn_state=0;

    //2단 D-FF 동화기 : 입력( 비동기 입력버튼 noisy_btn)를 클럭 도메인에 동기화
    reg r_FF1, r_FF2;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_FF1 <=0;
            r_FF2 <=0;
        end else begin
            r_FF1 <=noisy_btn; // r_FF1 : 메타세타빌리티가 생길 수 있는 FF
            r_FF2 <= r_FF1;    // r_FF2 출력은 2주기; 만큼 지연되지만 안정된 신호를 확보할 수있다
        end
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin   // active-high reset
            r_count <= 0;
            r_btn_state <= 0;
            clean_btn <= 0;
        end else if (r_FF2 == r_btn_state) begin  // 버튼 상태가 이전과 동일할 경우 (안정됨)
            r_count <= 0;                         // 비동기 버튼 신호는 
        end else begin
            if (r_count < DEBOUNCE_LIMIT)  // 버튼 상태가 바뀌었지만 아직 안정되지 않은 경우
                r_count <= r_count + 1;
            else begin  // 상태가 충분히 오랫동안 유지됨(10ms)
                r_btn_state <= noisy_btn;
                clean_btn <= noisy_btn;
                r_count <= 0;  // clear하면 다음 변경을 다시 감지할 수 있음
            end
        end
    end
endmodule