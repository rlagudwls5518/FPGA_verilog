`timescale 1ns / 1ps

module main_controller(
    input clk,
    input reset,
    input [2:0] btn,    // btn[0]: btnL, btn[1]: btnC, btn[2]: btnR
    input [7:0] sw,
    output [13:0] seg_data,
    output reg [15:0] led    
    );

    // mode define
    parameter IDLE = 2'b00;
    parameter UP_COUNTER = 2'b01;
    parameter DOWN_COUNTER = 2'b10;
    parameter SLIDE_SW_READ = 2'b11;

    reg [1:0] r_mode=IDLE;
    reg [$clog2(1_000_000)-1:0] r_10ns_counter; // 10ns counter
    reg [$clog2(10_000)-1:0] r_10ms_counter; // 10ms counter 9999
    reg r_prev_btnL = 0;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_mode <= IDLE;
            r_prev_btnL <= 0;
        end else begin
            if (btn[0] && !r_prev_btnL)  // btn press
                r_mode <= (r_mode == SLIDE_SW_READ) ? UP_COUNTER : r_mode + 1'b1;

            r_prev_btnL <= btn[0];
        end
    end

    // (2) up / down counter / SLIDE SW read
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_10ns_counter <= 0;
            r_10ms_counter <= 0;
            led[13:0] <= 0;
        end else if(r_mode == UP_COUNTER) begin
            if (r_10ns_counter == 20'd1_000_000-1) begin    // 10ms reached
                r_10ns_counter <= 0;
                if(r_10ms_counter >= 9999)
                    r_10ms_counter <= 0;
                else r_10ms_counter <= r_10ms_counter + 1;
            end else begin
                r_10ns_counter <= r_10ns_counter + 1'b1;
                end

            led[13:0] <= r_10ms_counter;
        end else if(r_mode == DOWN_COUNTER) begin
            if (r_10ns_counter == 20'd1_000_000-1) begin    // 10ms reached
                r_10ns_counter <= 0;
                if(r_10ms_counter == 0)
                    r_10ms_counter <= 9999;
                else r_10ms_counter <= r_10ms_counter - 1'b1;
            end else begin
                r_10ns_counter <= r_10ns_counter + 1'b1;
            end
            led[13:0] <= r_10ms_counter;
            end else begin  // SLIDE SW READ
                led[13:8] <= 0;
                led[7:0] <= sw[7:0];
            end
    end

    // (3) mode display
    always @(r_mode) begin
        case (r_mode)
            UP_COUNTER: begin
                led[15:14] = UP_COUNTER;
            end
            DOWN_COUNTER: begin
                led[15:14] = DOWN_COUNTER;
            end
            SLIDE_SW_READ: begin
                led[15:14] = SLIDE_SW_READ;
            end
            default: led[15:14] = IDLE;
        endcase
    end

    assign seg_data = (r_mode == UP_COUNTER) ? r_10ms_counter :
                      (r_mode == DOWN_COUNTER) ? r_10ms_counter :  sw;
endmodule
