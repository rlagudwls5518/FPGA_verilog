`timescale 1ns / 1ps


module tb_priority_encoder();

    reg [3:0] r_a;
    wire [1:0] w_led;
    wire r_v;

    priority_encoder u_priority_encoder(
        .a(r_a),
        .led(w_led),
        .v(r_v)
    );

    initial begin
        r_a = 4'b0000;
        #10 r_a = 4'b0001;
        #10 r_a = 4'b0010;
        #10 r_a = 4'b0011;

        #10 r_a = 4'b0100;
        #10 r_a = 4'b0101;
        #10 r_a = 4'b0110;
        #10 r_a = 4'b0111;

        #10 r_a = 4'b1000;
        #10 r_a = 4'b1001;
        #10 r_a = 4'b1010;
        #10 r_a = 4'b1011;

        #10 r_a = 4'b1100;
        #10 r_a = 4'b1101;
        #10 r_a = 4'b1110;
        #10 r_a = 4'b1111;

        #10;
        $finish;
    end
endmodule
