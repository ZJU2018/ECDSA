`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/04 19:54:56
// Design Name: 
// Module Name: adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 4 stages pipeline
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder_256(
    input   wire    clk,
    input   wire    reset,
    input   wire    [255:0]a,
    input   wire    [255:0]b,
    //input   wire    cin,
    input   wire    valid_in,
    input   wire    ready_in,
    output  reg     [255:0]s,
    output  reg     cout,
    output  wire    ready_out     
    );
    
    wire    [255:0]sum0, sum1, sum2, sum3;
    reg     [255:0]sum0_r, sum1_r, sum2_r;
    wire    c0, c1, c2, c3;
    reg     valid_s0, valid_s1, valid_s2, valid_s3;
    reg     valid_o0, valid_o1, valid_o2, valid_o3;
    wire    ready_s0, ready_s1, ready_s2, ready_s3;
    wire    ready_o0, ready_o1, ready_o2;
    wire    en0, en1, en2, en3;
    
    assign en0 = valid_s0 & ready_o0;
    assign en1 = valid_s1 & ready_o1;
    assign en2 = valid_s2 & ready_o2;
    assign en3 = valid_s3 & ready_out;
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            valid_s0 <= 0;
            valid_s1 <= 0;
            valid_s2 <= 0;
            valid_s3 <= 0;
            valid_o0 <= 0;
            valid_o1 <= 0;
            valid_o2 <= 0;
            valid_o3 <= 0;
        end
        else if(valid_in)begin
            valid_s0 <= valid_in;
            valid_s1 <= valid_o0 ? valid_in : valid_s1;
            valid_s2 <= valid_o1 ? valid_in : valid_s2;
            valid_s3 <= valid_o2 ? valid_in : valid_s3;
            valid_o0 <= en0 ? valid_s0 : valid_o0;
            valid_o1 <= en1 ? valid_s1 : valid_o1;
            valid_o2 <= en2 ? valid_s2 : valid_o2;
            valid_o3 <= en3 ? valid_s3 : valid_o3;
        end
    end
    
    assign ready_o0 = ready_s0;
    assign ready_o1 = ready_s1;
    assign ready_o2 = ready_s2;
    assign ready_out = ready_in;
    assign ready_s0 = ready_o1;
    assign ready_s1 = ready_o2;
    assign ready_s2 = ready_out;
    //assign ready_s3 = ready_s3;
    
    assign {c0, sum0} = a[63:0] + b[63:0];
    assign {c1, sum1} = a[127:63] + b[127:63] + c0;
    assign {c2, sum2} = a[191:128] + b[191:128] + c1;
    assign {c3, sum3} = a[255:192] + b[255:192] + c2;
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            sum0_r <= 0;
            sum1_r <= 0;
            sum2_r <= 0;
        end
        else begin
            sum0_r <= en0 ? sum0 : sum0_r;
            sum1_r <= en1 ? sum1 : sum1_r;
            sum2_r <= en2 ? sum2 : sum2_r;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            s <= 0;
            cout <= 0;
        end
        else begin
            s <= en3? {sum3, sum2, sum1, sum0} : s;
            cout <= en3? c3 : cout;
        end
    end
    
endmodule
