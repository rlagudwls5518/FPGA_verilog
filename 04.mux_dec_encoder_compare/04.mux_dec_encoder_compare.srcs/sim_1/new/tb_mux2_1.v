`timescale 1ns / 1ps

module tb_mux2_1();
    //1. 입력신호는 reg  출력신호는 wire
    reg a, b, sel;
    wire out;

    //2. 검증할 모듈을 인스턴스 화
    mux2_1 u_mux2_1(
        .a(a), 
        .b(b), 
        .sel(sel), 
        .out(out)
    );
    
    //3. test 시나리오 작성
    initial begin
        //초기값 설정
        a = 0; b = 0; sel = 0;

        // 결과를 화면에 출력함
        $monitor("Time=%0t | sel=%b | a=%b | b=%b | out=%b", $time, sel, a, b, out);

        //sel이 0일때 b가 출력되야함
        #10; sel=0; a=1; b=0; //out은 b가 0이 되어야 한다.
        #10; sel=0; a=0; b=1; //out은 b가 1이 되어야 한다.

        //sel이 1일때 b가 출력되야함
        #10; sel=1; a=1; b=0; //out은 a가 1이 되어야 한다.
        #10; sel=1; a=0; b=1; //out은 a가 0이 되어야 한다.

        //추가적인 모든 조합을 출력
        #10; sel=0; a=1; b=1; //out은 b가 1이 되어야 한다.
        #10; sel=1; a=1; b=1; //out은 a가 1이 되어야 한다.
        #10 $finish; // 시뮬레이션종료
    end
endmodule
