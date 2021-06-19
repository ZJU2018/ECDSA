`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/19 19:54:36
// Design Name: 
// Module Name: mul_8x8
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


module mul_8x8(
    //input   wire    clk,
    //input   wire    reset,
    input   wire    [7:0]a,
    input   wire    [7:0]b,
    output  wire    [15:0]out
    //output  reg     done
    );
    
    assign out = a * b;
    
endmodule
