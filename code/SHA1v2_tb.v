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
// message : 0x535a414130573839466372514e5870776d3964504c44584258755a3663735a694e73474c6d473255436d726a71647756313752495753796b46303745676a324c57496a515738755078424630415639486b49374f5a4d5770454a784b6579734647474e65446a32786c4b5759456f587a384953394734488000000000000003b8
// hash : 73316ab3672083b39ee391d5d9f3d03ed5767bc3
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
    reg   w_en;
    
    SHA1  SHA1_inst (
        .clk(clk),
        .reset(reset),
        .start(start),
        .block_num(64'd2),
        .w_en(w_en),
        .msg(in),
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
        w_en = 1;
        in = 512'h535a414130573839466372514e5870776d3964504c44584258755a3663735a694e73474c6d473255436d726a71647756313752495753796b46303745676a324c；
        #20
        in = 512'h57496a515738755078424630415639486b49374f5a4d5770454a784b6579734647474e65446a32786c4b5759456f587a384953394734488000000000000003b8;
        #20
        w_en =0;
        #100
        start = 1;
        #20 
        start = 0;
        
    end
    
    always begin
        #10
        clk = ~clk;
    end
    
endmodule
