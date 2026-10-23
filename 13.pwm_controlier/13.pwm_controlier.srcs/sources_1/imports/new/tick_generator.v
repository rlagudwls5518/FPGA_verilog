`timescale 1ns / 1ps

module tick_generator(
    input clk, reset,
    output tick_1ms
    // tick_10ms, tick_100ms, tick_sec
    );

    tic_generator_1ms u_tic_generator_1ms(
        .clk(clk),
        .reset(reset),
        .tick_1ms(tick_1ms)
    );

    // tic_generator_sec u_tic_generator_sec(
    //     .clk(clk),
    //     .reset(reset),
    //     .tick_1ms(tick_1ms),
    //     .tick_sec(tick_sec)
    // );

    // tic_generator_10ms u_tic_generator_10ms(
    //     .clk(clk),
    //     .reset(reset),
    //     .tick_1ms(tick_1ms),
    //     .tick_10ms(tick_10ms)
    // );    

    // tic_generator_100ms u_tic_generator_100ms(
    //     .clk(clk),
    //     .reset(reset),
    //     .tick_10ms(tick_10ms),
    //     .tick_100ms(tick_100ms)
    // );  
endmodule

// //1초 틱 생성기
// module tic_generator_sec (
//     input clk, reset, tick_1ms,
//     output reg tick_sec
// );
//     reg [$clog2(1000)-1:0] r_tick_sec_counter; 

//     always @(posedge clk, posedge reset) begin
//         if(reset) begin
//             tick_sec <=0;
//             r_tick_sec_counter <= 0;
//         end else begin
//             tick_sec <= 0;
//             if (tick_1ms) begin
//                 if (r_tick_sec_counter == 999) begin
//                     r_tick_sec_counter <= 0;
//                     tick_sec <= 1; 
//                 end else begin
//                     r_tick_sec_counter <= r_tick_sec_counter + 1;  
//                 end
//             end
//         end
//     end
    
// endmodule

// //100ms 틱 생성기
// module tic_generator_100ms (
//     input clk, reset, tick_10ms,
//     output reg tick_100ms
// );
//     reg [3:0] r_tick_100ms_counter; // 100ms counter

//     always @(posedge clk, posedge reset) begin
//         if(reset) begin
//             tick_100ms <=0;
//             r_tick_100ms_counter <= 0;
//         end else begin
//             tick_100ms <=0;
//             if(tick_10ms)begin
//                if(r_tick_100ms_counter == 9)begin
//                     r_tick_100ms_counter <= 0;
//                     tick_100ms <= 1;
//                 end else begin
//                     r_tick_100ms_counter <= r_tick_100ms_counter + 1;  
//                 end 
//             end
//         end
//     end
    
// endmodule


// //10ms 틱 생성기
// module tic_generator_10ms (
//     input clk, reset, tick_1ms,
//     output reg tick_10ms
// );
//     reg [3:0] r_tick_10ms_counter; // 10ms counter 9999

//     always @(posedge clk, posedge reset) begin
//         if(reset) begin
//             tick_10ms <=0;
//             r_tick_10ms_counter <= 0;
//         end else begin
//             tick_10ms <=0;
//             if(tick_1ms)begin
//                if(r_tick_10ms_counter == 9)begin
//                     r_tick_10ms_counter <= 0;
//                     tick_10ms <= 1;
//                 end else begin
//                     r_tick_10ms_counter <= r_tick_10ms_counter + 1;  
//                 end 
//             end
//         end
//     end
    
// endmodule


//1ms 틱 생성기
module tic_generator_1ms (
    input clk, reset,
    output reg tick_1ms
);
    parameter INPUT_FREQ = 100_000_000;
    parameter TICK_1MS_Hz = 1000;
    parameter TICK_1MS_COUNT = INPUT_FREQ/TICK_1MS_Hz;

    reg [$clog2(TICK_1MS_COUNT)-1:0] r_tick_1ms_counter;

    always @(posedge clk, posedge reset) begin
        if(reset)begin
            tick_1ms <= 0;
            r_tick_1ms_counter <= 0;
        end
        else begin
            if(r_tick_1ms_counter == (TICK_1MS_COUNT - 1))begin
                tick_1ms <= 1;
                r_tick_1ms_counter <= 0;
            end
            else begin
                r_tick_1ms_counter <= r_tick_1ms_counter + 1; 
                tick_1ms <= 0;
            end
        end
    end
    
endmodule
