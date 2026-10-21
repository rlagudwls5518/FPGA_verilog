`timescale 1ns / 1ps

module tb_moore_fsm_101();
    reg clk = 0;
    reg reset = 0;
    reg x = 0;

    wire y;

    reg r_error =1'b0;

    bealy_fsm u_bealy_fsm(
        .clk(clk), 
        .reset(reset), 
        .x(x),
        .y(y)
    );

    always #5 clk = ~clk; // 100mhz clk 생성
    // 상승에지 전에 출력 y가 변하는지를 검사하는 것 (mealy상태)
    //         후에 출력 y가 기대하는 값인지 검사 (1 clock 지연)
    task send_data(input a, input expext_val);
        begin
            x =a; #1; //gate 동작
            if(y !== expext_val)begin //y가 기대값이 아닌 다른 값이면 DUT에 logic errorrk 발생 되었다.
                r_error =1'b1; // erroe detect flag
                $display("FAIL t=%0t x=%b y=%b expect_val=%b", $time, a, y, expext_val);
            end
            @(posedge clk); #1;
        end
    endtask

    //10101101
    initial begin
        #100 reset =1;
        #100 reset = 0;
        send_data(1,0); 
        send_data(0,0); 
        send_data(1,1);  // 101 --> 다음 에지 후에 y=1(S3)
        send_data(0,0); send_data(1,1); // 10101 : 중첩검증
        // 101 검증
        send_data(1,0); send_data(0,0); send_data(1,1); // 1101 : 검증
        if(r_error ==0) $display("PASS mealy_fsm");
        else $display("FAIL mealy_fsm");

        $finish;
    end

endmodule
