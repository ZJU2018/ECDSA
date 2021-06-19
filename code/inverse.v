`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 15:52:38
// Design Name: 
// Module Name: inverse
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


module inverse #(parameter v = 16)(
    input   wire    clk,
    input   wire    reset,
    input   wire    [255:0]n,
    input   wire    [v:0]r,
    output  reg     [v-1:0]s,           // s = - n ^ -1 mod r
    output  reg     done
);
    reg [v-1:0]temp;
    reg [v:0]rv;
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            rv <= r;
        end
        else if(~rv[1])begin
            rv <= {1'b0, rv[v:1]};
        end
        else begin
            rv = rv;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            temp <= 1;
        end
        else if(~rv[1])begin
            temp <= temp * temp * n[v-1:0];
        end 
        else begin
            temp <= temp;
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            s <= 0;
        end
        else if(rv[1])begin
            s <= r - temp;                // ~temp & (r - 1) + 1
        end
    end
    
    always@(posedge clk or negedge reset)begin
        if(~reset)begin
            done <= 0;
        end
        else if(rv[1])begin
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
    
endmodule
