
module hazard_detection_unit
(

input ID_EXMemRead,
input[4:0] IF_IDRs1, IF_IDRs2, ID_EXRd,
input Branch,
input clk,
output reg stall,
output reg Flush
);
always @(ID_EXMemRead, IF_IDRs1, IF_IDRs2, ID_EXRd)
	begin
	  if((ID_EXMemRead ) && ((ID_EXRd ==IF_IDRs1)||(ID_EXRd ==IF_IDRs2)))
	    begin
	      stall = 1;
	    end
	  else
	    begin
	      stall = 0;
	    end
	end
always @(posedge clk)
	begin
		if(Branch)
			begin
				Flush= 1;
			end
		else
			begin
				Flush= 0;
	      end
	end
endmodule