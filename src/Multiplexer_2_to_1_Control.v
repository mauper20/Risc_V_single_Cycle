

module Multiplexer_2_to_1_Control
#(
	parameter NBits = 11
)
(   
	input Selector_i,
	input MemRead_in,
	input MemWrite_in,
	input MemToReg_in,
   input RegWrite_in,
	input AluSrc_in,
	input Jalr,
	input Branch,
	input Jal,
	input [2:0]  ALUOp_in,
	
	output reg [NBits-1:0] Mux_Output_o

);
wire [10:0] datos;

assign datos = {Branch,Jal,Jalr,MemRead_in,MemWrite_in,MemToReg_in,RegWrite_in,AluSrc_in,ALUOp_in};

	always@(Selector_i ,datos) begin
		if(Selector_i)
			Mux_Output_o = 0;
		else
			Mux_Output_o = datos;
	end

endmodule