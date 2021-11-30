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
module RegisterID_EX
#(
	parameter initvalue = 0
)
(
	input clk,
	input reset,
	input enable,
	input [4:0] ID_EXRs1_in,
	input [4:0] ID_EXRs2_in,
	input [31:0]pc_in,
	input [2:0]func3_in,
	input func7_in,
	input Branch_in,
	input MemRead_in,
	input MemWrite_in,
	input MemToReg_in,
   input RegWrite_in,
	input AluSrc_in,
	input Jalr_in,
	input Jal_in,
	input [2:0]  ALUOp_in,
	input [31:0] Rd1_in,
	input [31:0] Rd2_in,
	input [4:0]  RD_in,
	input [31:0] mm_Unit_in,
	input [31:0]PC,
	input [31:0]PCplus4,
	input Flush,

	output reg [221:0] DataOut_ID_EX
	
);
wire [221:0] datos;

assign datos = {PCplus4,PC,ID_EXRs2_in,ID_EXRs1_in,pc_in,func7_in,func3_in,AluSrc_in,Branch_in,Jalr_in,Jal_in,MemRead_in,MemWrite_in,MemToReg_in,RegWrite_in,ALUOp_in,RD_in,Rd2_in,Rd1_in,mm_Unit_in};

always@(negedge reset or negedge clk) 
	begin
		if(reset==0)
					DataOut_ID_EX<=0;
		else
		if(Flush==1)
					DataOut_ID_EX<=0;
		else	
		if(enable==1)
			DataOut_ID_EX<=datos;//maybe en otro always
	end
endmodule