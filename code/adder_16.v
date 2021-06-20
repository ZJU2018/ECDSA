`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/20 19:13:30
// Design Name: 
// Module Name: adder_16
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


module adder_16(
    input   wire    [15:0]a,
    input   wire    [15:0]b,
    input   wire    cin,
    output  wire    [15:0]s,
    output  wire    cout
    );
    
    assign {cout, s} = a + b + cin;
    
endmodule
