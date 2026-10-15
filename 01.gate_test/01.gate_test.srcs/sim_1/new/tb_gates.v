`timescale 1ns / 1ps

module tb_gates();

    reg [1:0]i_b; // i_a 변수는 1bit짜리 저장 메모리
    wire [5:0] o_led;
    
    //port 지정 : name port mapping 방식
    gates u_gates( // u_gates 라는 이름으로 인스턴스를 생성한다
        .a(i_b[0]),
        .b(i_b[1]), 
        .led(o_led)
    );
    initial begin
        #00 i_b[0] = 1'b0; i_b[1] = 1'b0;
        #20 i_b[0] = 1'b0; i_b[1] = 1'b1;
        #20 i_b[0] = 1'b1; i_b[1] = 1'b0;
        #20 i_b[0] = 1'b1; i_b[1] = 1'b1;
        #20 $stop;
    end

endmodule
