`timescale 1ns / 1ps


module led_onoff_500ms(
    input tim_1ms,
    output reg led = 1'b0
    );

    //500ms 생성
    reg [8:0] r500_count = 0;
    

    always @(posedge tim_1ms) begin
        if(r500_count == (500 - 1)) begin
            led <= ~led;
            r500_count <= 0;
        end 
        else begin
           r500_count <= r500_count + 1; 
        end
    end
   
endmodule
