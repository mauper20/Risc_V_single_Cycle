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
	input [N-1:0]pc_in,
	input [N-1:0] DataInput,
	
	
	output reg [N-1:0] DataOutput,
	output reg [N-1:0] pc_out
);

always@(negedge reset or negedge clk) 
	begin
			if(reset==0)
				begin
					DataOutput <= initvalue;
					pc_out<= initvalue;
				end
			else	
			if(enable==1)
				begin
					DataOutput<=DataInput;
					pc_out<= pc_in;
				end
	end
endmodule