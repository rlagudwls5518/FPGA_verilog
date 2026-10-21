`timescale 1ns / 1ps


module bealy_fsm(
    input clk, reset, valid,
    input [1:0]x,
    output reg y
    );
    // 인코딩 (S3는 불필요: 상태 3)
    localparam [1:0] S0 = 2'b00, // 대기
                     S1 = 2'b01, // 1검출
                     S2 = 2'b10; // 10검출
    
    reg [1:0] r_curr_state, r_next_state;

    //(1) current_state 레지스터(moore와 동일 하다)
    always @(posedge clk, posedge reset) begin
        if(reset) r_curr_state <= S0;
        else r_curr_state <= r_next_state;
    end

    // 2) 다음 상태 + 출력 (입력을 참조해서)
    always @(*) begin
        r_next_state = r_curr_state;
        y = 1'b0;
        if (valid) begin
           case (r_curr_state)
                S0: if (x[1]) r_next_state = S1;
                S1: if (x[0]) r_next_state = S2;
                S2: if (x[1]) begin
                    y= 1'b1;
                    r_next_state = S1;
                end else r_next_state = S0;
                default: r_next_state = S0;
            endcase 
        end
    end
endmodule
