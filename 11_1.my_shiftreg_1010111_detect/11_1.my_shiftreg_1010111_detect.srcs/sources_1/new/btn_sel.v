`timescale 1ns / 1ps

module btn_sel(
    input clk, reset, clean_btnU, clean_btnD,
    output btn_press, 
    output btn_output_data
    );

    wire [1:0] w_clean_btn = {clean_btnU, clean_btnD};

    reg [1:0] btn_prev;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            btn_prev <= 0;
        end else begin
            btn_prev <= w_clean_btn; 
        end
    end

    wire [1:0] btn_data = w_clean_btn & ~btn_prev;

    assign btn_press = btn_data[1] | btn_data[0];
    assign btn_output_data  = btn_data[1] ? 1 : 0;

endmodule
