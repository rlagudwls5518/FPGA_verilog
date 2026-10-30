`timescale 1ns / 1ps


module data_sender(
    input clk, reset, start_trigger,//1hz짜리, 
    input [7:0] send_data,
    input tx_busy,

    output reg [7:0] tx_data,
    output reg tx_start
    );


    localparam [6:0] STR_LEN = 7'd10; // "COUNTER: 0\n"의 글자 수
    reg[6:0] r_send_count = 7'b0;
    reg r_sending =0; //문자열 전송중을 나타내는 indicator

    wire [7:0] w_char;
    
    ascii_string_table u_ascii_string_table (
        .index(r_send_count),
        .data(w_char)
    );


    always @(posedge clk, posedge reset) begin
        if(reset)begin
            tx_start <=0;
            r_send_count = 7'b0;
            r_sending <=0;
        end else begin
            tx_start <=0;
            if (!r_sending) begin
                if (start_trigger) begin
                    r_sending <= 1'b1;
                    r_send_count <=0;
                end 
            end else if(!tx_busy && !tx_start) begin
                if (r_send_count == STR_LEN) begin
                    r_sending <= 1'b0;
                end else begin
                    tx_data <= w_char;
                    tx_start <= 1'b1;
                    r_send_count <= r_send_count +1;
                end
            end
        end
    end

endmodule


//COUNTER: 0\n
module ascii_string_table (
    input [6:0] index,
    output reg [7:0] data
    );

    always @(*) begin
        case (index)
            7'd0: data = 8'h43;
            7'd1: data = 8'h4F;
            7'd2: data = 8'h55;
            7'd3: data = 8'h4E;
            7'd4: data = 8'h54;
            7'd5: data = 8'h45;
            7'd6: data = 8'h52;
            7'd7: data = 8'h3A; 
            7'd0: data = 8'h20;
            7'd0: data = 8'h30;
            7'd0: data = 8'h0A;

            default: data = 8'h0;
        endcase
    end

    
endmodule