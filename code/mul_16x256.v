`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/19 21:27:33
// Design Name: 
// Module Name: mul_16x256
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


module mul_16x256(
    input   wire    clk,
    input   wire    reset,
    input   wire    [15:0]a,
    input   wire    [255:0]b,
    output  reg     [271:0]out,
    output  reg     done
    );
    
    reg     [7:0]count;
    reg     [255:0]temp_b;
    reg     [15:0]in1, in2, in3, in4;
    wire    [31:0]temp1, temp2, temp3, temp4, temp;
    wire    [15:0]out1, out2, out3, out4;
    wire    done1, done2, done3, done4;
    wire    c1, c2, c3, c4, temp_c;
    
    mul_16x16 mul_1(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(in1),
        .out(temp1),
        .done(done1)
    );
    
    mul_16x16 mul_2(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(in2),
        .out(temp2),
        .done(done2)
    );
        
    mul_16x16 mul_3(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(in3),
        .out(temp3),
        .done(done3)
    );
    
    mul_16x16 mul_4(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(in4),
        .out(temp4),
        .done(done4)
    );
    
    adder_16 adder_1(
        .a(temp1[15:0]),
        .b(temp[15:0]),
        .cin(temp_c),
        .s(out1[15:0]),
        .cout(c1)
    );

    adder_16 adder_2(
        .a(temp1[31:16]),
        .b(temp2[15:0]),
        .cin(c1),
        .s(out2[15:0]),
        .cout(c2)
    );

    adder_16 adder_3(
        .a(temp3[15:0]),
        .b(temp2[31:16]),
        .cin(c2),
        .s(out3[15:0]),
        .cout(c3)
    );
    
    adder_16 adder_4(
        .a(temp3[15:0]),
        .b(temp3[15:0]),
        .cin(c3),
        .s(out4[15:0]),
        .cout(c4)
    );

    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            count <= 0;
        end
        else if(~done)begin
            count <= count + 1;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            temp_b <= b;
        end
        else if(count[1:0] == 3)begin
            temp_b <= temp_b >> 64;
        end
    end

endmodule
