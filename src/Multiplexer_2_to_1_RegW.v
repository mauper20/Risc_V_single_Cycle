

module Multiplexer_2_to_1_RegW
(   
	input Selector_i,
	input  Mux_Data_0_i,
	input  Mux_Data_1_i,
	
	output reg Mux_Output_o

);

	always@(Selector_i ,Mux_Data_1_i ,Mux_Data_0_i) begin
		if(Selector_i)
			Mux_Output_o = Mux_Data_1_i;
		else
			Mux_Output_o = Mux_Data_0_i;
	end

endmodule