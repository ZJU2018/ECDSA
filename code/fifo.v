`timescale 1ns/1ns

module fifo(clk,rst_n,w_en,data_w,r_en,data_r,empty,full,half_full,overflow);

input clk,rst_n,w_en,data_w,r_en;
output data_r,empty,full,half_full,overflow;

//the regisiter:length 8,deepth 16
reg [7:0] memery [0:15];

//the finger for write and read
reg [4:0] r_ptr = 5'b0;
reg [4:0] w_ptr = 5'b0;

wire clk,rst_n,w_en,r_en;

//the data you want to write
wire [7:0] data_w;
//the data read out from regisiter
reg [7:0] data_r;

wire empty,full,half_full;
reg overflow = 0;


/*only use to change w_ptr(the finger for write,when rst_n ==0,reset:w_ptr = 0,when rst_n==1 and w_en==1 and full==0,w_ptr++
else don't change it"*/
always @(posedge clk or negedge rst_n)
 begin
  if(!rst_n)
     w_ptr <= 5'b0;
  else if(w_en && !full)
     w_ptr <= w_ptr +1;
  else 
     w_ptr <= w_ptr;
end

/*only use to change r_ptr(the finger for read,when rst_n ==0 reset:w_ptr = 0,when rst_n==1 and r_en==1 and empty==0,r_ptr++
else don't change it"*/
always @(posedge clk or negedge rst_n)  
begin 
   if(!rst_n)
  begin
     r_ptr <= 5'b0;
  end
  else if(r_en && !empty)
     r_ptr <= r_ptr +1;
  else 
     r_ptr <= r_ptr;
end

//only use to write data,when clk's posedge,if w_en==1 and full==0,write data in  regisiter
always @(posedge clk or negedge rst_n) 
begin
  if(w_en && !full)
      memery[w_ptr[3:0]] <= data_w;
end

//only use to write data,when clk's posedge,if r_en==1 and emoty==0,read data from  regisiter,else ,set data_r as 0
always @(posedge clk or negedge  rst_n) 
begin
  if(!rst_n)
     data_r <= 0;
  else if(r_en && !empty)
     data_r <= memery[r_ptr[3:0]];
  else
     data_r <= 0;
end


//only use to judge overflow,when regisiter is full,and the user want to continue to write data in regisiter,change overflow from 0 to 1

always @(posedge clk or negedge  rst_n) 
begin
   if(!rst_n)
       overflow <= 0;
  else if(full && w_en)
       overflow <= 1;
 else
      overflow <= 0;
end


//the combinational logic circuit to set empty,full and half_full signals
assign empty = (w_ptr == r_ptr) ? 1 : 0;
assign full = (w_ptr[3:0] == r_ptr[3:0] && w_ptr[4] != r_ptr[4]) ? 1 : 0;
assign half_full = (w_ptr - r_ptr == 8) ? 1 : 0; 

endmodule
