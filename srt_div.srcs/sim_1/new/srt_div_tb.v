`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2022 05:08:00 PM
// Design Name: 
// Module Name: srt_div_tb
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


module srt_div_tb();

    reg clk, rst;
    reg ivalid;
    wire ovalid;
    reg [11:0] dividend, divisor;
    wire [11:0] quie;
    wire [4:0] quie_exp;
    
    always #5 clk <= ~clk;
    
    srt_div srt_div_inst(
        .clk(clk),
        .rst(rst),
        .ivalid(ivalid),
        .dividend(dividend),
        .divisor(divisor),
        .quie_exp(quie_exp),
        .quie(quie),
        .ovalid(ovalid)
    );
    
    initial begin
        clk <= 1'b0; rst <= 1'b1; ivalid <= 1'b0;
        dividend <= 12'b0; divisor <= 12'b0;
        #20;
        rst <= 1'b0; ivalid <= 1'b1;
        dividend <= 12'b010000100000;
        divisor <= 12'b010000000111;
    end

endmodule
