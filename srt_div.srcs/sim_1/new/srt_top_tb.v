`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2022 04:25:37 PM
// Design Name: 
// Module Name: srt_top_tb
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


module srt_top_tb();

    reg clk, rst;
    reg ivalid;
    wire ovalid;
    wire [15:0] dividend, divisor;
    wire [15:0] quie;
    reg [4:0] dividend_exp, divisor_exp;
    reg [9:0] dividend_man, divisor_man;
    wire [4:0] quie_exp;
    wire [10:0] quie_man;
    
    always #5 clk <= ~clk;
    
    srt_top srt_top_inst(
        .clk(clk),
        .rst(rst),
        .ivalid(ivalid),
        .dividend(dividend),
        .divisor(divisor),
        .quie(quie),
        .ovalid(ovalid)
    );
    
    initial begin
        clk <= 1'b0; rst <= 1'b1; ivalid <= 1'b0;
        #20;
        rst <= 1'b0; ivalid <= 1'b1;
        dividend_exp <= 5'd2 + 5'b01111;
        dividend_man <= 10'b1010000011;
        divisor_exp <= 5'b01111 - 5'd3;
        divisor_man <= 10'b1010100110;
    end
    
    assign dividend = {1'b0, dividend_exp, dividend_man};
    //assign divisor = {1'b1, divisor_exp, divisor_man};
    assign divisor = 16'b0111111000000000;
    assign quie_exp = quie[14:10] - 5'b01111;
    assign quie_man = {1'b1, quie[9:0]};
    
endmodule
