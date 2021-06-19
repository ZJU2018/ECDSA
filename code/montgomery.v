`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 21:14:12
// Design Name: 
// Module Name: montgomery
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


module montgomery #(parameter v = 16)(
    input   wire    clk,
    input   wire    reset,
    input   wire    [255:0]a,
    input   wire    [255:0]b,
    input   wire    [255:0]n,
    input   wire    [255:0]s,       // -n^-1 mod r
    input   wire    [7:0]k,         // r^k > n
    output  reg     [255:0]c,       // a*b*r^-k mod n
    output  reg     done
    );
    
    parameter [31:0]r = 1 << v;           // r = 2 ^ 7;
    reg [v-1:0]q;
    reg [8:0]count;
    reg [255:0]b_temp;
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            count <= {k[7:0], 1'b1};
        end
        else if(count == 0)begin
            count <= count;
        end
        else if(~done)begin
            count <= count - 1;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            b_temp <= b;
        end
        else if(~count[0])begin
            b_temp <= b_temp >> v;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            c <= 0;
        end
        else if (count == 0)begin
            c <= c > n ? c - n : c;
        end
        else if(~count[0])begin
            c <= (c + a * b_temp[v-1:0] + q * n) >> v;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            q <= 0;
        end
        else if(count == 0)begin
            q <= q;
        end
        else if(count[0])begin
            q <= (a[v-1:0] * b_temp[v-1:0] + c[v-1:0]) * s;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            done <= 0;
        end
        else if(count == 0)begin
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
    
endmodule
