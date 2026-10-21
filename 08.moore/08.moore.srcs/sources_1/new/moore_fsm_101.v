`timescale 1ns / 1ps


//moor fsm: 입력 x에서 101 시퀀스(중첩 허용)
// 출력 y(S3상태로 왔을때 y가 1로 된다)
module moore_fsm_101(
    input clk, reset, valid,
    input [1:0] x,
    output y
    );

    //상태 인코딩( S0:대기 S1:1검출 S2:10검출 S3:101검출)
    localparam [1:0] S0 = 2'b00, //idle
                     S1 = 2'b01, //1검출
                     S2 = 2'b10, //10검출
                     S3 = 2'b11; //101검출

    reg [1:0] curr_state, next_state;

    //1. curr_state 상태 register (순차회로)
    always @(posedge clk, posedge reset) begin
        if (reset) curr_state <= S0;
        else curr_state <= next_state;
    end

    //2. 다음 상태 로직 (조합회로)
    always @(*) begin
        next_state = curr_state; // 버튼이 안 눌리면 현재 상태 유지

        if (valid) begin
            case (curr_state)
                S0: begin
                    if (x[1]) next_state = S1;      // '1' 입력
                    else if (x[0]) next_state = S0; // '0' 입력시 대기
                end
                S1: begin
                    if (x[0]) next_state = S2;      // '0' 입력 -> '10'
                    else if (x[1]) next_state = S1; // '1' 반복 입력 -> '1' 상태 유지
                end
                S2: begin
                    if (x[1]) next_state = S3;      // '1' 입력 -> '101' 완성
                    else if (x[0]) next_state = S0; // '0' 잘못된 입력 -> 초기화
                end
                S3: begin // 101 검출 완료 상태 (중첩 허용 로직)
                    // 현재 시퀀스의 마지막이 '1'인 상태입니다.
                    if (x[0]) next_state = S2;      // 이어서 '0'이 오면 '10'이 되므로 S2로 이동
                    else if (x[1]) next_state = S1; // 이어서 '1'이 오면 새로운 '1'이므로 S1로 이동
                end
                default: next_state = S0; 
            endcase
        end
    end


    //3. 출력로직 : 현재 상태로만 출력 (moore machine)
    assign y = (curr_state == S3);
endmodule
