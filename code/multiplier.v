`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/04 14:11:14
// Design Name: 
// Module Name: multiplier
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


module multiplier #(parameter length = 16)(
    input   wire    clk,
    input   wire    [length-1:0]a,
    input   wire    [length-1:0]b,
    output  reg     [length-1:0]c
    );
    
    always@(posedge clk)begin
        c <= a * b;
    end
    
endmodule
