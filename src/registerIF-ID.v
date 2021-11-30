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
module RegisterIF_ID
#(
	parameter N = 32,
	parameter initvalue = 0
)
(
	input clk,
	input reset,
	input enable,
	input [31:0]pc_in,
	input [31:0] DataInput,
	input Flush,
	input [31:0]PC,
	input [31:0]PCplusI,
	input [31:0]PCplus4,
	
	output reg [127:0] DataOutput,
	output reg [31:0] pc_out
);
wire [127:0] datos;
assign datos = {PCplus4,PC,PCplusI,DataInput};

always@(negedge reset or negedge clk) 
	begin 
			if(reset==0)
				begin
					DataOutput <= initvalue;
					pc_out<= pc_in;
				end
			else
			if(Flush==1)
				begin
					DataOutput <= 0;//initvalue;
					pc_out<= pc_in;
				end
			else	
			if(enable==0)//0
				begin
					DataOutput<=datos;
					pc_out<= pc_in;
				end
	end
endmodule