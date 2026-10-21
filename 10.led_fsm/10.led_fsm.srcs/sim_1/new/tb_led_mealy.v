`timescale 1ns / 1ps


module tb_led_mealy();
    reg clk = 0;
    reg reset = 0;
    reg clean_btn = 0;
    wire [4:0] w_led;

    reg r_error =0;

    led_mealy u_led_mealy(
        .clk(clk),
        .reset(reset),
        .clean_btn(clean_btn),
        .led(w_led)
    );

    always #5 clk = ~clk; // 100mhz clk 생성
    task send_data(input a, input[4:0] expext_val);
        begin
            clean_btn =a; #1; //gate 동작
            @(posedge clk); #1;
            if(w_led !== expext_val)begin //y가 기대값이 아닌 다른 값이면 DUT에 logic errorrk 발생 되었다.
                r_error =1'b1; // erroe detect flag
                $display("FAIL t=%0t btn=%b led=%b expect_val=%b", $time, a, w_led, expext_val);
            end
            
        end
    endtask

    initial begin // 밀리
        #100 reset = 1;
        #100 reset = 0;

        send_data(1,5'b00010); //S1
        send_data(0, 5'b00010);

        send_data(1,5'b00100); //S2
        send_data(0, 5'b00100);
        send_data(1,5'b01000); //S3
        send_data(0, 5'b01000);
        send_data(1,5'b10100); //S2
        send_data(0, 5'b10100);
        send_data(1,5'b10010); //S1
        send_data(0, 5'b10010);

        send_data(1,5'b10001); //S0
        send_data(0,5'b10001);
        $finish;
    end

endmodule

