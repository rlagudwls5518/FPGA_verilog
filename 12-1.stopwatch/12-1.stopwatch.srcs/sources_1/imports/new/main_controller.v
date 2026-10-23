`timescale 1ns / 1ps

module main_controller(
    input clk, reset, tick_sec, tick_10ms,
    input [2:0] btn,    // btn[0]: btnL, btn[1]: btnC, btn[2]: btnR

    output [13:0] seg_data,
    output circle_mode_en, dp_clock_mode_en
    );

    // mode define
    parameter STOP_WATCH = 1'b0;
    parameter MIN_SEC = 1'b1;

    parameter IDLE = 2'b00;
    parameter RUN = 2'b01;  
    parameter PAUSE = 2'b10;
    parameter RESET = 2'b11;

    parameter CIRCLE_MODE = 1'b1;
    parameter NONE = 1'b0 ;
    

    reg r_mode; // 모드 구분
    reg [1:0] stop_watch_mode; // 스탑워치 모드구분
    reg after_5sec; // 그냥 스탑워치 상태 , 5초지나서 애니매이션 상태 

    reg [3:0] circle_5sec; // 일시정지후 5초가 지났는지

    reg [5:0] r_sec_counter;
    reg [5:0] r_min_counter;

    reg [7:0] r_st_ms_counter;
    reg [7:0] r_st_sec_counter;

    reg r_prev_btnL, r_prev_btnC, r_prev_btnR = 0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_mode <= MIN_SEC;
            stop_watch_mode <= IDLE;
            r_prev_btnL <= 0;
            r_prev_btnC <= 0;
            r_prev_btnR <= 0;
        end else begin
            if (btn[0] && !r_prev_btnL) begin  // btnL press
                if(r_mode == MIN_SEC) r_mode <= STOP_WATCH;
                else r_mode <= MIN_SEC;
            end
            if (btn[1] && !r_prev_btnC) begin // btnC press
                if(r_mode == STOP_WATCH) stop_watch_mode <= RESET;
            end
            if (btn[2] && !r_prev_btnR) begin  // btnR press
                if(r_mode == STOP_WATCH) begin 
                    if(stop_watch_mode == RUN) stop_watch_mode <= PAUSE;
                    else stop_watch_mode <= RUN;
                end
            end
            r_prev_btnL <= btn[0];
            r_prev_btnC <= btn[1];
            r_prev_btnR <= btn[2];
        end
    end


    always @(posedge clk, posedge reset) begin // 일반 시계 모드
        if (reset) begin
            r_sec_counter <= 0;
            r_min_counter <= 0;
        end else if(r_mode == MIN_SEC) begin
            if(tick_sec)begin
                if(r_sec_counter == 59) begin
                    r_sec_counter <= 0;
                    r_min_counter <= r_min_counter + 1;
                end else r_sec_counter <= r_sec_counter + 1;
            end
        end
    end

    always @(posedge clk, posedge reset) begin //스탑워치 모드
        if (reset) begin
            r_st_ms_counter <= 0;
            circle_5sec <= NONE;
            r_st_sec_counter <=0;
            after_5sec <=NONE;
        end else if (r_mode == STOP_WATCH) begin
            case(stop_watch_mode)
                RESET : begin
                    r_st_ms_counter <= 0;
                    r_st_sec_counter <= 0;
                    circle_5sec <=0;
                    after_5sec <= NONE;
                end
                PAUSE : begin
                    if(tick_sec)begin
                        after_5sec <= NONE;
                        if(circle_5sec >= 4) begin
                            after_5sec <= CIRCLE_MODE;
                        end else circle_5sec <= circle_5sec + 1;
                    end
                end
                RUN : begin
                    after_5sec <= NONE;
                    if(tick_10ms) begin
                        if(r_st_ms_counter == 99) begin
                            r_st_ms_counter <= 0;
                            if(r_st_sec_counter == 59) r_st_sec_counter <= 0;
                            else r_st_sec_counter <= r_st_sec_counter + 1; 

                        end else r_st_ms_counter <= r_st_ms_counter + 1;
                    end
                end 
            endcase
        end 
    end

    assign dp_clock_mode_en = (r_mode == MIN_SEC);
    assign circle_mode_en = (r_mode == STOP_WATCH) && (after_5sec == CIRCLE_MODE);
    assign seg_data = (r_mode == STOP_WATCH) ? (r_st_sec_counter * 100) + r_st_ms_counter :
                      (r_min_counter * 100) + r_sec_counter;

endmodule
