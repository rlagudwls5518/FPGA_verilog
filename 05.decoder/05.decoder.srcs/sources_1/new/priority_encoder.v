`timescale 1ns / 1ps


module priority_encoder(
    input [3:0] a,
    output [1:0] led,
    output v
    );
    reg [1:0] r_led;
    reg r_v;

    always@(*) begin
        if (a[3] == 1'b1) begin
            r_led = 2'b11;
            r_v = 1'b1;
        end 
        else if ((a[3] == 1'b0) && (a[2] == 1'b1)) begin
            r_led = 2'b10;
            r_v = 1'b1;
        end 
        else if ((a[3] == 1'b0) && (a[2] == 1'b0) && (a[1] == 1'b1)) begin
            r_led = 2'b01;
            r_v = 1'b1;
        end 
        else if ((a[3] == 1'b0) && (a[2] == 1'b0) && (a[1] == 1'b0) && (a[0] == 1'b1)) begin
            r_led = 2'b00;
            r_v = 1'b1;
        end 
        else begin
            r_led = 2'bxx;
            r_v = 1'b0;
        end
    end

    assign v = r_v;
    assign led = r_led;

endmodule
