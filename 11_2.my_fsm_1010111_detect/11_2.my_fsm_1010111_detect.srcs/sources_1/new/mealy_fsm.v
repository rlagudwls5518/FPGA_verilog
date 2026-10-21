`timescale 1ns / 1ps

module mealy_fsm(
    input clk, reset, btn_press, x,
    output [15:0] led
    );

    reg [2:0] curr_fsm, next_fsm;
    reg [6:0] dump;

    always @(posedge reset, posedge clk) begin 
        if (reset) begin 
            curr_fsm <= 0;
            
        end else begin
            curr_fsm <= next_fsm;
        end
    end

    always @(*) begin
        next_fsm = curr_fsm;
        dump = 7'b0000000;

        if (btn_press) begin
            case (curr_fsm)
                3'd0 : if (x == 1) begin
                            next_fsm = 3'd1;
                            dump = 7'b0000001;
                        end else begin
                            next_fsm = 3'd0;
                            dump = 7'b0000000;
                        end
                3'd1 : if (x == 0) begin
                            next_fsm = 3'd2;
                            dump = 7'b0000010;
                        end else begin
                            next_fsm = 3'd1;
                            dump = 7'b0000011;
                        end 
                3'd2 : if (x == 1) begin
                            next_fsm = 3'd3; 
                            dump = 7'b0000101;
                        end else begin
                            next_fsm = 3'd0;
                            dump = 7'b0000100;
                        end
                3'd3 : if (x == 0) begin 
                            next_fsm = 3'd4; 
                            dump = 7'b0001010;
                        end else begin 
                            next_fsm = 3'd1;
                            dump = 7'b0001011;
                        end
                3'd4 : if (x == 1) begin 
                            next_fsm = 3'd5; 
                            dump = 7'b0010101;
                        end else begin 
                            next_fsm = 3'd0;
                            dump = 7'b0010100;
                        end
                3'd5 : if (x == 1) begin 
                            next_fsm = 3'd6; 
                            dump = 7'b0101011;
                        end else begin 
                            next_fsm = 3'd4; 
                            dump = 7'b0101010;
                        end
                3'd6 : if (x == 1) begin 
                            next_fsm = 3'd1; 
                            dump = 7'b1010111;
                        end else begin 
                            next_fsm = 3'd2; 
                            dump = 7'b1010110;
                        end 
                default : begin
                            next_fsm = 3'd0;
                            dump = 7'b0000000;
                        end
            endcase 
        end
    end

    wire result = ((curr_fsm == 6) && (x == 1) && btn_press);
    assign led = {8'b00000000, result, dump};

endmodule
