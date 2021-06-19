`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 16:12:04
// Design Name: 
// Module Name: inverse_tb
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


module inverse_tb(

    );
    
    reg clk;
    reg reset;
    reg [255:0]n;
    reg [255:0]r;
    wire [255:0]s;
    wire done;
    
    inverse inverse_inst(
        .clk(clk),
        .reset(reset),
        .n(n),
        .r(r),
        .s(s),
        .done(done)
    );
    
    initial begin
        clk = 0;
        reset = 1;
        n = 512'd10000019;
        r = 512'd128;
        #100
        reset = 0;
        #100
        reset = 1;
    end
    
    always begin
        #10
        clk = ~clk;
    end
    
    
endmodule
