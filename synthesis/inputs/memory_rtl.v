//Memory of 1Kb having a width of 16bits
//Size=1Kb=1*1024=1024
//Width=16
//Depth=64
//Addr_width=$clog2(Depth)=6
//Input: clk,reset,valid,addr,wdata,wr_rd
//output:ready,rdata

`timescale 1ns/1ns
module memory(clk_i,reset_i,valid_i,addr_i,wdata_i,wr_rd_i,ready_o,rdata_o);

parameter WIDTH=16;
parameter DEPTH=16;
parameter ADDR_WIDTH=$clog2(DEPTH);

input wire clk_i;
input wire reset_i;
input wire valid_i;
input wire [ADDR_WIDTH-1:0]addr_i;
input wire [WIDTH-1:0]wdata_i;
input wire wr_rd_i;

output reg ready_o;
output reg [WIDTH-1:0]rdata_o;

integer i;

reg [WIDTH-1:0]mem[DEPTH-1:0];

always@(posedge clk_i)begin
	if(reset_i==1)begin	//Here we are using active high reset ,so we are making all my register to zero.(deassering) at reset=1
		ready_o=0;	//Deasserting ready register
		rdata_o=0; //Deasserting rdata register
		for(i=0;i<DEPTH;i=i+1) mem[i]=0; //Deasserting Memory
	end
	else begin
		if(valid_i==1)begin	//Master is doing valid transaction
			ready_o=1;	//slave is ready to do valid transaction
			if(wr_rd_i==1)	mem[addr_i]=wdata_i;	// writing to the memory
			else 			rdata_o=mem[addr_i];	// read from the memory
		end
		else begin 
			ready_o=0;	// master is not doing valid transaction so slave will won't shakehand.
			rdata_o=0;
		end
	end
end
endmodule
