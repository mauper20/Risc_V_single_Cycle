module RegisterFIN
#(
	parameter initvalue = 0
)
(
	input clk,
	input reset,
	input enable,
	input memwrite,
	
	output reg DataOutMEM_WB
);
wire datos;
assign datos = {memwrite};

always@(negedge reset or negedge clk) 
	begin	
		/*if(Flush==1)
			DataOutMEM_WB<=initvalue;
		else*/
		if(reset==0)
			DataOutMEM_WB<=initvalue;
		
		else	
		if(enable==1)
			DataOutMEM_WB<=datos;
	end
endmodule