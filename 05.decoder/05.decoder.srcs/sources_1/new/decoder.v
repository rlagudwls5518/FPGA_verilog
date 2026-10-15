`timescale 1ns / 1ps



module decoder(
    input [1:0] a,
    output [3:0] led
    );
    reg [3:0] r_led;
    //output에 바로 결과출력하면 에ㅐ러남 
    //reg 변수 하나를 둬야함


    // assign led = (a ==2'b00) ? 4'b0001 :
    //              (a ==2'b01) ? 4'b0010 :
    //              (a ==2'b10) ? 4'b0100 :
    //                            4'b1000;

    always @(a) begin
        case(a)
        2'b00 : r_led = 4'b0001;
        2'b01 : r_led = 4'b0010;
        2'b10 : r_led = 4'b0100;
        2'b11 : r_led = 4'b1000;
        endcase        
    end

    assign led[3:0] = r_led[3:0];

endmodule
