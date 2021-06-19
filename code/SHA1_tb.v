`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 15:22:14
// Design Name: 
// Module Name: SHA1_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// message : 0x394e78564f787e526c6e4346407228544d3664466421435948347956544c28554f37375821725036434e78506b32733941555036444d248000000000000001b8394e78564f787e526c6e4346407228544d3664466421435948347956544c28554f37375821725036434e78506b32733941555036444d248
// hash : 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SHA1_tb(

    );
    
    reg clk;
    reg reset;
    reg start;
    reg [511:0]  in;
    wire    [159:0] hash;
    wire  next;
    reg   last;
    
    SHA1 #(9'd440) SHA1_inst (
        .clk(clk),
        .reset(reset),
        .start(start),
        .length(64'd952),
        //.last(last),
        .msg(in),
        .hash(hash),
        .next(next),
        .done(done)
    );
    
    initial begin
        clk = 0;
        reset = 1;
        #20
        reset = 0;
        #20;
        reset = 1;
        start = 1;
        in = 512'h394e78564f787e526c6e4346407228544d3664466421435948347956544c28554f37375821725036434e78506b32733941555036444d248000000000000001b8; 
        #20
        start = 0;
        last = 1;
        in = 512'h394e78564f787e526c6e4346407228544d3664466421435948347956544c28554f37375821725036434e78506b32733941555036444d24;
 
        
    end
    
    always begin
        #10
        clk = ~clk;
    end
    
endmodule
