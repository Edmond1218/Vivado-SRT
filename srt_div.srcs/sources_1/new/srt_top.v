`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2022 07:07:17 PM
// Design Name: 
// Module Name: srt_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module srt_top(
    input rst,
    input clk,
    input [15:0] dividend,
    input [15:0] divisor,
    input ivalid,
    output [15:0] quie,
    output ovalid
    );
    
    wire [11:0] dividend1, divisor1;
    wire dividend_ss, divisor_ss;
    wire quie_ss;
    wire [11:0] quie1;
    wire signed [4:0] quie_exp1, quie_exp;
    wire signed [4:0] divisor_exp, dividend_exp;
    wire dividend_zflg, dividend_nflg;
    wire divisor_zflg, divisor_nflg;
    wire nflg;
    
    assign nflg = dividend_nflg | divisor_nflg; // dividend is NaN or divisor is NaN
    assign dividend_zflg = (dividend[14:0] == 15'b000000000000000)? 1'b1: 1'b0; // dividend is zero
    assign dividend_nflg = (dividend[14:10] == 5'b11111)? 1'b1: 1'b0; //dividend is NaN
    assign divisor_zflg = (divisor[14:0] == 15'b000000000000000)? 1'b1: 1'b0; // divisor is zero
    assign divisor_nflg = (divisor[14:10] == 5'b11111)? 1'b1: 1'b0; // divisor is NaN
    
    assign dividend1 = {1'b0, 1'b1, dividend[9:0]}; // dividend mantissa
    assign divisor1 = {1'b0, 1'b1, divisor[9:0]}; // divisor mantissa
    assign quie_ss = dividend[15] ^ divisor[15]; // quie sign bit
    assign dividend_exp = {1'b0, dividend[14:10]} - 5'b01111; // dividend exponent
    assign divisor_exp = {1'b0, divisor[14:10]} - 5'b01111; // divisor exponent
    
    srt_div srt_div_inst(
        .rst(rst),
        .clk(clk),
        .dividend(dividend1),
        .divisor(divisor1),
        .ivalid(ivalid),
        .ovalid(ovalid),
        .quie(quie1),
        .quie_exp(quie_exp1)
    );
    
    // calculation quie exponent 
    assign quie_exp = quie_exp1 + dividend_exp - divisor_exp + 5'b01111 + 5'd10;
    
    // when divisor and dividend is NaN, Zero, quie is NaN or zero.
    assign quie = (divisor_zflg == 1'b1)? 16'b0111110000000001: (dividend_zflg == 1'b1)? 16'b0000000000000000: (nflg == 1'b1)? 16'bz: {quie_ss, quie_exp, quie1[9:0]};
    
endmodule
