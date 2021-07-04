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
// Description: stage1:mul,stage2:add
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
    output  reg     [319:0]out,     //[271:0]
    output  reg     done
    );
    
    reg     [15:0]count;
    reg     [255:0]temp_b;
    reg     [15:0]in1, in2, in3, in4;
    wire    [31:0]temp1, temp2, temp3, temp4;
    reg     [63:0]mul_reg1, mul_reg2;
    wire    [15:0]out1, out2, out3, out4;
    wire    done1, done2, done3, done4;
    wire    mul_ready, add_ready;
    wire    mul_done, add_done;
    wire    c1, c2, c3, c4;
    
    assign mul_done = done1 & done2 & done3 & done4;
    assign mul_ready = mul_done & add_ready;
    assign add_done = (count[1:0] == 3);
    assign add_ready = add_done;
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            temp_b <= b;
        end
        else if(mul_done)begin
            temp_b <= temp_b >> 64;
        end
    end
    
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
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            in1 <= 0;
            in2 <= 0;
            in3 <= 0;
            in4 <= 0;
        end
        else if(mul_ready)begin
            in1 <= temp_b[15:0];
            in2 <= temp_b[31:16];
            in3 <= temp_b[47:32];
            in4 <= temp_b[63:48];
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            mul_reg1 <= 0;
            mul_reg2 <= 0;
        end
        else if(mul_done)begin
            mul_reg1 <= {temp3 , temp1};
            mul_reg2 <= {temp4 , temp2};
        end
    end
    
    adder_16 adder_1(
        .a(mul_reg1[15:0]),
        .b(mul_reg2[63:48]),
        .cin(c4),
        .s(out1[15:0]),
        .cout(c1)
    );

    adder_16 adder_2(
        .a(mul_reg1[31:16]),
        .b(mul_reg2[15:0]),
        .cin(c1),
        .s(out2[15:0]),
        .cout(c2)
    );

    adder_16 adder_3(
        .a(mul_reg1[47:32]),
        .b(mul_reg2[31:16]),
        .cin(c2),
        .s(out3[15:0]),
        .cout(c3)
    );
    
    adder_16 adder_4(
        .a(mul_reg1[63:48]),
        .b(mul_reg2[47:32]),
        .cin(c3),
        .s(out4[15:0]),
        .cout(c4)
    );

    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            out <= 0;
        end
        else if(add_done)begin
            out <= {c4, c3, c2, c1, out[319:64]};
        end
    end

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
            done <= 0;
        end
        else if(count > 85)begin                //XXX
            count <= count + 1;
        end
    end

endmodule
