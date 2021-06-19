`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 15:22:14
// Design Name: 
// Module Name: hash_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// message : 0x394e78564f787e526c6e4346407228544d3664466421435948347956544c28554f37375821725036434e78506b32733941555036444d248000000000000001b8
//             394e78564f787e526c6e4346407228544d3664466421435948347956544c28554f37375821725036434e78506b32733941555036444d24
// hash : 35e71184e119a78af13dc1d80274ab47c998d1c9
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hash_tb(

    );
    
    reg clk;
    reg reset;
    reg start;
    reg [511:0]in;
    wire    [159:0] hash;
    
    hash hash_inst(
        .clk(clk),
        .reset(reset),
        .start(start),
        .in(in),
        .hash(hash),
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

        #2000
        start = 1;
        in = 512'h394e78564f787e526c6e4346407228544d3664466421435948347956544c28554f37375821725036434e78506b32733941555036444d248000000000000003b8;
        #20
        start = 0;
    end
    
    always begin
        #10
        clk = ~clk;
    end
    
endmodule
