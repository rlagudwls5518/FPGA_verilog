`timescale 1ns / 1ps

module fnd_controller(
    input clk, reset, tick,
    input [13:0] in_data,
    input [1:0] motor_direction,

    output [3:0] an,
    output [7:0] seg
    );

    wire [1:0] w_sel;
    wire [3:0] w_d1, w_d10, w_d100, w_d1000;

    fnd_digit_select u_fnd_digit_select(
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .sel(w_sel)
    );

    bin_to_brd_4digit u_bin_to_brd_4digit(
        .in_data(in_data),
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100),
        .d1000(w_d1000)
    );

    fnd_digit_display u_fnd_digit_display(
        .sel(w_sel),
        .motor_direction(motor_direction),
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100),
        .d1000(w_d1000),
        .an(an),
        .seg(seg)
    );


endmodule

//1ms마다 fnd를 display digit 1자리씩 선택하는 logic
module fnd_digit_select(
    input clk, reset, tick,
    output reg [1:0] sel // 00 01 10 11 : 1ms마다 바뀜
    );

    always @(posedge reset, posedge clk) begin
        if(reset) sel <= 0;
        else begin
            if(tick) sel <= sel + 1;
        end
    end

endmodule

//fnd 9999까지 표현 하기위한 bin size
//0~9999 천/백/십/일 자리숫자를 0~9까지 BCD로 4bit표현
module bin_to_brd_4digit(
    input [13:0] in_data,
    output [3:0] d1, d10, d100, d1000
    );

    assign d1 = in_data % 10;
    assign d10 = (in_data / 10) % 10;
    assign d100 = (in_data / 100) % 10;
    assign d1000 = (in_data / 1000) % 10;
endmodule

module fnd_digit_display(
    input [1:0] sel, 
    input [1:0] motor_direction,
    input [3:0] d1, d10, d100, d1000,

    output reg [3:0] an,
    output reg [7:0] seg
    );

    reg [3:0]bcd_data;
    reg [2:0]dir_data;

    always @(*) begin // sel이 변할때는 언제나 수행함
        case(sel)
         2'b00 : begin
            bcd_data = d1;
            an = 4'b1110;
         end
         2'b01 : begin
            bcd_data = d10;
            an = 4'b1101;
         end
         2'b10 : begin
            bcd_data = d100;
            an = 4'b1011;
         end
         2'b11 : begin
            bcd_data = d1000;
            an = 4'b0111;
         end
         default: begin
            bcd_data = 4'b0000;
            an = 4'b1111;
         end
        endcase
    end

    always @(*) begin
        if (sel == 2'b11) begin
            case (motor_direction)
                2'b01:   seg = 8'b1000_1110; // F 
                2'b10:   seg = 8'b1010_0001; // d 
                2'b00:   seg = 8'b1001_0010; // S 
                default: seg = 8'b1111_1111; // 꺼짐
            endcase
        end else begin
            case (bcd_data)
                4'd0:    seg = 8'b1100_0000; // 0
                4'd1:    seg = 8'b1111_1001; // 1
                4'd2:    seg = 8'b1010_0100; // 2
                4'd3:    seg = 8'b1011_0000; // 3
                4'd4:    seg = 8'b1001_1001; // 4
                4'd5:    seg = 8'b1001_0010; // 5
                4'd6:    seg = 8'b1000_0010; // 6
                4'd7:    seg = 8'b1111_1000; // 7
                4'd8:    seg = 8'b1000_0000; // 8
                4'd9:    seg = 8'b1001_0000; // 9
                default: seg = 8'b1111_1111; // 꺼짐
            endcase
        end
    end 

endmodule
