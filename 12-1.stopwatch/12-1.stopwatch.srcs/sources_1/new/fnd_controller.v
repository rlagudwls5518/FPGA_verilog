`timescale 1ns / 1ps

module fnd_controller(
    input clk, reset, tick_1ms, tick_100ms,
    input circle_mode_en, dp_clock_mode_en,
    input [13:0] in_data,

    output [3:0] an,
    output [7:0] seg
    );

    wire [1:0] w_sel;
    wire [3:0] w_d1, w_d10, w_d100, w_d1000;
    wire [3:0] w_anim_step;
    wire w_r_dot_toggle;

    fnd_digit_select u_fnd_digit_select(
        .clk(clk),
        .reset(reset),
        .tick(tick_1ms),
        .circle_mode_en(circle_mode_en), 
        .tick_100ms(tick_100ms),
        .r_anim_step(w_anim_step),
        .r_dot_toggle(w_r_dot_toggle),
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
        .d1(w_d1),
        .d10(w_d10),
        .d100(w_d100),
        .d1000(w_d1000),
        .r_anim_step(w_anim_step),
        .circle_mode_en(circle_mode_en),
        .r_dot_toggle(w_r_dot_toggle),
        .dp_clock_mode_en(dp_clock_mode_en),
        .an(an),
        .seg(seg)
    );


endmodule


//1ms마다 fnd를 display digit 1자리씩 선택하는 logic
module fnd_digit_select(
    input clk, reset, tick,
    input circle_mode_en, tick_100ms,
    output reg [1:0] sel, // 00 01 10 11 : 1ms마다 바뀜
    output reg [3:0] r_anim_step,
    output reg r_dot_toggle
    );

    always @(posedge reset, posedge clk) begin
        if(reset) sel <= 0;
        else begin
            if(tick) sel <= sel + 1;
        end
    end

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_anim_step <= 3'd0;
        end else if (circle_mode_en) begin
            if (tick_100ms) begin
                if (r_anim_step == 4'd11) begin
                    r_anim_step <= 4'd0;
                end else begin
                    r_anim_step <= r_anim_step + 1'b1;
                end
            end
        end else begin
            r_anim_step <= 4'd0; 
        end
    end

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_dot_toggle <= 0;
        end else begin
            if (tick_100ms) r_dot_toggle <= ~r_dot_toggle;
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
    input circle_mode_en,
    input r_dot_toggle, dp_clock_mode_en,
    input [1:0] sel,
    input [3:0] d1, d10, d100, d1000,
    input [3:0] r_anim_step,

    output reg [3:0] an,
    output reg [7:0] seg
    );

    reg [3:0] bcd_data;

    always @(*) begin
        if(circle_mode_en) begin
            case (r_anim_step)
                4'd0: an = 4'b0111;
                4'd1: an = 4'b1011;
                4'd2: an = 4'b1101;
                4'd3: an = 4'b1110;
                4'd4:  an = 4'b1110; 
                4'd5:  an = 4'b1110; 
                4'd6:  an = 4'b1110; 
                4'd7:  an = 4'b1101; 
                4'd8:  an = 4'b1011; 
                4'd9:  an = 4'b0111; 
                4'd10: an = 4'b0111; 
                4'd11: an = 4'b0111; 
                default: an = 4'b1111; 
            endcase
        end else begin
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
    end

    always @(*) begin

        if(circle_mode_en) begin // 서클 애니메이션
            case (r_anim_step)
                // 윗줄 (좌 -> 우)
                4'd0: seg = 8'b1111_1110; // d1000, A
                4'd1: seg = 8'b1111_1110; // d100,  A
                4'd2: seg = 8'b1111_1110; // d10,   A
                4'd3: seg = 8'b1111_1110; // d1,    A

                // 우측 모서리 (위 -> 아래)
                4'd4:  seg = 8'b1111_1101; // d1,    B
                4'd5:  seg = 8'b1111_1011; // d1,    C

                // 아랫줄 (우 -> 좌)
                4'd6:  seg = 8'b1111_0111; // d1,    D
                4'd7:  seg = 8'b1111_0111; // d10,   D
                4'd8:  seg = 8'b1111_0111; // d100,  D
                4'd9:  seg = 8'b1111_0111; // d1000, D

                // 좌측 모서리 (아래 -> 위)
                4'd10: seg = 8'b1110_1111; // d1000, E
                4'd11: seg = 8'b1101_1111; // d1000, F

                default: seg = 8'b1111_1111;
            endcase    
        end else begin
           case(bcd_data)
                4'd0: seg = 8'b11000000;   // 0
                4'd1: seg = 8'b11111001;   // 1
                4'd2: seg = 8'b10100100;   // 2
                4'd3: seg = 8'b10110000;   // 3
                4'd4: seg = 8'b10011001;   // 4
                4'd5: seg = 8'b10010010;   // 5
                4'd6: seg = 8'b10000010;   // 6
                4'd7: seg = 8'b11111000;   // 7
                4'd8: seg = 8'b10000000;   // 8
                4'd9: seg = 8'b10010000;   // 9
                default: seg = 8'b11111111;  // all off  
            endcase 

            if(dp_clock_mode_en & r_dot_toggle & sel == 2'b10) seg[7] = 1'b0;
            else seg[7] = 1'b1;
        end

    end 

endmodule
