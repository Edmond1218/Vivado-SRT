`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2022 02:13:18 PM
// Design Name: 
// Module Name: srt_div
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


module srt_div(
    input rst,
    input clk,
    input [11:0] dividend,
    input [11:0] divisor,
    input ivalid,
    output reg [11:0] quie,
    output reg signed [4:0] quie_exp,
    output reg ovalid
    );
    
    reg ss;
    reg [11:0] accA, accQ;
    reg [2:0] state;
    reg [4:0] step_cnt;
    reg [11:0] dividend_tmp, divisor_tmp;
    
    always @(posedge clk or posedge rst) begin
        if(rst == 1'b1) begin
            ss <= 1'b0;
            accA <= 12'b0;
            accQ <= 12'b0;
            step_cnt <= 5'b0;
            state <= 3'b0;
            dividend_tmp <= 12'b0;
            divisor_tmp <= 12'b0;
            ovalid <= 1'b0;
            quie <= 12'b0;
            quie_exp <= 5'b0;
        end
        else begin
            case(state)
                3'b000: begin
                    if(ivalid == 1'b1) begin
                        state <= 3'b001;
                        dividend_tmp <= dividend;
                        divisor_tmp <= divisor;
                        ovalid <= 1'b0;
                        quie <= 12'b0;
                        accA <= 12'b0;
                        accQ <= 12'b0;
                        ss <= 1'b0;
                        quie_exp <= 5'b0;
                    end
                    else begin
                        ovalid <= 1'b0;
                    end
                end
                3'b001: begin // initialize
                    if(dividend_tmp == divisor_tmp) begin // when dividend == divisor, output = 1
                        state <= 3'b111;
                        accA <= 12'b0;
                        accQ <= 12'b1;
                    end
                    else begin
                        accA <= dividend_tmp[11];
                        dividend_tmp <= {dividend_tmp[10:0], 1'b0};
                        quie_exp <= 5'd12; 
                        step_cnt <= 5'b00001;
                        accQ <= 12'b0;
                        state <= 3'b010;
                    end
                end
                3'b010: begin // left shift until A is bigger than M
                    if(accA >= divisor_tmp) begin
                        state <= 3'b011;
                        step_cnt <= 5'b0;
                    end
                    else begin
                        accA <= {accA, dividend_tmp[11]};
                        dividend_tmp <= {dividend_tmp[10:0], 1'b0};
                        quie_exp <= quie_exp - 1'b1;
                    end
                end
                3'b011: begin // A - M
                    if(ss == 1'b0) accA <= accA - divisor_tmp;
                    else accA <= accA + divisor_tmp;
                    state <= 3'b100;
                end
                3'b100: begin // until Q mantissa bit become 11
                    ss <= accA[11];
                    step_cnt <= step_cnt + 1'b1;
                    quie_exp <= quie_exp - 1'b1;
                     if(step_cnt == 5'd10) begin
                        state <= 3'b111;
                    end
                    else begin
                        state <= 3'b101;
                    end
                end
                3'b101: begin // Q[0] set and left shift A
                    accQ <= {accQ[10:0], ~ss};
                    accA <= {accA, dividend_tmp[11]};
                    dividend_tmp <= {dividend_tmp[10:0], 1'b0};
                    state <= 3'b011;
                end
                3'b111: begin // output
                    ovalid <= 1'b1;
                    quie <= {accQ[10:0], ~ss};
                    state <= 3'b000;
                end
                default: begin
                    ovalid <= 1'b0;
                end
            endcase
        end
    end
    
endmodule
