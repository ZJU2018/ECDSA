`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/27 21:50:12
// Design Name: 
// Module Name: SHA1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: accepts input blocks and processes them 
//              one chunk at a time until the whole message is added to the hash.
// sha-1
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module my_sha1
(
    input   wire    clk,
    input   wire    reset,
    input   wire    start,
    input   wire    [63:0] length,
    input   wire    [511:0] msg,            // input from ram
    output  wire    [159:0] hash,
    output  reg     next,                   // output to ram reader
    output  reg     done
);

reg     [55:0]count;
reg     [511:0]block_data;
reg     next_block_start;
wire    [8:0]last_length = length[8:0];
wire    block_done;

assign last_length = length[8:0];

hash hash_inst(
    .clk(clk), 
    .reset(reset), 
    .start(next_block_start),
    .in(block_data), 
    .hash(hash), 
    .done(block_done)
);

always@(posedge clk or negedge reset)begin
    if(~reset)begin
        if(last_length > 9'd446)begin
            count <= length[63:9] + 2'd2;
        end
        else begin
            count <= length[63:9] + 2'd1;
        end
    end
    else if(block_done)begin
        count <= count - 1'b1;
    end
    else begin
        count <= count;
    end
end

always@(posedge clk or negedge reset)begin
    if(~reset)begin
        block_data <= 0;
    end
    else if(count != 0)begin
        block_data <= msg;
    end
    else if(last_length == 0)begin
        block_data[511] <= 1;
        block_data[510:64] <= 0;
        block_data[63:0] <= length;
    end
    else begin
        block_data[511:64] = msg[511:64];
        block_data[63:0] <= length;
        block_data[511-last_length] <= 1'b1;                            // FIXME:need to be done before ram writer
        //block_data[511:512-last_length] <= msg[511:512-last_length];
        //block_data[511-last_length] <= 1'b1;
        //block_data[510-last_length : 64] <= 0;
        //block_data[63:0] <= length;
    end
    
end

always@(posedge clk or negedge reset)begin
    if(~reset)begin
        next_block_start <= 0;
    end
    else if(start | block_done)begin
        next_block_start <= 1;
    end 
    else begin
        next_block_start <= 0;
    end
end

always @(posedge clk or negedge reset) begin
    if(~reset)begin
        next <= 0;
    end
    else if(count != 0 && block_done)begin          // to get next 512bits
        next <= 1;
    end
    else begin
        next <= 0;
    end
end

always @(posedge clk or negedge reset) begin
    if(~reset)begin
        done <= 0;
    end
    else if(count == 0 && block_done)begin
        done <= 1;
    end
    else begin
        done <= 0;
    end
end

endmodule

