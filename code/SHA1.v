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
module SHA1#(parameter last_length = 9'd446)
(
    input   wire    clk,
    input   wire    reset,
    input   wire    start,
    input   wire    [63:0]  length,
//   input   wire    last,
//    input   wire    [8:0]   last_length,
    input   wire    [511:0] msg,            // input from ram
    output  wire    [159:0] hash,
    output  reg     next,                   // output to ram reader
    output  reg     done
);

reg     [55:0] count;
reg     [511:0] block_data;
wire    block_done;
reg    [1023:0] padding1;// use for last length > 447
reg    [511:0]  padding2;//use for last length <=447
wire    next_block_start;
reg     next_block_start_reg;

hash hash_inst(
    .clk(clk), 
    .reset(reset), 
    .start(next_block_start_reg),
    .in(block_data), 
    .hash(hash), 
    .done(block_done)
);


always@(posedge clk or negedge reset)begin
    if(~reset)begin
        if(last_length > 9'd447)begin
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

always@(negedge clk or negedge reset)begin
    if(~reset)begin
        block_data <= 0;
    end
    else if(next_block_start && count == 56'd2)
        if(last_length <= 9'd447)
            block_data <= msg;
        else
            block_data <= padding1[1023:512];
    else if(next_block_start && count == 56'd1)
        if(last_length <= 9'd447)
            block_data <= padding2;
        else
            block_data <= padding1[511:0];
    else if(next_block_start && count !=56'd1 && count !=56'd2)
        block_data <= msg;
    else
        block_data <= block_data;
end

// always@(posedge clk or negedge reset)begin
//     if(~reset)begin
//         next_block_start <= 0;
//     end
//     else if(start | block_done)begin
//         next_block_start <= 1;
//     end 
//     else begin
//         next_block_start <= 0;
//     end
// end
always @(negedge clk) begin
    next_block_start_reg <= next_block_start;
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


always @(*) begin
    if(last_length == 9'd447)begin
        padding2[511:65] = msg[446:0];
        padding2[64] = 1'b1;
        padding2[63:0] = length;
    end
    else if(last_length < 9'd447)begin
        padding2[511:511-last_length+1] = msg[last_length-1:0];
        padding2[511-last_length] = 1'b1;
        padding2[511-last_length-1:64] = 0;
        padding2[63:0] = length;
    end
        padding1[1023:1023-last_length+1] = msg[last_length-1:0];
        padding1[1023-last_length] = 1'b1;
        padding1[1023-last_length-1:64] = 0;
        padding1[63:0] = length;

end

assign next_block_start = start || block_done;

endmodule

