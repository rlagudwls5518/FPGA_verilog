`timescale 1ns / 1ps


module tb_btn_debounce();
    parameter CLK_FRE = 100_000_000; // 100MHZ
    parameter CLK_PERIOD = 10; // 10ns (100MHz의 1주기)

    // 시뮬레이션 시간비 조정
    //실제 보드동작 분주비 : DIV = 1_250_000 -> 1주기가 12.5ms 80Hm
    //시뮬레이션 용 분주비 : DIV = 100 -> 1주기가 1us (1Mhz) -> 실제 보드동작 비보다 12,500배 단축
    parameter SIMULATION_DIV = 100; // 1Mhz
    localparam SAMPLE_PERIOD = SIMULATION_DIV * CLK_PERIOD; // 1000ns -> 1us
    //버튼을 누르고있는 시간을 정한다(시뮬레이션시)
    //sample clk 3주기 동안 누르고 있다고 설정
    parameter BTN_PRESS_LIMIT = SAMPLE_PERIOD * 3; // 3,000ns

    defparam top_btn_debounce.u_u_btn_debounce.u_clock_80Hz.DIV = SIMULATION_DIV;

    reg clk, reset, btnC;
    wire led;

    top_btn_debounce u_top_btn_debounce(
        .clk(clk),
        .reset(reset), 
        .btnC(btnC),
        .led(led)
    );

    initial begin
        clk = 0; 
        forever begin
            #(CLK_PERIOD/2) clk = ~clk; // 100MHz clk 생성
        end
    end

    initial begin
        reset = 1;
        btnC = 0;
        
        #100;
        reset = 0;
        // btn_input
        $display("[%0t] start noise signal generation........", $time);
        #100; btnC = 1;
        #200; btnC = 0;
        #300; btnC = 1;
        #120; btnC = 0;
        #500; //쓰레기 noise 생성
        btnC = 1;

        # (BTN_PRESS_LIMIT); // 3us 3주기 동안

        #100;

        if (led == 1'b1) begin
            $display("[%0t] SIM TEST PASSED !!!!........", $time);
        end else begin
            $display("[%0t] SIM TEST FAILED !!!!........", $time);
        end
        #1000;
        $display("[%0t] simulation finish........", $time);
        $finish;
    end   
endmodule
