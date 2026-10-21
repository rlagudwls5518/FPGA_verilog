`timescale 1ns / 1ps


module tb_top_led();
    reg clk = 0;
    reg reset = 0;
    reg clean_btn = 0;
    wire [4:0] w_led;

    

    led_mealy u_led_mealy(
        .clk(clk),
        .reset(reset),
        .clean_btn(clean_btn),
        .led(w_led)
    );

    always #5 clk = ~clk; // 100mhz clk 생성


    initial begin
        #100 reset = 1;
        #100 reset = 0;
        
        #10 clean_btn = 1; //S1
        #10 clean_btn = 0;     
        #50;

        #10 clean_btn = 1; //S2
        #10 clean_btn = 0;     
        #50;

        #10 clean_btn = 1; //S3
        #10 clean_btn = 0;     
        #50;

        #10 clean_btn = 1; //S2
        #10 clean_btn = 0;     
        #50;

        #10 clean_btn = 1; //S1
        #10 clean_btn = 0;     
        #50;

        #10 clean_btn = 1; //S0
        #10 clean_btn = 0;     
        #50;

        #10 clean_btn = 0;
        $finish;
    end

endmodule
