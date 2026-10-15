`timescale 1ns / 1ps


module tb_mux_4bit();

    reg [3:0] a, b;
    reg sel;
    wire [3:0] out;
    wire [7:0] led;

    mux_4bit u_0(
        .a(a), 
        .b(b), 
        .sel(sel), 
        .out(out),
        .led(led)
    );

    initial begin
        a[3:0] = 4'b0000;
        b[3:0] = 4'b0000;
        sel =0;


        #10 sel = 0; a[3:0] = 4'b1111; b[3:0] = 4'b0000;
        #10 sel = 0; a[3:0] = 4'b0000; b[3:0] = 4'b1111;

        #10 sel = 1; a[3:0] = 4'b0000; b[3:0] = 4'b1111;
        #10 sel = 1; a[3:0] = 4'b1111; b[3:0] = 4'b0000;

        #10 sel = 0; a[3:0] = 4'b0000; b[3:0] = 4'b1111;
        #10 sel = 1; a[3:0] = 4'b1111; b[3:0] = 4'b0000;
    end

    
endmodule
