/******************************************************************
* Description
*	This is a register of 32-bit that corresponds to the PC counter. 
*	This register does not have an enable signal.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module PC_Register
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input  [N-1:0] Next_PC,
	input stall,
	
	output reg [N-1:0] PC_Value
);

always@(negedge reset or negedge clk) begin
	if(reset==0)
		PC_Value <= 4194304; //se inicio el pc register en h400000
	else if(stall==0)
		PC_Value<= Next_PC;
	else if(stall==1)
	   PC_Value<= PC_Value;
end

endmodule
