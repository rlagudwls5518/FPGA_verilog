`timescale 1ns / 1ps

module tb_shiftreg();
    reg clk = 0;
    reg reset = 0;
    reg btn_press = 0;
    reg x =0;
    wire [15:0] w_led;



    shift_register u_shift_register(
        .clk(clk),
        .reset(reset),
        .x(x),
        .btn_press(btn_press),
        .led(w_led)
    );

    always #5 clk = ~clk;

    task send_data(input data, input[7:0] expext_val);
        begin
            @(negedge clk); #1; 
            x = data;
            btn_press = 1;    

            @(negedge clk); #1; 
            btn_press = 0;     

            if(w_led !== expext_val)begin //y가 기대값이 아닌 다른 값이면 DUT에 logic errorrk 발생 되었다.
                $display("FAIL t=%0t data=%b led=%b expect_val=%b", $time, data, w_led, expext_val);
            end
        end
    endtask

    initial begin
        reset = 1;
        #100;
        reset = 0;
        send_data(1,16'b0000000000000001);
        send_data(0,16'b0000000000000010);
        send_data(1,16'b0000000000000101);
        send_data(0,16'b0000000000001010);
        send_data(1,16'b0000000000010101);
        send_data(1,16'b0000000000101011);
        send_data(1,16'b0000000011010111);
      

        @(negedge clk);
        @(negedge clk);

        $finish;
    end

endmodule
