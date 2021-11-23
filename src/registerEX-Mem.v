/******************************************************************
* Description
*	This the basic register that is used in the register file
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module RegisterEX_MEM
#(
	parameter initvalue = 0
)
(
	input clk,
	input reset,
	input enable,
	input Orgate_in,
	input Jalr_in,
	input Zero_in,
	input MemRead_in,
	input MemWrite_in,
	input MemToReg_in,
	input RegWrite_in,
	input [31:0] ADDER_PC_PLUS_INMM_in,
	input [4:0]  RD_in,
	input [31:0] Rd2_in,
	input [31:0] ALU_result_in,


	output reg [107:0] DataOutEX_MEM
	
);
wire [107:0] datos;

assign datos = {Orgate_in,Jalr_in,Zero_in,ADDER_PC_PLUS_INMM_in,RegWrite_in,MemRead_in,MemWrite_in,MemToReg_in,RD_in,Rd2_in,ALU_result_in};

always@(negedge reset or negedge clk) 
	begin
		if(reset==0)
			DataOutEX_MEM<=initvalue;
		
		else	
		if(enable==1)
			DataOutEX_MEM<=datos;
	end
endmodule