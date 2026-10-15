`timescale 1ns / 1ps


module rom(
    input [3:0] addr,
    input oe,
    output reg [7:0] data_out
    );

    always @(addr, oe) begin

        if(!oe)begin
            data_out = 8'hz;
        end
        else begin
           case (addr)
            4'b0000 : data_out = 'h23;
            4'b0001 : data_out = 'hf3;
            4'b0010 : data_out = 'ha7;
            4'b0011 : data_out = 'h04;

            4'b1110 : data_out = 'h30;
            4'b1111 : data_out = 'hd5; 
            default: data_out = 'h00; 
            endcase 
        end
    end
endmodule
