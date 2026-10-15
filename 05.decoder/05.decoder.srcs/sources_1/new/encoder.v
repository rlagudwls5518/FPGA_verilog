`timescale 1ns / 1ps



module encoder(
    input [3:0] a,
    output [1:0] led
    );
    reg [1:0] r_led;

    always @(a) begin
        case(a)
        4'b0001 : r_led = 2'b00;
        4'b0010 : r_led = 2'b01;
        4'b0100 : r_led = 2'b10;
        4'b1000 : r_led = 2'b11;
        endcase        
    end
    assign led[1:0] = r_led[1:0];
    
endmodule
