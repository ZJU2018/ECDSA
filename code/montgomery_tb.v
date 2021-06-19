`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/01 19:50:35
// Design Name: 
// Module Name: montgomery_tb
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


module montgomery_tb(

    );
    
    reg clk;
    reg reset;
    reg [255:0]a;
    reg [255:0]b;
    reg [255:0]n;
    reg [255:0]s;
    reg [7:0]k;
    wire [255:0]c;
    wire done;
    
    montgomery mont_inst(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .n(n),
        .s(s),
        .k(k),
        .c(c),
        .done(done)
    );
    
    always begin
        #10
        clk = ~clk;
    end
    
    initial begin
        clk = 0;
        reset = 1;
        a = 357588;
        b = 543191;
        n = 10000019;
        s = 101;
        k = 4;
        #20
        reset = 0;
        #20
        reset = 1;
    end
    
endmodule
