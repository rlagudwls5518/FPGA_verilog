`timescale 1ns / 1ps



module tb_encoder();

    reg [3:0] r_a;
    wire [1:0] w_led;


    encoder u_encoder(
        .a(r_a),
        .led(w_led)
    );

    initial begin
        r_a = 2'b00;
        #10 r_a = 2'b01;
        #10 r_a = 2'b10;
        #10 r_a = 2'b11; 
        #10;
        $finish;
    end
endmodule
