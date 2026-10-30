`timescale 1ns / 1ps

//sim 속도를 올리기 위해서 버튼 디바운스 제한 10ms인데 5000배 다운시킴
//10ms(10,000us) / 2us -> 5000배 다운
//10ms -> 100hz
//2us -> 500khz
module tb_top_rotary();
    reg reset, clk, s1, s2, key;
    wire [15:0] led;

    top_rotary #(
        .ROTARY_DEBOUNCTIME(40),
        .KEY_DEBOUNC_TIME(200)
    ) u_top_rotary(
        .clk(clk),
        .reset(reset),
        .s1(s1),
        .s2(s2),
        .key(key),
        .led(led)
    );

    //100mhz clk 생성
    always #5 clk = ~clk;

    //일괄적으로 노이즈 신호를 50ns x 3개를 만듬
    task make_noise_btn(input integer sw); // 0: s1,  1: s2
        begin
            repeat(3) begin
                if(sw == 0) s1 = ~s1;
                else if(sw == 1) s2 = ~s2;
                else key = ~key;
                #50; // 채터링 방지 50ns
            end
        end
    endtask

    initial begin
        clk = 0; reset = 1; s1 = 0; s2 = 0; key = 0;
        #100;
        reset = 0;    
        #100;
        //CW  00 --> 10 --> 11 --> 01 --> 00 
        $display("forward test start!!");
        make_noise_btn(0);
        s1 = 1; #3000; // 3us 노이즈 보다 긴 신호 ->3us
        make_noise_btn(1);
        s2 = 1; #3000;
        s1 = 0; #3000;
        s2 = 0; #3000;
        
        //CCW 00 --> 01 --> 11 --> 10 --> 00 
        $display("backward test start!!");
        s2 = 1; #3000;
        make_noise_btn(0);
        s1 = 1; #3000; // 3us 노이즈 보다 긴 신호 ->3us
        s2 = 0; #3000;
        s1 = 0; #3000;

        $display("test finish!!");
    end

    //모니터링 출력
    initial begin
        $monitor("time=%t, r_counter:%h, r_direction:%b, r_led_toggle:%b", $time, led[7:0], led[15:14], led[13]);
    end
endmodule
