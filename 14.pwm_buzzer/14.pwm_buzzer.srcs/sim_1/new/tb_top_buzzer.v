`timescale 1ns / 1ps


module tb_top_buzzer();

    reg clk;
    reg reset;
    reg sw;
    reg [6:0] btn;
    wire buzzer;

    top_buzzer u_top_buzzer(
        .clk(clk),
        .reset(reset),
        .sw(sw),
        .btn(btn),
        .buzzer(buzzer)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        sw = 1'b0;        
        btn = 7'b000_0000;
        #100;
        
        reset = 1'b0;  
        #100;

        // ==========================================
        // 2. 도레미 멜로디 모드 테스트 (sw = 0)
        // ==========================================
        sw = 1'b0;
        
        // '도(btn[0])' 누름
        btn = 7'b000_0001;
        #20_000_000;      

        // '도' 뗌
        btn = 7'b000_0000;
        #20_000_000;      

        // '레(btn[1])' 누름
        btn = 7'b000_0010;
        #20_000_000;      
            
        // '레' 뗌
        btn = 7'b000_0000;
        #20_000_000;      

        // ==========================================
        // 3. 효과음 모드 테스트 (sw = 1)
        // ==========================================
        sw = 1'b1;
        #1_000_000;

        // Power On 부저 테스트 (btn[1] 누름)
        btn = 7'b000_0010;
        #300_000_000;     
        btn = 7'b000_0000;
        #10_000_000;

        // Open Door 부저 테스트 (btn[3] 누름)
        btn = 7'b000_1000;
        #300_000_000;     
        btn = 7'b000_0000;
        #10_000_000;
        $finish;
    end
endmodule
