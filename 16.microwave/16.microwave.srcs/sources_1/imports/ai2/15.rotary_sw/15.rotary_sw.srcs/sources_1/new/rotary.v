`timescale 1ns / 1ps

module rotary(
    input reset, clk, s1, s2,
    output reg cw_pulse, ccw_pulse
    );

    reg [1:0] r_direction = 2'b00; // 시계 01 반시계 10
    reg [1:0] r_prev_state = 2'b00;
    reg [1:0] r_curr_state = 2'b00;
    reg [1:0] r_step = 2'b00;
    reg [7:0] r_counter = 8'h00;
    //1. s1 s2 로직 체크 (순차회로)
    //방향 설정 
    //CW  00 --> 10 --> 11 --> 01 --> 00 (1씩 증가 r_step)
    //CCW 00 --> 01 --> 11 --> 10 --> 00
    always @(posedge clk, posedge reset) begin
        if(reset)begin
            cw_pulse <=0; 
            ccw_pulse <=0;
            r_prev_state <= 2'b00;
            r_curr_state <= 2'b00;
            r_step <= 2'b00;
            r_counter <= 8'h00;
        end else begin
            r_prev_state <= r_curr_state;
            cw_pulse <=0; 
            ccw_pulse <=0;
            r_curr_state <= {s1, s2};
            case ({r_prev_state, r_curr_state})
                4'b0010,4'b1011,4'b1101,4'b0100 : begin //cw 
                    if(r_counter < 8'hFF && r_step == 2'b11) begin 
                        cw_pulse <= 1;
                        r_counter <= r_counter +1;
                    end
                    r_step <= r_step + 1;
                end
                4'b0001,4'b0111,4'b1110,4'b1000 : begin //ccw 
                    if(r_counter > 8'h00 && r_step == 2'b11) begin
                        ccw_pulse <= 1;
                        r_counter <= r_counter -1;
                    end
                    r_step <= r_step +1;
                end  
            endcase
        end
    end
endmodule
