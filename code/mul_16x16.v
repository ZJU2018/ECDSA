`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/19 20:06:51
// Design Name: 
// Module Name: mul_16x16
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


module mul_16x16(
    input   wire    clk,
    input   wire    reset,
    input   wire    [15:0]a,
    input   wire    [15:0]b,
    output  reg     [31:0]out,
    output  reg     done
    );
    
    wire    [15:0]m1, m2, m3, m4;
    wire    [9:0]s1, s2;
    wire    [7:0]s3;
    reg     [1:0]count;
    
    mul_8x8 mul_1(
        .a(a[7:0]),
        .b(b[7:0]),
        .out(m1)
    );
    
    mul_8x8 mul_2(
        .a(a[7:0]),
        .b(b[15:8]),
        .out(m2)
    );
        
    mul_8x8 mul_3(
        .a(a[15:8]),
        .b(b[7:0]),
        .out(m3)
    );
    
    mul_8x8 mul_4(
        .a(a[15:8]),
        .b(b[15:8]),
        .out(m4)
    );
    
    assign s1 = m1[15:8] + m2[7:0] + m3[7:0];
    assign s2 = s1[9:8] + m2[15:8] + m3[15:8] + m4[7:0];
    assign s3 = s2[9:8] + m4[7:0];
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            out <= 0;
        end
        else begin
            case(count)
                0: out[7:0] <= m1[7:0];
                1: out[15:8] <= s1[7:0];
                2: out[23:16] <= s2[7:0];
                3: out[31:24] <= s3[7:0];
                default:out <= out;
            endcase
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            done <= 0;
        end
        else if(count == 3)begin
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
    
endmodule
