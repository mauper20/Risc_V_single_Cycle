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
module RegisterMEM_WB
#(
	parameter initvalue = 0
)
(
	input clk,
	input reset,
	input enable,
	input MemWrite_in,
	input MemRead_in,
	input MemToReg_in,
	input RegWrite_in,
	input [4:0]  RD_in,
	input [31:0] ReadData_in,
	input [31:0] ALU_result_in,

	output reg [70:0]DataOutMEM_WB
);
wire [70:0] datos;
assign datos = {RegWrite_in,MemToReg_in,RD_in,ReadData_in,ALU_result_in};

always@(negedge reset or negedge clk) 
	begin
		if(reset==0)
			DataOutMEM_WB<=initvalue;
		
		else	
		if(enable==1)
			DataOutMEM_WB<=datos;
	end
endmodule