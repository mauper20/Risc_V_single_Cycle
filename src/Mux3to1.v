/******************************************************************
* Description
*	This is a 2 to 1 multiplexer that can be parameterized in its bit-width.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module Multiplexer_3_to_1
#(
	parameter NBits = 32
)
(   
	input [1:0]Selector_i,
	input [NBits-1:0] Mux_Data_0_i,
	input [NBits-1:0] Mux_Data_1_i,
	input [NBits-1:0] Mux_Data_2_i,

	output [NBits-1:0] Mux_Output_o

);

    assign Mux_Output_o=(Selector_i==2'b00)?Mux_Data_0_i:
								(Selector_i==2'b01)?Mux_Data_1_i:
								(Selector_i==2'b10)?Mux_Data_2_i:32'b0000_0000_0000_0000_0000_0000_0000_0000;

endmodule