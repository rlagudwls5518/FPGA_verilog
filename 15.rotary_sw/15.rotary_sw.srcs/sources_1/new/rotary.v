`timescale 1ns / 1ps

module rotary(
    input reset, clk, s1, s2, key,
    output [15:0] led
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
            r_direction <= 2'b00;
            r_prev_state <= 2'b00;
            r_curr_state <= 2'b00;
            r_step <= 2'b00;
            r_counter <= 8'h00;
        end else begin
            r_prev_state <= r_curr_state;
            r_curr_state <= {s1, s2};
            case ({r_prev_state, r_curr_state})
                4'b0010,4'b1011,4'b1101,4'b0100 : begin //cw 오버플로우
                    if(r_counter < 8'hFF && r_step == 2'b11) r_counter <= r_counter +1;
                    r_step <= r_step +1;
                    r_direction <= 2'b01;
                end
                4'b0001,4'b0111,4'b1110,4'b1000 : begin //ccw 언더플로우
                    if(r_counter > 8'h00 && r_step == 2'b11) r_counter <= r_counter -1;
                    r_step <= r_step +1;
                    r_direction <= 2'b10;
                end  
            endcase
        end
    end
    //2. key 토글처리 (순차회로)
    reg r_led_toggle = 1'b0;
    reg r_prev_key = 1'b0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_led_toggle <= 1'b0;
            r_prev_key <= 1'b0;
        end else begin
            r_prev_key <= key;
            if(!r_prev_key && key) r_led_toggle= ~r_led_toggle;
        end
    end

    //3. led 표시기능 (조합회로)
    assign led[15:14] = r_direction;
    assign led[13] = r_led_toggle;
    assign led[12:8] = 5'b00000;
    assign led[7:0] = r_counter;
endmodule
