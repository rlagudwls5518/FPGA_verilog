`timescale 1ns / 1ps
//최소 시간단위 1ns 정확도는 1ps( = 0.001ns)소수점 이하 셋째자리에서 반올림 하겠다?

module gates(
    input a,
    input b, // wire 생략하면 default로 wire로 인식
    output [5:0] led // 신호선이 5가닥
    );

    assign led[0] = a & b;
    assign led[1] = a | b;
    assign led[2] = ~(a & b);
    assign led[3] = ~(a | b);
    assign led[4] = a ^ b;
    assign led[5] = ~a;
endmodule

// module gates(
//     input a,
//     input b,
//     output ld0,
//     output ld1,
//     output ld2,
//     output ld3,
//     output ld4,
//     output ld5
//     );

//     assign ld0 = a & b;
//     assign ld1 = a | b;
//     assign ld2 = ~(a & b);
//     assign ld3 = ~(a | b);
//     assign ld4 = a ^ b;
//     assign ld5 = ~a;
// endmodule
