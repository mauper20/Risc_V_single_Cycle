module RegisterEXMEM
#(
	parameter initvalue = 0
)
(
	input clk,
	input reset,
	input enable,
	input  [31:0] ALUresult,
	input  [31:0] DataInputR2,
	input  [4:0] DataInputRD,
	input Mem_Read_o,
	input Mem_Write_o,
	input Mem_to_Reg_o,
	input Reg_Write_o,
	
	output reg [72:0] DataOutput
);
wire [72:0] datos;

assign datos = {Reg_Write_o,ALUresult,DataInputR2,DataInputRD,Mem_Read_o,Mem_Write_o,Mem_to_Reg_o};

always@(negedge reset or negedge clk) begin
	if(reset==0)
		DataOutput<=initvalue;
		
	else	
		if(enable==1)
			DataOutput<=datos;
			
			
end

endmodule
