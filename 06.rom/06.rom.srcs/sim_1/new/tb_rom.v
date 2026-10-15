`timescale 1ns / 1ps


module tb_rom();

    reg [3:0] r_addr;
    reg r_oe;
    wire [7:0] w_data_out;

    rom u_rom(
        .addr(r_addr),
        .oe(r_oe),
        .data_out(w_data_out)
    );

    initial begin
        #00 r_oe = 1'b0; r_addr = 4'b0000;

        #10 r_oe = 1'b1; r_addr = 4'b0000;
        #10 r_oe = 1'b1; r_addr = 4'b0001;
        #10 r_oe = 1'b1; r_addr = 4'b0010;
        #10 r_oe = 1'b1; r_addr = 4'b0011;

        #10 r_oe = 1'b1; r_addr = 4'b1110;
        #10 r_oe = 1'b1; r_addr = 4'b1111;
        #10
        $finish;
    end
endmodule
