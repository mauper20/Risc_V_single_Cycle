module RegisterIDEX
#(
	parameter initvalue = 0
)
(
	input clk,
	input reset,
	input enable,
	input  [31:0] DataInputR1,
	input  [31:0] DataInputR2,
	input  [4:0] DataInputRD,
	input  [31:0] DataInputI,
	input Mem_Read_o,
	input Mem_to_Reg_o,
	input Mem_Write_o,
	input ALU_Src_o,
	input Reg_Write_o,
	input [2:0]ALU_Op_o,
	input funct7_i,
	input [2:0]funct3_i,
	
	
	output reg [112:0] DataOutput
);
wire [112:0] datos;

assign datos = {Reg_Write_o,DataInputR1,DataInputR2,DataInputRD,DataInputI,Mem_Read_o,Mem_to_Reg_o,Mem_Write_o,ALU_Src_o,funct7_i,funct3_i,ALU_Op_o};

always@(negedge reset or negedge clk) begin
	if(reset==0)
		DataOutput<=initvalue;
		
	else	
		if(enable==1)
			DataOutput<=datos;
			
			
end

endmodule