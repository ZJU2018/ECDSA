`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/16 21:22:01
// Design Name: 
// Module Name: adder256_tb
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


module adder256_tb(

    );
    
    reg     clk;
    reg     reset;
    reg     [255:0]a;
    reg     [255:0]b;
    reg     valid_in;
    reg     ready_in;
    wire    [255:0]s;
    wire    cout;
    wire    ready_out;
    
    adder_256 adder_256_inst(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .valid_in(valid_in),
        .ready_in(ready_in),
        .s(s),
        .cout(cout),
        .ready_out(ready_out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
    reset = 0;
    repeat(10) @(posedge clk);
    reset = 1'b1;
    a = 256'h1111111111111;
    b = 256'hffffffffffffffffffffffffffffffffffffffffff;
    valid_in = 1'b1;
    ready_in = 1'b1;
    #40;
    ready_in = 0;
    #40;
    ready_in = 1 ;
    #40;
    a = 256'h111111111111111111111111111;
    b = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    #40;
    a = 256'h1111111111111111111111111111111111111111111111111111;
    b = 256'hfffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    repeat(10) @(posedge clk);
    end
    
endmodule
